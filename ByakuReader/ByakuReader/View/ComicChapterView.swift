//
//  ComicChapterView.swift
//  ByakuReader
//
//  Created by Arch Umeshbhai Patel on 2025-06-20.
//

import SwiftUI

struct ComicChapterView : View {
    let comicImageNames = [
        "https://fra.cloud.appwrite.io/v1/storage/buckets/6841a6700036753bfcfb/files/68449647b5d3814ac225_1_1/view?project=6840d2580002fa6b80ab",
        "https://fra.cloud.appwrite.io/v1/storage/buckets/6841a6700036753bfcfb/files/68449647b5d3814ac225_1_2/view?project=6840d2580002fa6b80ab",
        "https://fra.cloud.appwrite.io/v1/storage/buckets/6841a6700036753bfcfb/files/68449647b5d3814ac225_1_3/view?project=6840d2580002fa6b80ab",
        "https://fra.cloud.appwrite.io/v1/storage/buckets/6841a6700036753bfcfb/files/68449647b5d3814ac225_1_4/view?project=6840d2580002fa6b80ab",
        "https://fra.cloud.appwrite.io/v1/storage/buckets/6841a6700036753bfcfb/files/68449647b5d3814ac225_1_5/view?project=6840d2580002fa6b80ab",
        "https://fra.cloud.appwrite.io/v1/storage/buckets/6841a6700036753bfcfb/files/68449647b5d3814ac225_1_6/view?project=6840d2580002fa6b80ab",
        "https://fra.cloud.appwrite.io/v1/storage/buckets/6841a6700036753bfcfb/files/68449647b5d3814ac225_1_7/view?project=6840d2580002fa6b80ab",
        "https://fra.cloud.appwrite.io/v1/storage/buckets/6841a6700036753bfcfb/files/68449647b5d3814ac225_1_8/view?project=6840d2580002fa6b80ab",
        "https://fra.cloud.appwrite.io/v1/storage/buckets/6841a6700036753bfcfb/files/68449647b5d3814ac225_1_9/view?project=6840d2580002fa6b80ab",
        "https://fra.cloud.appwrite.io/v1/storage/buckets/6841a6700036753bfcfb/files/68449647b5d3814ac225_1_10/view?project=6840d2580002fa6b80ab",
        
    ]
    
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
            .navigationTitle("Comic Chapter 01")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.hidden, for: .navigationBar)
        }
    }
}

#Preview {
    ComicChapterView()
}
