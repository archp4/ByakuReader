//
//  MediumChapterTile.swift
//  ByakuReader
//
//  Created by Yash Vipul Naik on 2025-06-17.
//

import SwiftUI

struct MediumComicTile: View {
    
    let comicImage : Image
    let comicName : String
    
    var body: some View {
        VStack{
            comicImage
                .resizable()
                .aspectRatio(contentMode: /*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/)
                .frame(height: 250)
                .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20,height: 20), style: .continuous))
                .shadow(radius: 4)
            Text(comicName)
                .font(.headline)
                .frame(width: .infinity,alignment: .leading)
        }
    }
}

#Preview {
    MediumComicTile(comicImage: Image(systemName: "house"), comicName: "One Piece")
}
