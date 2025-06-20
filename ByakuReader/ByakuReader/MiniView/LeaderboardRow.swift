//
//  LeaderboardRow.swift
//  ByakuReader
//
//  Created by Arch Umeshbhai Patel on 2025-06-20.
//

import SwiftUI

struct LeaderboardRow: View {
    let item: LeaderboardItem
    
    var body: some View {
        HStack{
            AsyncImage(url: URL(string: item.imageName)){ phase in
                if let image = phase.image{
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 60, height: 80)
                        .cornerRadius(8)
                        .shadow(radius: 3)
                } else if phase.error != nil {
                    Color.gray
                        .scaledToFill()
                        .frame(width: 60, height: 80)
                        .cornerRadius(8)
                        .shadow(radius: 3)
                } else {
                    ProgressView()
                }
            }
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
        .padding(.vertical, 8)
        
    }
    
}
#Preview {
    LeaderboardRow(
        item: LeaderboardItem(rank: 7, imageName: "book7", title: "The Emerald Enigma", views: "70K views", score: "70K"))
}
