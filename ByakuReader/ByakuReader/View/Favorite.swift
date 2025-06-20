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
        Comic(
            title: "Shadow Weavers",
            subtitle: "The Ancient Prophecy",
            author: ["K. Blackwood"],
            genre: ["Fantasy", "Mystery"],
            description: "A secret society of mages fights to protect the world from dark magic.",
            imageID: "https://picsum.photos/id/208/200/300",
            isComplete: false,
            chapter: 18
        ),
        Comic(
            title: "Neon Nexus",
            subtitle: "City of Dreams and Danger",
            author: ["L. Jett"],
            genre: ["Cyberpunk", "Action"],
            description: "In a sprawling futuristic city, a street-level detective uncovers a vast conspiracy.",
            imageID: "https://picsum.photos/id/209/200/300",
            isComplete: false,
            chapter: 10
        ),
        Comic(
            title: "Crimson Tide",
            author: ["M. Vanguard"],
            genre: ["Horror", "Thriller"],
            description: "A chilling tale of a remote island haunted by a vengeful spirit.",
            imageID: "https://picsum.photos/id/210/200/300",
            isComplete: true,
            chapter: 22
        ),
        Comic(
            title: "Starborne Legends",
            subtitle: "Journey Through the Cosmos",
            author: ["N. Stardust"],
            genre: ["Sci-Fi", "Adventure"],
            description: "Explorers venture into unknown galaxies to discover ancient civilizations.",
            imageID: "https://picsum.photos/id/211/200/300",
            isComplete: false,
            chapter: 3
        ),
        Comic(
            title: "The Gilded Age",
            author: ["O. Pennyworth"],
            genre: ["Historical", "Drama"],
            description: "A captivating look into the lives of a wealthy family during a transformative era.",
            imageID: "https://picsum.photos/id/212/200/300",
            isComplete: true,
            chapter: 45
        ),
        Comic(
            title: "Whispers of the Wild",
            subtitle: "Nature's Untold Stories",
            author: ["P. Green"],
            genre: ["Adventure", "Fantasy"],
            description: "A young druid connects with the ancient spirits of the forest to save their home.",
            imageID: "https://picsum.photos/id/213/200/300",
            isComplete: true,
            chapter: 35
        ),
        Comic(
            title: "The Silicon Soul",
            author: ["Q. Byte"],
            genre: ["Sci-Fi", "Philosophy"],
            description: "An AI gains sentience and questions the nature of its existence.",
            imageID: "https://picsum.photos/id/214/200/300",
            isComplete: true,
            chapter: 60
        )
    ]
    
    // You might want to filter these based on search text later
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
        NavigationStack {
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
