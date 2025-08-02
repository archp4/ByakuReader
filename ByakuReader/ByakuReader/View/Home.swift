//
//  Home.swift
//  ByakuReader
//
//  Created by Yash Vipul Naik on 2025-06-13.
//

import SwiftUI

struct HomeView: View {
    
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
                
            }
            
        }
        
    }
    
    
    private func loadAllSections() async {
        AppwriteManager.shared.f { result in
            switch result {
                case .success(let comics): trendingComics = comics
                case .failure(let err): print("Trending error:", err)
            }
        }
        
        AppwriteManager.shared.fetchContinueReading(for: user.id) { result in
            switch result {
                case .success(let comics): continueReadingComics = comics
                case .failure(let err): print("Continue Reading error:", err)
            }
        }

        AppwriteManager.shared.fetchMyList(for: user.id ) {
            result in
            switch result {
                case .success(let comics): myListComics = comics
                case .failure(let err): print("My List error:", err)
            }
            
        }
        
    }
    
}
