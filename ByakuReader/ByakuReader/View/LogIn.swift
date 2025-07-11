//
//  LogIn.swift
//  ByakuReader
//
//  Created by Yash Vipul Naik on 2025-06-13.
//

import SwiftUI

struct LogIn: View {
    @Binding var authFlow: AuthViewManager
    @State var email: String = ""
    @State var password: String = ""
    @EnvironmentObject var user : User
    
    let appwrite = Appwrite()
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isLoginSuccessful = false
    
    var body: some View {
        NavigationStack{
            TextField("Enter Email",text: $email)
                .padding()
            SecureField("Enter Password", text: $password)
                .padding()
            Button(
                action: {
                    Task {
                        if email.isEmpty || password.isEmpty {
                            alertMessage = "Please enter both email and password."
                            showAlert = true
                        } else {
                            let value = await appwrite.onLogin(email.lowercased(), password)
                            if value {
                                authFlow = .home
                            }else {
                                alertMessage = "Invalid credentials."
                                showAlert = true
                            }
                            
                        }
                    }
                },
                label: {
                    Text("Login")
                }
            )
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Incomplete Information"),
                      message: Text(alertMessage),
                      dismissButton: .default(Text("OK")))
            }
            .buttonStyle(.borderedProminent)
            Spacer()
            Button("Don't have an account? Sign Up"){
                authFlow = .signUp
            }
            .navigationTitle("Login")
        }
    }
}

#Preview {
    LogIn(authFlow:.constant(.signIn)).environmentObject(User())
}
