//
//  HomeRowView.swift
//  ByakuReader
//
//  Created by Yash Vipul Naik on 2025-06-20.
//

import SwiftUI

struct HomeRowView: View {
    
    let title : String
    let comics : [Comic]
    let itemWidth: CGFloat
    let itemHeight: CGFloat
    @EnvironmentObject var user : UserAppwriteDetail
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
                .padding(.leading)
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 10) {
                    ForEach(comics) { comic in
                        MediumComicTile(comic: comic, width: itemWidth, height: itemHeight)
                            .environmentObject(user)
                            .onTapGesture {
                                print("Tapped on: \(comic.title)")
                            }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}
