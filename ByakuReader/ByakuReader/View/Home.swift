//
//  Home.swift
//  ByakuReader
//
//  Created by Yash Vipul Naik on 2025-06-13.
//

import SwiftUI

struct Home: View {
    
    @Binding var authFlow: AuthViewManager
    @State var email: String = ""
    @State var password: String = ""
    @EnvironmentObject var user : UserAppwriteDetail
    @State var searchText : String = ""
    @State private var showingLogoutAlert = false
    
    let appwrite = Appwrite()
    
    @State var comicCategories: [String: [Comic]] = [
        "Trending Now": [
        ],
        "Continue Reading": [
        ],
        "All": [
        ]
    ]
    @State var listOfCategories : [String] = ["Continue Reading", "Trending Now", "All"]
    private let title = [
        "Afghanistan", "Albania", "Algeria", "Andorra", "Angola", "Antigua and Barbuda", "Argentina", "Armenia", "Australia", "Austria"
    ]
    
    private var searchResults : [String] {
        searchText.isEmpty ? title : title.filter { $0.contains(searchText) }
    }
    
    var body: some View {
        NavigationView{
            VStack{
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 20) {
                        ForEach(listOfCategories, id: \.self) { category in
                            HomeRowView(title: category, comics: comicCategories[category]!, itemWidth: 150, itemHeight: 225).environmentObject(user)
                        }
                    }
                    .padding(.vertical)
                }
            }
//            .searchable(text: $searchText)
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem(placement: .topBarTrailing){
                    Button{
                        showingLogoutAlert = true
                    } label: {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                    } // button
                    .alert("Logout", isPresented: $showingLogoutAlert) {
                        Button("Cancel", role: .cancel) {}
                        Button("Logout", role: .destructive) {
                            Task {
                                do {
                                    try await appwrite.onLogout()
                                    authFlow = .signIn
                                    print("Logout Done")
                                } catch {
                                    print(error)
                                }
                            }
                        }
                    } message: {
                        Text("Are you sure you want to log out?")
                    }
                } // toolbar item 1
//                ToolbarItem(placement: .topBarLeading){
//                    Button{
//                    } label: {
//                        Image(systemName: "person")
//                            .frame(width: 40, height: 40)
//                    }
//                }// toolbar item 2
            }// tool bar
        }.onAppear{
            Appwrite.shared.fetchComics{ result in
                switch(result){
                case .success(let allComic):
                    
                    Appwrite.shared.fetchTreadingComics{ resultTreading in
                        switch(resultTreading) {
                        case .success(let resultComic):
                            self.comicCategories["Trending Now"] = resultComic
                            self.comicCategories["All"] = allComic
                            break
                        case .failure(_):
                            break
                        }
                    }
                    Appwrite.shared.fetchContinueReading(forUserId: user.userId, allcomic: allComic){ resultTreading in
                        switch(resultTreading) {
                        case .success(let resultComic):
                            self.comicCategories["Continue Reading"] = resultComic
                            break
                        case .failure(_):
                            break
                        }
                    }
                case .failure(_): break
                }
            }
        } // navigation stack
    } // body
} // home

