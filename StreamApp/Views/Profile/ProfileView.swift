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
    
    @AppStorage("selectedTheme") var selectedTheme: String = Theme.system.rawValue
    
    
    var body: some View{
        NavigationStack{
            if let user = authViewModel.currentUser{
                Form{
                    // section infos utilisateur
                    Section("Informations"){
                        if isEditing{
                            // edit mode
                            TextField("Username", text: $editedUsername)
                            TextField("Email", text: $editedEmail)
                                .textInputAutocapitalization(.never)
                                .keyboardType(.emailAddress)
                        } else {
                            // mode lecture
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
                    
                    // stats de films favoris
                    Section("Statistiques"){
                        HStack{
                            Text("Films favoris")
                            Spacer()
                            Text("\(user.favoriteMovieIds.count)")
                                .foregroundColor(.gray)
                        }
                    }
                    
                    // changement de thème de l'appli
                    Section("Apparence"){
                        Picker("Thème", selection: $selectedTheme){
                            Text("Sombre").tag(Theme.dark.rawValue)
                            Text("Clair").tag(Theme.light.rawValue)
                            Text("Système").tag(Theme.system.rawValue)
                        }
        
                        .pickerStyle(.navigationLink)
                    }
                    
                    // actions
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
                            // modification du profil
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
    // pour éditer le profil
    func startEditing(){
        if let user = authViewModel.currentUser{
            editedUsername = user.username
            editedEmail = user.email
            isEditing = true
        }
    }
    
    // pour annuler l'édition
    func cancelEditing(){
        isEditing = false
        editedEmail = ""
        editedUsername = ""
    }
    
    // pour sauvegarder les changements
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
