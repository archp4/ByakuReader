//
//  Home.swift
//  ByakuReader
//
//  Created by Yash Vipul Naik on 2025-06-13.
//

import SwiftUI
import AppwriteModels

struct Home: View {
    @Binding var authFlow: AuthViewManager

    @State private var trendingComics: [Comic] = []
    @State private var continueReadingComics: [Comic] = []
    @State private var myListComics: [Comic] = []
    @State private var user: UserModel?

    @State private var searchText: String = ""
    @State private var showingLogoutAlert = false

    private let itemWidth: CGFloat = 150
    private let itemHeight: CGFloat = 225

    private var filteredComics: [Comic] {
        let allComics = trendingComics + continueReadingComics + myListComics
        if searchText.isEmpty {
            return []
        } else {
            return allComics.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        }
    }

    var body: some View {
        NavigationStack {
            VStack {
                if !filteredComics.isEmpty {
                    HomeRowView(
                        title: "Search Results",
                        comics: filteredComics,
                        itemWidth: itemWidth,
                        itemHeight: itemHeight
                    )
                } else {
                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 20) {
                            if !trendingComics.isEmpty {
                                HomeRowView(
                                    title: "Trending Now",
                                    comics: trendingComics,
                                    itemWidth: itemWidth,
                                    itemHeight: itemHeight
                                )
                            }
                            if !continueReadingComics.isEmpty {
                                HomeRowView(
                                    title: "Continue Reading",
                                    comics: continueReadingComics,
                                    itemWidth: itemWidth,
                                    itemHeight: itemHeight
                                )
                            }
                            if !myListComics.isEmpty {
                                HomeRowView(
                                    title: "My List",
                                    comics: myListComics,
                                    itemWidth: itemWidth,
                                    itemHeight: itemHeight
                                )
                            }
                            if trendingComics.isEmpty && continueReadingComics.isEmpty && myListComics.isEmpty {
                                Text("Loading your comics…")
                                    .foregroundColor(.gray)
                                    .padding()
                            }
                        }
                        .padding(.vertical)
                    }
                }
            }
            .searchable(text: $searchText)
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingLogoutAlert = true
                    } label: {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                    }
                    .alert("Logout", isPresented: $showingLogoutAlert) {
                        Button("Cancel", role: .cancel) {}
                        Button("Logout", role: .destructive) {
                            Task {
                                do {
                                    try await AppwriteManager.shared.onLogout()
                                    authFlow = .signIn
                                    print("Logout successful")
                                } catch {
                                    print("Logout failed:", error)
                                }
                            }
                        }
                    } message: {
                        Text("Are you sure you want to log out?")
                    }
                }

                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        // You can add profile navigation here
                    } label: {
                        Image(systemName: "person")
                            .frame(width: 40, height: 40)
                    }
                }
            }
            .task {
                do {
                    user = try await AppwriteManager.shared.getUser()
                    await loadAllSections()
                } catch {
                    print("User fetch failed: \(error)")
                }
            }
        }
    }

    private func loadAllSections() async {
        guard let userId = user?.id else { return }

        AppwriteManager.shared.fetchTreadingComics { result in
            switch result {
            case .success(let comics): trendingComics = comics
            case .failure(let err): print("Trending error:", err)
            }
        }

        AppwriteManager.shared.fetchContinueReading(for: userId) { result in
            switch result {
            case .success(let comics): continueReadingComics = comics
            case .failure(let err): print("Continue Reading error:", err)
            }
        }

        AppwriteManager.shared.fetchMyList(for: userId) { result in
            switch result {
            case .success(let comics): myListComics = comics
            case .failure(let err): print("My List error:", err)
            }
        }
    }
}

#Preview {
    Home(authFlow: .constant(.home))
}
