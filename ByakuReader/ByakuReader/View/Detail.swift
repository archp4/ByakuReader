//
//  Detail.swift
//  ByakuReader
//
//  Created by Yash Vipul Naik on 2025-06-13.
//

import SwiftUI

struct Detail: View {
    let comic: Comic

    @State var showChapter : Bool = false
    var items: [String] {
        guard comic.chapter > 0 else { return [] }
        return (1...comic.chapter).map { "\($0)" }
    }
    @State private var locationService = LocationService()
    @State var chapterIdHolder : String = ""
    @EnvironmentObject var user : UserAppwriteDetail
    
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
                        Button("Chapter \(item)") {
                            chapterIdHolder = "\(comic.id)_\(item)"
                            let temp = ReadingProgress(id: "\(user.userId)\(item)\(String(comic.id.prefix(4)))", userId: user.userId, comicId: comic.id, chapterId: chapterIdHolder)

                            
                            locationService.onLocationUpdate = { state, country in
                                let s = state ?? "Unknown"
                                let c = country ?? "Unknown"
                                let tempEn = ComicEngagement(id: "", comicId: comic.id, userId: user.userId, interactionType: "view_chapter", timestamp: Date(), country: c, state: s)
                                Task{
                                    await Appwrite().insertComicEngagement(_:tempEn)
                                }
                            }
                            locationService.start()
                            Task{
                                await Appwrite().insertReadingProgress(progress:temp)
                            }
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
                ComicChapterView(chapterId: chapterIdHolder)
            }
            .navigationTitle(comic.title)
            .navigationBarTitleDisplayMode(.inline)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

