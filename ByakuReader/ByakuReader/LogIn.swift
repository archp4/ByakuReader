//
//  LogIn.swift
//  ByakuReader
//
//  Created by Yash Vipul Naik on 2025-06-13.
//

import SwiftUI

struct LogIn: View {
    @Binding var authFlow: AuthViewManager
    @EnvironmentObject var user : User
    var body: some View {
        Text("Login")
    }
}

#Preview {
    LogIn(authFlow:.constant(.signUp)).environmentObject(User())
}
