//
//  RegisterView.swift
//  StreamApp
//
//  Created by Cours on 05/02/2026.
//

import SwiftUI

struct RegisterView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss //pour fermer la vue
    
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    
    var body: some View {
        VStack(spacing: 20){
            Text("Créer un compte").font(.largeTitle).bold()
            
            TextField("Nom d'utilisateur", text: $username).textFieldStyle(.roundedBorder)
            
            TextField("Email", text: $email)
                .textFieldStyle(.roundedBorder)
                .textInputAutocapitalization(.never)
                .keyboardType(.emailAddress)
            
            
            SecureField("Mot de passe", text: $password).textFieldStyle(.roundedBorder)
            
            if let errorMessage = authViewModel.errorMessage {
                Text(errorMessage).foregroundColor(.red).font(.caption)
            }
            
            Button(action: {
                authViewModel.register(username: username, email: email, password: password)
                //si succès: fermer la vue
                if authViewModel.isLoggedIn {
                    dismiss()
                }
            }) {
                Text("S'inscrire")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
        .navigationTitle("Inscription")
    }
}

#Preview {
    NavigationStack {
        RegisterView().environmentObject(AuthViewModel())
    }
}
