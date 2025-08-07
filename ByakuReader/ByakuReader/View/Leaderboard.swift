//
//  Leaderboard.swift
//  ByakuReader
//
//  Created by Yash Vipul Naik on 2025-06-13.
//

import SwiftUI

struct LeaderboardView: View {
    
    @State var rankings: [String: [(comic: Comic, count: Int)]]
    @State var all : [String] = []
    @State private var selectedRegion: String? = nil
//    @State private var selectedViewFilter: String = "Most Viewed"
    @State var showDetail : Bool = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                HStack {
                    Spacer().frame(width: 20)
                    Menu {
                        ForEach(rankings.keys.sorted(), id: \.self){ country in
                            Button(country) { selectedRegion = country }
                        }
                        
                    } label: {
                        Label(selectedRegion ?? "", systemImage: "chevron.down")
                            .font(.subheadline)
                            .padding(.horizontal, 15)
                            .padding(.vertical, 8)
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                            .foregroundColor(.primary)
                    }
                    Spacer()
                }
                .padding(.bottom, 10)
                if let selected = selectedRegion, let comics = rankings[selected] {
                    List(Array(comics.enumerated()), id: \.element.comic.id) { index, item in
                        let local = LeaderboardItem(rank: index + 1, comic: item.comic, key: "")
                        LeaderboardRow(item: local).onTapGesture {
                            showDetail = true
                        }.listStyle(PlainListStyle())
                            .padding(.horizontal, 0)
                    }
                } else {
                    
                }

                
            }
            .navigationTitle("Leaderboard")
            .navigationBarTitleDisplayMode(.large)
            .navigationDestination(isPresented: $showDetail) {
//                Detail()
            }.onAppear{
                Appwrite.shared.fetchComics{ result in
                    switch(result){
                    case .success(let allComic):
                        
                        Appwrite.shared.fetchEngagements { resultTreading in
                            switch(resultTreading) {
                            case .success(let resultComic):
                                rankings = rankComicsByCountry(from: resultComic, comics: allComic)
                                selectedRegion = rankings.keys.sorted().first
                                break
                            case .failure(_):
                                break
                            }
                        }
                        
                    case .failure(_): break
                    }
                }
            }
        }
    }
    
    func rankComicsByCountry(from engagements: [ComicEngagementLeaderboard], comics comicList: [Comic]) -> [String: [(comic: Comic, count: Int)]] {
        
        let groupedByCountry = Dictionary(grouping: engagements, by: { $0.country })
        let comicDict = Dictionary(uniqueKeysWithValues: comicList.map { ($0.id, $0) })
        var rankedComicsByCountry: [String: [(comic: Comic, count: Int)]] = [:]
        for (country, engagements) in groupedByCountry {
            
            let counts = engagements.reduce(into: [String: Int]()) { counts, engagement in
                counts[engagement.comicId, default: 0] += 1
            }
            let ranked: [(comic: Comic, count: Int)] = counts.sorted { $0.value > $1.value }
                .compactMap { (comicId, count) in
                    guard let comic = comicDict[comicId] else {
                        return nil
                    }
                    return (comic, count)
                }
            rankedComicsByCountry[country] = ranked
        }
        return rankedComicsByCountry
    }

}
