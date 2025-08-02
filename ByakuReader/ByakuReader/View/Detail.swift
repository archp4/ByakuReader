//
//  Detail.swift
//  ByakuReader
//
//  Created by Yash Vipul Naik on 2025-06-13.
//

import SwiftUI

struct Detail: View {
    let comic: Comic
    var items: [String] = ["Chapter 1", "Chapter 2"]
    @State var showChapter : Bool = false

    var body: some View {
        NavigationStack {
            AsyncImage(url: URL(string: comic.imageId)) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .frame(width: 400, height: 400)
                        .aspectRatio(contentMode: .fill)
                } else if phase.error != nil {
                    Color.gray
                        .frame(maxWidth: .infinity, maxHeight: 300)
                        .cornerRadius(8)
                        .shadow(radius: 3)
                } else {
                    ProgressView()
                }
            }
            Spacer().frame(height: 10)
            VStack(alignment: .leading) {
                Text("Description")
                Text(comic.description)
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, maxHeight: 140, alignment: .leading)

                HStack {
                    Text("Genre").font(.footnote)
                    Text(comic.genre.joined(separator: ", "))
                        .font(.footnote)
                        .foregroundColor(.gray)
                }

                Spacer().frame(height: 10)
                Text("Chapters").font(.title3).bold()

                Spacer().frame(height: 10)
                List {
                    ForEach(items, id: \.self) { item in
                        Button(item) {
                            showChapter = true
                        }
                    }
                    .listStyle(.inset)
                }
                .listStyle(PlainListStyle())
                .padding(EdgeInsets(top: -10, leading: -20, bottom: -20, trailing: -20))
            }
            .padding()
            .navigationDestination(isPresented: $showChapter) {
                ComicChapterView()
            }
            .navigationTitle(comic.title)
            .navigationBarTitleDisplayMode(.inline)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
