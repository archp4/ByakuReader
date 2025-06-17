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
    var body: some View {
        NavigationStack{
            TextField("Enter Email",text: $email)
                .padding()
            SecureField("Enter Password", text: $password)
                .padding()
            Button("Login"){
                authFlow = .home
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
