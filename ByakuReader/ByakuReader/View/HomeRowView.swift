//
//  HomeRowView.swift
//  ByakuReader
//
//  Created by Yash Vipul Naik on 2025-06-20.
//

import SwiftUI

struct HomeRowView: View {
    let title: String
    let comics: [Comic]
    let itemWidth: CGFloat
    let itemHeight: CGFloat

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.title3)
                .fontWeight(.semibold)
                .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 12) {
                    ForEach(comics) { comic in
                        MediumComicTile(comic: comic, width: itemWidth, height: itemHeight)
                            .frame(width: itemWidth, height: itemHeight)
                            .contentShape(Rectangle()) // Improve tap area
                            .onTapGesture {
                                // Placeholder for future navigation
                                print("Tapped on: \(comic.title)")
                            }
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(.vertical, 4)
    }
}
