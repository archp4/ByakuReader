//
//  Favorite.swift
//  ByakuReader
//
//  Created by Yash Vipul Naik on 2025-06-13.
//

import SwiftUI
struct Favorite : View {
    
    @State var searchText : String = ""
    
    // Flattened array of all favorite comics
    let allFavoriteComics: [Comic] = [
    ]

    var filteredComics: [Comic] {
        if searchText.isEmpty {
            return allFavoriteComics
        } else {
            return allFavoriteComics.filter { $0.title.localizedCaseInsensitiveContains(searchText) || $0.subtitle?.localizedCaseInsensitiveContains(searchText) == true }
        }
    }
    
    // Define the desired width for your vertical list items
    // This will make them fit nicely, assuming a standard screen width
    private let comicItemWidth: CGFloat = 150
    private let comicItemHeight: CGFloat = 225
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) { // This ScrollView makes the *entire list* scroll vertically
                // Using LazyVGrid for a grid-like vertical display, or a simple VStack
                // LazyVGrid is often preferred for performance with many items
                LazyVGrid(columns: [GridItem(.adaptive(minimum: comicItemWidth), spacing: 20)], spacing: 20) {
                    ForEach(filteredComics) { comic in
                        MediumComicTile(comic: comic, width: comicItemWidth, height: comicItemHeight)
                            .onTapGesture {
                                print("Tapped on: \(comic.title)")
                                // Handle navigation to comic detail view
                            }
                    }
                }
                .padding(.horizontal) // Add horizontal padding for the grid
                .padding(.vertical)    // Add vertical padding for the scrollable content
            }
            .searchable(text: $searchText)
            .navigationTitle("Favorite")
        }
    }
}

#Preview {
    Favorite()
}
