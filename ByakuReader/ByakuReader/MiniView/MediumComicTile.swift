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
    @State private var imageUrl: String?
    @State private var loading = false
    @State private var error: Error?
    
    var body: some View {
        VStack(alignment: .leading) {
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
            
        }.onAppear{
            loadImageUrl()
        }.onTapGesture {
            showDetail = true
        }
        .navigationDestination(isPresented: $showDetail) {
            Detail(comic: comic).environmentObject(user)
        }
    }
    
    func loadImageUrl() {
        loading = true
        error = nil
        Task {
            do {
                let url = await Appwrite().fetchImageUrl(key: comic.imageId)
                imageUrl = url
            } catch {
                self.error = error
            }
            loading = false
        }
    }
}
