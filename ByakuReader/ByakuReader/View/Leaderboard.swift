//
//  Leaderboard.swift
//  ByakuReader
//
//  Created by Yash Vipul Naik on 2025-06-13.
//

import SwiftUI

struct LeaderboardView: View {
    let items: [LeaderboardItem] = [
        LeaderboardItem(rank: 1, imageName: "https://fra.cloud.appwrite.io/v1/storage/buckets/6841a6700036753bfcfb/files/68449647b5d3814ac225/view?project=6840d2580002fa6b80ab", title: "The Last Hope", views: "100K views", score: "100K"),
        LeaderboardItem(rank: 2, imageName: "https://fra.cloud.appwrite.io/v1/storage/buckets/6841a6700036753bfcfb/files/68449647b5d3814ac225/view?project=6840d2580002fa6b80ab", title: "Cosmic Crusaders", views: "95K views", score: "95K"),
        LeaderboardItem(rank: 3, imageName: "https://fra.cloud.appwrite.io/v1/storage/buckets/6841a6700036753bfcfb/files/68449647b5d3814ac225/view?project=6840d2580002fa6b80ab", title: "Galactic Guardians", views: "90K views", score: "90K"),
        LeaderboardItem(rank: 4, imageName: "https://fra.cloud.appwrite.io/v1/storage/buckets/6841a6700036753bfcfb/files/68449647b5d3814ac225/view?project=6840d2580002fa6b80ab", title: "The Quantum Quest", views: "85K views", score: "85K"),
        LeaderboardItem(rank: 5, imageName: "https://fra.cloud.appwrite.io/v1/storage/buckets/6841a6700036753bfcfb/files/68449647b5d3814ac225/view?project=6840d2580002fa6b80ab", title: "Shadow Syndicate", views: "80K views", score: "80K"),
        LeaderboardItem(rank: 6, imageName: "https://fra.cloud.appwrite.io/v1/storage/buckets/6841a6700036753bfcfb/files/68449647b5d3814ac225/view?project=6840d2580002fa6b80ab", title: "The Crimson Comet", views: "75K views", score: "75K"),
        LeaderboardItem(rank: 7, imageName: "https://fra.cloud.appwrite.io/v1/storage/buckets/6841a6700036753bfcfb/files/68449647b5d3814ac225/view?project=6840d2580002fa6b80ab", title: "The Emerald Enigma", views: "70K views", score: "70K"),
        LeaderboardItem(rank: 8, imageName: "https://fra.cloud.appwrite.io/v1/storage/buckets/6841a6700036753bfcfb/files/68449647b5d3814ac225/view?project=6840d2580002fa6b80ab", title: "The Obsidian Order", views: "65K views", score: "65K"),
        LeaderboardItem(rank: 9, imageName: "https://fra.cloud.appwrite.io/v1/storage/buckets/6841a6700036753bfcfb/files/68449647b5d3814ac225/view?project=6840d2580002fa6b80ab", title: "The Silver Serpent", views: "60K views", score: "60K"),
        LeaderboardItem(rank: 10, imageName: "https://fra.cloud.appwrite.io/v1/storage/buckets/6841a6700036753bfcfb/files/68449647b5d3814ac225/view?project=6840d2580002fa6b80ab", title: "The Golden Gryphon", views: "55K views", score: "55K")
    ]

    @State private var selectedRegion: String = "Region"
    @State private var selectedViewFilter: String = "Most Viewed"
    @State var showDetail : Bool = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                HStack {
                    Spacer().frame(width: 20)
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
                    Spacer()
                }
                .padding(.bottom, 20)
                List(items) { item in
                    LeaderboardRow(item: item).onTapGesture {
                        showDetail = true
                    }
                }
                .listStyle(PlainListStyle())
                .padding(.horizontal, -20)
            }
            .navigationTitle("Leaderboard")
            .font(.largeTitle)
            .fontWeight(.bold)
            .padding(.bottom, 20)
            .padding(.top, 10)
            .edgesIgnoringSafeArea(.horizontal)
            .navigationDestination(isPresented: $showDetail) {
                Detail()
            }
        }
    }
}

// MARK: - Preview
#Preview {
    LeaderboardView()
}

