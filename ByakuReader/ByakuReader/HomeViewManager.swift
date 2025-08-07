//
//  HomeViewManager.swift
//  ByakuReader
//
//  Created by Arch Umeshbhai Patel on 2025-06-13.
//

import SwiftUI

struct HomeViewManager: View {
    @Binding var authFlow: AuthViewManager
    @EnvironmentObject var user : UserAppwriteDetail
    var body: some View {
        NavigationStack{
            TabView{
                Home(authFlow: $authFlow).tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
//                Favorite().tabItem {
//                    Image(systemName: "heart.fill")
//                    Text("My Favourite")
//                }
                LeaderboardView(rankings: [:]).tabItem {
                    Image(systemName: "trophy.fill")
                    Text("Leaderboard")
                }
            }
        }
    }
}
#Preview {
    HomeViewManager(authFlow:.constant(.home)).environmentObject(UserAppwriteDetail())
}
