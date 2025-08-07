//
//  SignUp.swift
//  ByakuReader
//
//  Created by Yash Vipul Naik on 2025-06-13.
//

import SwiftUI

struct SignUp: View {
    @Binding var authFlow: AuthViewManager
    let appwrite = Appwrite()
    @State var email: String = ""
    @State var username: String = ""
    @State var confirmPassword: String = ""
    @State var password: String = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @EnvironmentObject var user : UserAppwriteDetail
    var body: some View {
        NavigationStack{
//            TextField("Enter Name",text: $username)
//                .padding()
            TextField("Enter Email",text: $email)
                .padding()
            SecureField("Enter Password", text: $password)
                .padding()
//            SecureField("Enter Confirm Password", text: $confirmPassword)
//                .padding()
            Button("Sign Up"){
                Task{
                    if email.isEmpty || password.isEmpty {
                        alertMessage = "Please enter both email and password."
                        showAlert = true
                    } else {
                        await appwrite.onRegister(email, password) { result in
                            switch result {
                            case .success(let userData):
                                alertMessage = "Account Created, You can Login now"
                                showAlert = true
                                authFlow = .home
                                user.userId = userData.userId
                                user.$userEmail = userData.$userEmail
                                user.userPassword = userData.userPassword
                            case .failure(let error):
                                alertMessage = "Appwrite Errr \(error)"
                                showAlert = true
                            default:
                                alertMessage = "Invalid credentials."
                                showAlert = true
                                
                            }
                        }
                        
                    }
                }
            }
            .buttonStyle(.borderedProminent)
            Spacer()
            Button("Already have account? Login"){
                authFlow = .signIn
            }
            .navigationTitle("Create Your Account")
        }.alert(isPresented: $showAlert) {
            Alert(title: Text("Alert"),
                  message: Text(alertMessage),
                  dismissButton: .default(Text("OK")))
        }
    }
}


#Preview {
    SignUp(authFlow:.constant(.signUp)).environmentObject(UserAppwriteDetail())
}
