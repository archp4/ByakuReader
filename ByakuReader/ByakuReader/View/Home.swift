//
//  Home.swift
//  ByakuReader
//
//  Created by Yash Vipul Naik on 2025-06-13.
//

import SwiftUI

struct Home: View {
    
    @Binding var authFlow: AuthViewManager
    @State private var trendingComics: [Comic] = []
    @State private var continueReadingComics: [Comic] = []
    @State private var myListComics: [Comic] = []
    
    private let itemWidth: CGFloat = 150
    private let itemHeight: CGFloat = 225
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    if !trendingComics.isEmpty {
                        HomeRowView(
                            title: "Trending Now",
                            comics: trendingComics,
                            itemWidth: itemWidth,
                            itemHeight: itemHeight
                        )
                    }
                    if !continueReadingComics.isEmpty {
                        HomeRowView(
                            title: "Continue Reading",
                            comics: continueReadingComics,
                            itemWidth: itemWidth,
                            itemHeight: itemHeight
                        )
                    }
                    if !myListComics.isEmpty {
                        HomeRowView(
                            title: "My List",
                            comics: myListComics,
                            itemWidth: itemWidth,
                            itemHeight: itemHeight
                        )
                    }
                    if trendingComics.isEmpty && continueReadingComics.isEmpty && myListComics.isEmpty {
                        Text("Loading your comics…")
                            .foregroundColor(.gray)
                            .padding()
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.inline)
            .task {
                await loadAllSections()
            }.toolbar{
                ToolbarItem(placement: .topBarTrailing){
                    Button{
                        authFlow = .signIn
                    } label: {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                    } // button
                }// toolbar item 1
                ToolbarItem(placement: .topBarLeading){
                    Button{
                        
                    } label: {
                        Image(systemName: "person")
                            .frame(width: 40, height: 40)
                    }
                }// toolbar item 2
            }// tool bar
        }
    }
    private func loadAllSections() async {
        do {
            let user = try await AppwriteManager.shared.getUser()
            AppwriteManager.shared.fetchUserComics(userId: user.id){ result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let data):
                        self.continueReadingComics = data.continueReading
                        self.myListComics = data.myList
                        self.trendingComics = data.treading
                    case .failure(let error):
                        print("Failed to load user comics:", error)
                    }
                }
            }
        } catch {
            print(error)
        }
    }
    
}
#Preview {
    Home(authFlow : .constant(.home))
}
