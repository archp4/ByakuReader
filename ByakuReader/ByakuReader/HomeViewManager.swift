//
//  HomeViewManager.swift
//  ByakuReader
//
//  Created by Arch Umeshbhai Patel on 2025-06-13.
//

import SwiftUI

struct HomeViewManager: View {
    @Binding var authFlow: AuthViewManager
    @EnvironmentObject var user : User
    var body: some View {
        TabView{

            Home().tabItem {
                Image(systemName: "house.fill")
                Text("Home")
            }
            Favorite().tabItem {
                Image(systemName: "heart.fill")
                Text("My Favourite")
            }
            Leaderboard().tabItem {
                Image(systemName: "trophy.fill")
                Text("Leaderboard")
            }
        }
    }
}
#Preview {
    HomeViewManager(authFlow:.constant(.home)).environmentObject(User())
}
