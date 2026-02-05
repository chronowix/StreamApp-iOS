//
//  ProfileView.swift
//  StreamApp
//
//  Created by Cours on 05/02/2026.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State private var isEditing: Bool = false
    @State private var editedUsername = ""
    @State private var editedEmail = ""
    
    var body: some View{
        NavigationStack{
            if let user = authViewModel.currentUser{
                Form{
                    //section infos user
                    Section("Informations"){
                        if isEditing{
                            //edit mode
                            TextField("Username", text: $editedUsername)
                            TextField("Email", text: $editedEmail)
                                .textInputAutocapitalization(.never)
                                .keyboardType(.emailAddress)
                        } else {
                            //read mode
                            HStack{
                                Text("Username")
                                Spacer()
                                Text(user.username)
                                    .foregroundColor(.gray)
                            }
                            HStack{
                                Text("Email")
                                Spacer()
                                Text(user.email)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    
                    //stats
                    Section("Statistiques"){
                        HStack{
                            Text("Films favoris")
                            Spacer()
                            Text("\(user.favoriteMovieIds.count)")
                                .foregroundColor(.gray)
                        }
                    }
                    
                    //actions
                    Section{
                        if isEditing{
                            Button("Enregistrer"){
                                saveChanges()
                            }
                            .foregroundColor(.blue)
                            
                            Button("Annuler"){
                                cancelEditing()
                            }
                            .foregroundColor(.gray)
                        } else {
                            //modifier
                            Button("Modifier le profil"){
                                startEditing()
                            }
                        }
                        
                        Button("Se déconnecter"){
                            authViewModel.logout()
                        }
                        .foregroundColor(.red)
                    }
                }
                .navigationTitle("Profil")
            }
        }
    }
    
    func startEditing(){
        if let user = authViewModel.currentUser{
            editedUsername = user.username
            editedEmail = user.email
            isEditing = true
        }
    }
    
    func cancelEditing(){
        isEditing = false
        editedEmail = ""
        editedUsername = ""
    }
    
    func saveChanges(){
        guard var user = authViewModel.currentUser else {return}
        
        user.username = editedUsername
        user.email = editedEmail
        
        PersistenceService.shared.updateUser(user)
        
        authViewModel.currentUser = user
        
        isEditing = false
    }
}

#Preview {
    ProfileView()
        .environmentObject(AuthViewModel())
}
