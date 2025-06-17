//
//  SignUp.swift
//  ByakuReader
//
//  Created by Yash Vipul Naik on 2025-06-13.
//

import SwiftUI

struct SignUp: View {
    @Binding var authFlow: AuthViewManager
    @State var email: String = ""
    @State var username: String = ""
    @State var confirmPassword: String = ""
    @State var password: String = ""
    @EnvironmentObject var user : User
    var body: some View {
        NavigationStack{
            TextField("Enter Name",text: $username)
                .padding()
            TextField("Enter Email",text: $email)
                .padding()
            SecureField("Enter Password", text: $password)
                .padding()
            SecureField("Enter Confirm Password", text: $confirmPassword)
                .padding()
            Button("Sign Up"){
                authFlow = .home
            }
            .buttonStyle(.borderedProminent)
            .frame(width: .infinity)
            Spacer()
            Button("Already have account? Login"){
                authFlow = .signIn
            }
            .navigationTitle("Create Your Account")
        }
    }
}

#Preview {
    SignUp(authFlow:.constant(.signUp)).environmentObject(User())
}
