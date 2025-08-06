//
//  ContentView.swift
//  ByakuReader
//
//  Created by Arch Umeshbhai Patel on 2025-06-13.
//

import SwiftUI

struct ContentView: View {
    @State var authFlow: AuthViewManager =  .signIn
    @StateObject var user : UserAppwriteDetail = UserAppwriteDetail()
    var body: some View {
        switch authFlow {
        case .signUp:
            SignUp(authFlow: $authFlow).environmentObject(user)
        case .signIn:
            LogIn(authFlow: $authFlow).environmentObject(user)
        case .home:
            HomeViewManager(authFlow: $authFlow).environmentObject(user)
        }
    }
}

#Preview {
    ContentView()
}
