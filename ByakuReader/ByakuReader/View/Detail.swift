//
//  Detail.swift
//  ByakuReader
//
//  Created by Yash Vipul Naik on 2025-06-13.
//

import SwiftUI

struct Detail: View {
    var items: [String] = ["Chapter 1", "Chapter 2"]
    @State var showChapter : Bool = false
    var body: some View {
        NavigationStack{
            AsyncImage(url: URL(string: "https://fra.cloud.appwrite.io/v1/storage/buckets/6841a6700036753bfcfb/files/68449647b5d3814ac225/view?project=6840d2580002fa6b80ab")){ phase in
                if let image = phase.image{
                    image
                        .resizable()
                        .frame(width: 400,height: 400)
                        .aspectRatio(contentMode: .fill)
                } else if phase.error != nil {
                    Color.gray
                        .frame(width:.infinity,height: 300)
                        .cornerRadius(8)
                        .shadow(radius: 3)
                } else {
                    ProgressView()
                }
            }
            Spacer().frame(height: 10)
            VStack{
                Text("Description").frame(maxWidth: .infinity,maxHeight: 8, alignment: .leading)
                Text("The game has emerged into reality, the rules of the world have been turned upside down and humanity has entered the era of becoming players with the world set as a game stage. The only way to become a player is by leveling up to become stronger! The only way to rise to the top of the world! On the day of world fusion Lin Moyue chose to take on the sole hidden class, Necromancer. From then on, Lin Moyue would not die until his summoned creatures died out. I sit on the throne of bones as the God of the dead and walk between life and death. I am a walking catastrophe!").font(.footnote).foregroundStyle(.gray)
                    .frame(maxWidth: .infinity, maxHeight: 140, alignment: .leading)
                HStack{
                    Text("Genre").font(.footnote)
                    Text("Shounen, Fantasy, Drama, Adventure, Action").font(.footnote).foregroundStyle(.gray)
                }.frame(maxWidth: .infinity, alignment: .leading)
                Spacer().frame(height: 10)
                Text("Chapters").font(.title3).bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer().frame(height: 10)
                List{
                    ForEach(items, id: \.self){ item in
                        Button(item){
                            showChapter = true
                        }
                    }.listStyle(.inset)
                }
                .listStyle(PlainListStyle())
                .padding(EdgeInsets(top: -10, leading: -20, bottom: -20, trailing: -20))
            }.padding()
            .navigationDestination(isPresented: $showChapter) {
                ComicChapterView()
            }
            .navigationTitle("Catastrophic Necromancer")
            .navigationBarTitleDisplayMode(.inline)
        }.frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    Detail()
}
