//
//  ComicChapterView.swift
//  ByakuReader
//
//  Created by Arch Umeshbhai Patel on 2025-06-20.
//

import SwiftUI

struct ComicChapterView: View {
    let chapterId: String
    @State private var comicImageKeys: [String] = []
    @State private var comicImageUrls: [String] = []
    @State private var title: String = ""

    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: true) {
                VStack(spacing: 0) {
                    ForEach(comicImageUrls, id: \.self) { imageUrl in
                        AsyncImage(url: URL(string: imageUrl)) { phase in
                            if let image = phase.image {
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(maxWidth: .infinity)
                            } else if phase.error != nil {
                                Color.gray
                                    .frame(height: 400)
                            } else {
                                ProgressView()
                                    .frame(height: 400)
                            }
                        }
                    }
                }
            }
            .navigationTitle(title.isEmpty ? "Chapter" : title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.hidden, for: .navigationBar)
        }
        .onAppear {
            Appwrite.shared.getChapterById(by: chapterId) { result in
                switch result {
                case .success(let data):
                    Task {
                        let urls: [String] = await withTaskGroup(of: String?.self) { group in
                            for key in data.files {
                                let parts = key.components(separatedBy: "_")
                                if let firstPart = parts.first {
                                    print(firstPart)
                                    group.addTask {
                                        await Appwrite().fetchImageUrl(key: "comics/\(firstPart)_\(data.chapterId)/\(key)")
                                    }
                                }
                            }
                            var results: [String] = []
                            for await url in group {
                                if let url = url {
                                    results.append(url)
                                }
                            }
                            return results
                        }
                        await MainActor.run {
                            comicImageUrls = urls
                        }
                    }
                case .failure(let error):
                    print("On Chapter Page \(error)")
                }
            }
        }
    }
}
