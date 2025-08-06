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
    
    @State private var imageUrl: String?
    @State private var loading = false
    @State private var error: Error?
    
    var body: some View {
        NavigationStack {
            if let imageUrl = imageUrl, let url = URL(string: imageUrl) {
                AsyncImage(url: url) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .frame(width: 400, height: 400)
                            .aspectRatio(contentMode: .fill)
                    } else if phase.error != nil {
                        Color.gray
                            .frame(width: 400, height: 400)
                            .cornerRadius(8)
                            .shadow(radius: 3)
                    } else {
                        ProgressView()
                            .frame(width: 400, height: 400)
                    }
                }
            } else if loading {
                ProgressView().frame(width: 400, height: 400)
            } else if error != nil {
                Color.red
                    .frame(width: 400, height: 400)
                    .cornerRadius(8)
                    .overlay(Text("Failed to load image").foregroundColor(.white))
            } else {
                Color.gray
                    .frame(width: 400, height: 400)
                    .cornerRadius(8)
                    .overlay(Text("No image URL"))
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
            .onAppear(perform: loadImageUrl)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
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

