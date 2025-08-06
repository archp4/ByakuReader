//
//  MediumChapterTile.swift
//  ByakuReader
//
//  Created by Yash Vipul Naik on 2025-06-17.
//

import SwiftUI

struct MediumComicTile: View {
    let comic: Comic
    let width: CGFloat
    let height: CGFloat
    @State var showDetail : Bool = false
    @EnvironmentObject var user : UserAppwriteDetail
    
    var body: some View {
        VStack(alignment: .leading) {
            AsyncImage(url: URL(string: comic.imageId)) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .scaledToFill()
                } else if phase.error != nil {
                    Color.gray
                } else {
                    ProgressView()
                }
            }
            .frame(width: width, height: height)
            .cornerRadius(8)
            .clipped()
            
            Text(comic.title)
                .font(.headline)
                .lineLimit(1)
                .frame(width: width, alignment: .leading)
            if let subtitle = comic.subtitle {
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(1)
                    .frame(width: width, alignment: .leading)
            } else {
                Spacer().frame(width: 20)
            }
            
        }
        .onTapGesture {
            showDetail = true
        }
        .navigationDestination(isPresented: $showDetail) {
            Detail(comic: comic).environmentObject(user)
        }
    }
}
