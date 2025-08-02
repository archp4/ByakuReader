//
//  ContentView.swift
//  ByakuReader
//
//  Created by Arch Umeshbhai Patel on 2025-06-13.
//

import SwiftUI

struct ContentView: View {
    @State var authFlow: AuthViewManager =  .signIn
    var body: some View {
        switch authFlow {
        case .signUp:
            SignUp(authFlow: $authFlow)
        case .signIn:
            LogIn(authFlow: $authFlow)
        case .home:
            HomeViewManager(authFlow: $authFlow)
        }
    }
}

#Preview {
    ContentView()
}
