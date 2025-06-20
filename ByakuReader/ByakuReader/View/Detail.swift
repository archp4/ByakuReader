//
//  Detail.swift
//  ByakuReader
//
//  Created by Yash Vipul Naik on 2025-06-13.
//

import SwiftUI

struct Detail: View {
    var items: [String] = ["Chapter 1", "Chapter 2"]
    var body: some View {
        NavigationStack{
            AsyncImage(url: URL(string: "https://readermc.org/images/thumbnails/The%20Lone%20Necromancer.webp"))
                .frame(width:.infinity,height: 300)
                .clipped()
                .scaledToFit()
            Spacer().frame(height: 10)
            VStack{
                Text("Description").frame(maxWidth: .infinity,maxHeight: 8, alignment: .leading)
                Text("Seongwu is a former special forces soldier who has returned to college after completing his national service. His ordinary life as a student is shattered during class one day when he and his fellow students are faced with a mysterious prompt asking them to “select a role.” Seongwu chooses the necromancer, a rare ability that grants him the power to control the undead. With the campus and outside world seemingly on the brink of collapse, Seongwu must use his newfound powers to battle fearsome monsters and help save his fellow students. But will they make it out alive?").font(.footnote).foregroundStyle(.gray)
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
                        Text(item)
                    }.listStyle(.inset)
                }
                .listStyle(PlainListStyle())
                .padding(EdgeInsets(top: -10, leading: -20, bottom: -20, trailing: -20))
            }.padding()
            .navigationTitle("The Lone Necromancer")
            .navigationBarTitleDisplayMode(.inline)
        }.frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    Detail()
}
