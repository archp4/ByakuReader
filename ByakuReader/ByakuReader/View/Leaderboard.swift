//
//  Leaderboard.swift
//  ByakuReader
//
//  Created by Yash Vipul Naik on 2025-06-13.
//

import SwiftUI

struct LeaderboardItem: Identifiable {
    let id = UUID()
    let rank: Int
    let imageName: String // Assuming image assets are in the project
    let title: String
    let views: String
    let score: String
}

// MARK: - Main Leaderboard View
struct LeaderboardView: View {
    // Sample data to populate the leaderboard
    let items: [LeaderboardItem] = [
        LeaderboardItem(rank: 1, imageName: "book1", title: "The Last Hope", views: "100K views", score: "100K"),
        LeaderboardItem(rank: 2, imageName: "book2", title: "Cosmic Crusaders", views: "95K views", score: "95K"),
        LeaderboardItem(rank: 3, imageName: "book3", title: "Galactic Guardians", views: "90K views", score: "90K"),
        LeaderboardItem(rank: 4, imageName: "book4", title: "The Quantum Quest", views: "85K views", score: "85K"),
        LeaderboardItem(rank: 5, imageName: "book5", title: "Shadow Syndicate", views: "80K views", score: "80K"),
        LeaderboardItem(rank: 6, imageName: "book6", title: "The Crimson Comet", views: "75K views", score: "75K"),
        LeaderboardItem(rank: 7, imageName: "book7", title: "The Emerald Enigma", views: "70K views", score: "70K"),
        LeaderboardItem(rank: 8, imageName: "book8", title: "The Obsidian Order", views: "65K views", score: "65K"),
        LeaderboardItem(rank: 9, imageName: "book9", title: "The Silver Serpent", views: "60K views", score: "60K"),
        LeaderboardItem(rank: 10, imageName: "book10", title: "The Golden Gryphon", views: "55K views", score: "55K")
    ]

    // State variables for the dropdown selections
    @State private var selectedRegion: String = "Region"
    @State private var selectedViewFilter: String = "Most Viewed"

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                HStack {
                    Spacer().frame(width: 20)
                    // Region Dropdown
                    Menu {
                        Button("North America") { selectedRegion = "North America" }
                        Button("Europe") { selectedRegion = "Europe" }
                        Button("Asia") { selectedRegion = "Asia" }
                    } label: {
                        Label(selectedRegion, systemImage: "chevron.down")
                            .font(.subheadline)
                            .padding(.horizontal, 15)
                            .padding(.vertical, 8)
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                            .foregroundColor(.primary)
                    }

                    // Most Viewed Dropdown
//                    Menu {
//                        Button("Most Viewed") { selectedViewFilter = "Most Viewed" }
//                        Button("Highest Rated") { selectedViewFilter = "Highest Rated" }
//                        Button("Newest") { selectedViewFilter = "Newest" }
//                    } label: {
//                        Label(selectedViewFilter, systemImage: "chevron.down")
//                            .font(.subheadline)
//                            .padding(.horizontal, 15)
//                            .padding(.vertical, 8)
//                            .background(Color(.systemGray6))
//                            .cornerRadius(10)
//                            .foregroundColor(.primary)
//                    }
                    Spacer()
                }
                .padding(.bottom, 20)

                // MARK: - Leaderboard List
                // Using List for scrollable, structured content
                List(items) { item in
                    LeaderboardRow(item: item)
                }
                // Removes default List insets
                .listStyle(PlainListStyle())
                .padding(.horizontal, -20) // Adjust horizontal padding to match the image
            }
            .navigationTitle("Leaderboard")
            .font(.largeTitle)
            .fontWeight(.bold)
            .padding(.bottom, 20)
            .padding(.top, 10)
            .edgesIgnoringSafeArea(.horizontal) // Extends content to the edges horizontally
        }
    }
}

// MARK: - Leaderboard Row View
struct LeaderboardRow: View {
    let item: LeaderboardItem

    var body: some View {
        HStack {
            Spacer().frame(width: 20)
            Image(systemName: "house") // Make sure you add these images to your Assets.xcassets
                .resizable()
                .scaledToFill()
                .frame(width: 60, height: 80)
                .cornerRadius(8)
                .shadow(radius: 3)

            VStack(alignment: .leading, spacing: 0) {
                // Rank and Title
                Text("\(item.rank). \(item.title)")
                    .font(.headline)
                    .fontWeight(.medium)
                // Views count
                Text(item.views)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding(.leading, 10)
        }
        .padding(.vertical, 8) // Vertical padding for each row
    }
}

// MARK: - Preview Provider (for Xcode Canvas)
struct LeaderboardView_Previews: PreviewProvider {
    static var previews: some View {
        LeaderboardView()
    }
}

