//
//  Home.swift
//  ByakuReader
//
//  Created by Yash Vipul Naik on 2025-06-13.
//

import SwiftUI

struct Home: View {
    
    @Binding var authFlow: AuthViewManager
    @State var email: String = ""
    @State var password: String = ""
    @EnvironmentObject var user : User
    @State var searchText : String = ""
    let comicCategories: [String: [Comic]] = [
        "Trending Now": [
            Comic(
                title: "Galactic Guardians",
                subtitle: "The Universe's Last Hope",
                author: ["A. Nova", "B. Thorne"],
                genre: ["Sci-Fi", "Action"],
                description: "A team of unlikely heroes defends the galaxy from cosmic threats.",
                imageID: "https://picsum.photos/id/200/200/300",
                isComplete: false,
                chapter: 12
            ),
            Comic(
                title: "Mystic Realm",
                // No subtitle for this one, it will default to nil
                author: ["C. Lunar"],
                genre: ["Fantasy", "Adventure"],
                description: "Journey into a world of magic, mythical creatures, and ancient prophecies.",
                imageID: "https://picsum.photos/id/201/200/300",
                isComplete: true,
                chapter: 50
            ),
            Comic(
                title: "Cyberpunk Alley",
                subtitle: "Where Code Meets Crime", 
                author: ["D. Jax", "E. Quinn"],
                genre: ["Cyberpunk", "Thriller"],
                description: "In a neon-drenched future, a lone hacker uncovers a vast conspiracy.",
                imageID: "https://picsum.photos/id/202/200/300",
                isComplete: false,
                chapter: 8
            )
        ],
        "Continue Reading": [
            Comic(
                title: "Dragon's Breath",
                subtitle: "A Tale of Fire and Fate",
                author: ["F. Stone"],
                genre: ["Fantasy", "Drama"],
                description: "A young dragon learns to harness its power while navigating a world that fears it.",
                imageID: "https://picsum.photos/id/203/200/300",
                isComplete: false,
                chapter: 25
            ),
            Comic(
                title: "Vigilante Squad",
                author: ["G. Blade"],
                genre: ["Action", "Crime"],
                description: "A group of masked vigilantes takes justice into their own hands.",
                imageID: "https://picsum.photos/id/204/200/300",
                isComplete: false,
                chapter: 7
            )
        ],
        "My List": [
            Comic(
                title: "The Last Sorcerer",
                author: ["H. Wren"],
                genre: ["Fantasy", "Mystery"],
                description: "The last remaining sorcerer seeks answers about a forgotten past.",
                imageID: "https://picsum.photos/id/205/200/300",
                isComplete: true,
                chapter: 30
            ),
            Comic(
                title: "Space Pirates",
                author: ["I. Rook"],
                genre: ["Sci-Fi", "Comedy"],
                description: "A comedic tale of a ragtag crew of space pirates and their misadventures.",
                imageID: "https://picsum.photos/id/206/200/300",
                isComplete: false,
                chapter: 15
            ),
            Comic(
                title: "Echoes of Time",
                author: ["J. Verse"],
                genre: ["Historical", "Supernatural"],
                description: "A young woman discovers she can communicate with historical figures.",
                imageID: "https://picsum.photos/id/207/200/300",
                isComplete: false,
                chapter: 9
            )
        ]
    ]
    private let title = [
        "Afghanistan", "Albania", "Algeria", "Andorra", "Angola", "Antigua and Barbuda", "Argentina", "Armenia", "Australia", "Austria"
    ]
    
    private var searchResults : [String] {
        searchText.isEmpty ? title : title.filter { $0.contains(searchText) }
    }
    
    var body: some View {
        
        NavigationStack{
            VStack{
                
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 20) {
                        ForEach(comicCategories.keys.sorted(), id: \.self) { category in
                            // Pass the category title and the array of Comics for that category
                            HomeRowView(title: category, comics: comicCategories[category]!, itemWidth: 150, itemHeight: 225)
                        }
                    }
                    .padding(.vertical) // Add some vertical padding to the VStack for better spacing
                }
                
            } // VStack
            .searchable(text: $searchText)
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
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
        } // navigation stack
    } // body
} // home

#Preview {
    Home(authFlow:.constant(.home)).environmentObject(User())
}
