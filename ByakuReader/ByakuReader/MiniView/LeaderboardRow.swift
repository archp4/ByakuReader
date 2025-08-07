//
//  LeaderboardRow.swift
//  ByakuReader
//
//  Created by Arch Umeshbhai Patel on 2025-06-20.
//

import SwiftUI

struct LeaderboardRow: View {
    let width: CGFloat = 60
    let height: CGFloat = 80
    let item: LeaderboardItem
    @State private var imageUrl: String?
    @State private var loading = false
    @State private var error: Error?
    
    var body: some View {
        HStack{
            if let imageUrl = imageUrl, let url = URL(string: imageUrl) {
                AsyncImage(url: url) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .scaledToFill()
                    } else if phase.error != nil {
                        Color.gray
                    } else {
                        ProgressView()
                    }
                }.frame(width: width, height: height)
                    .cornerRadius(8)
                    .clipped()
            } else if loading {
                ProgressView().frame(width: width, height: height)
            } else if error != nil {
                Color.red
                    .frame(width: width, height: height)
                    .cornerRadius(8)
                    .overlay(Text("Failed to load image").foregroundColor(.white))
            } else {
                Color.gray
                    .frame(width: width, height: height)
                    .cornerRadius(8)
                    .overlay(Text("No image URL"))
            }
            VStack(alignment: .leading, spacing: 0) {
                // Rank and Title
                Text("\(item.rank). \(item.comic.title)")
                    .font(.headline)
                    .fontWeight(.medium)
                // Views count
                Text("")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding(.leading, 10)
        } 
        .padding(.vertical, 8)
            .onAppear{
                loadImageUrl()
            }
        
    }
    
    func loadImageUrl() {
        loading = true
        error = nil
        Task {
            do {
                let url = await Appwrite().fetchImageUrl(key: item.comic.imageId)
                imageUrl = url
            } catch {
                self.error = error
            }
            loading = false
        }
    }
    
}

