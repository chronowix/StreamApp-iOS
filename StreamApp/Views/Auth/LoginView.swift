//
//  LoginView.swift
//  StreamApp
//
//  Created by Cours on 05/02/2026.
//

import SwiftUI

struct LoginView: View {
    //récupération du ViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State private var email: String = ""
    @State private var password: String = ""
    
    var body: some View {
        VStack(spacing: 20){
            Text("Connexion").font(.largeTitle).bold()
            
            TextField("Email", text: $email)
                .textFieldStyle(.roundedBorder)
                .textInputAutocapitalization(.never)
                .keyboardType(.emailAddress)
            
            SecureField("Mot de passe", text: $password)
                .textFieldStyle(.roundedBorder)
                .textContentType(.password)
                .autocapitalization(.none)
                .keyboardType(.asciiCapable)
            
            Button(action: {
                self.authViewModel.login(email: self.email, password: self.password)
            }) {
                Text("Se connecter")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
            NavigationLink(destination: RegisterView()){
                Text("Pas de compte ? Inscrivez-vous").font(.caption)
            }
        }
        .padding()
        .navigationTitle("StreamApp")
    }
}

#Preview {
    NavigationStack{
        LoginView().environmentObject(AuthViewModel())
    }
}
