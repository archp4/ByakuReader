//
//  ComicChapterView.swift
//  ByakuReader
//
//  Created by Arch Umeshbhai Patel on 2025-06-20.
//

import SwiftUI

struct ComicChapterView : View {
    
    
    let chapterId : String
    @State var comicImageNames : [String] = []
    @State var title : String = ""
    
    var body: some View {
        NavigationStack{
            ScrollView(.vertical, showsIndicators: true) {
                VStack(spacing: 0) {
                    ForEach(comicImageNames, id: \.self) { imageName in
                        AsyncImage(url: URL(string: imageName)){ phase in
                            if let image = phase.image{
                                image
                                    .resizable()
                                    .frame(width: .infinity)
                                    .scaledToFill()
                                
                            } else if phase.error != nil {
                                Color.gray
                            } else {
                                ProgressView()
                            }
                        }
                    }
                }
            }
            .navigationTitle("Chapter")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.hidden, for: .navigationBar)
        }.onAppear{
            Appwrite.shared.getChapterById(by: chapterId) { result in
                switch (result) {
                case .success(let data):
                    comicImageNames = data.files
                    title = data.chapterName
                case .failure(let error):
                    print("On Chapter Page \(error)")
                }
            }
        }
    }
}

