import Foundation
import Appwrite
import JSONCodable

class AppwriteManager {
    
    static let shared = AppwriteManager()
    var client: Client
    var account: Account
    var databaseID : String = "6840da45001fbb9d0a48"
    var reading_progress : String = "688d2c84001277be7858"
    var user_comic_lists : String = "688d2c34000c11339ed9"
    var comic_engagements : String = "688d2b03002c40b6475b"
    var chapters : String = "688d2c34000c11339ed9"
    var comics_details : String = "688d2c34000c11339ed9"
    var users : String = "6840da8b002018e7799b"
    
    public init() {
        self.client = Client()
            .setEndpoint("https://fra.cloud.appwrite.io/v1")
            .setProject("6840d2580002fa6b80ab")
        
        self.account = Account(client)
    }
    
    public func onRegister(email: String, password: String, name: String) async -> Bool {
            do {
                print("This is your \(email)")
                _ = try await account.create(
                    userId: ID.unique(),
                    email: email,
                    password: password
                )
                return true
            } catch let error as AppwriteError {
                print("Registration failed with Appwrite error: \(error.message)")
                return false
            }
            catch {
                print("Registration failed with error: \(error)")
                return false
            }
        }
    
        
    
    public func onLogin(
            _ email: String,
            _ password: String
        ) async -> Bool {
            do {
                let _ = try await account.createEmailPasswordSession(
                    email: email.lowercased(),
                    password: password
                )
                return true // Return true if login is successful
            } catch {
                print("Login failed with error: \(error)")
                return false // Return false if login fails
            }
        }
    
    public func onLogout() async throws {
        _ = try await account.deleteSession(
            sessionId: "current"
        )
    }

    func getUser() async throws -> UserModel {
        let appwriteUser = try await account.get()
        return UserModel(
            id: appwriteUser.id,
            name: appwriteUser.name,
            email: appwriteUser.email
        )
    }



    func fetchComics(completion: @escaping (Result<[Comic], Error>) -> Void) {
        let db = Databases(client)
        
        Task {
            do {
                let response = try await db.listDocuments(
                    databaseId: databaseID,
                    collectionId: comics_details,
                    queries: []
                )
                let comics: [Comic] = try response.documents.compactMap { document in
                    let dict = document.data.mapValues { $0.value } // [String: Any]
                    let jsonData = try JSONSerialization.data(withJSONObject: dict)
                    return try JSONDecoder().decode(Comic.self, from: jsonData)
                }
                completion(.success(comics))
            } catch {
                completion(.failure(error))
            }
        }
    }

    
    func fetchTreadingComics(completion: @escaping (Result<[Comic], Error>) -> Void) {
        let db = Databases(client)
        
        Task {
            do {
                let response = try await db.listDocuments(
                    databaseId: databaseID,
                    collectionId: comics_details,
                    queries: [
                        Query.limit(10)
                    ]
                )
                let comics: [Comic] = try response.documents.compactMap { document in
                    let dict = document.data.mapValues { $0.value } // [String: Any]
                    let jsonData = try JSONSerialization.data(withJSONObject: dict)
                    return try JSONDecoder().decode(Comic.self, from: jsonData)
                }
                completion(.success(comics))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func getComicsByIds(_ ids: [String], completion: @escaping (Result<[Comic], Error>) -> Void) {
        let db = Databases(client)
        Task {
            do {
                let queries = [
                    Query.equal("id", value: ids)
                ]
                let response = try await db.listDocuments(
                    databaseId: databaseID,
                    collectionId: comics_details,
                    queries: queries
                )
                let comics: [Comic] = try response.documents.compactMap { document in
                    let dict = document.data.mapValues { $0.value }
                    let jsonData = try JSONSerialization.data(withJSONObject: dict)
                    return try JSONDecoder().decode(Comic.self, from: jsonData)
                }
                completion(.success(comics))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func fetchContinueReading(forUserId userId: String, completion: @escaping (Result<[ReadingProgress], Error>) -> Void) {
        let db = Databases(client)

        Task {
            do {
                let queries = [
                    Query.equal("userId", value: userId),
                    Query.orderDesc("lastReadAt")
                ]
                
                let response = try await db.listDocuments(
                    databaseId: databaseID,
                    collectionId: reading_progress,
                    queries: queries
                )
                
                let progressList: [ReadingProgress] = try response.documents.compactMap { doc in
                    let data = doc.data.mapValues { $0.value }
                    let jsonData = try JSONSerialization.data(withJSONObject: data)
                    return try JSONDecoder().decode(ReadingProgress.self, from: jsonData)
                }

                completion(.success(progressList))
            } catch {
                print("Failed to fetch continue reading:", error)
                completion(.failure(error))
            }
        }
    }
    
    func fetchUserComics(userId: String, completion: @escaping (Result<(continueReading: [Comic], myList: [Comic], treading: [Comic]), Error>) -> Void) {
        let db = Databases(client)

        Task {
            do {
                // --- Fetch UserComicList ---
                let listResponse = try await db.listDocuments(
                    databaseId: databaseID,
                    collectionId: user_comic_lists,
                    queries: [Query.equal("userId",value: userId)]
                )
                let userList = try listResponse.documents.compactMap { doc -> UserComicList? in
                    let data = doc.data.mapValues { $0.value }
                    let json = try JSONSerialization.data(withJSONObject: data)
                    return try JSONDecoder().decode(UserComicList.self, from: json)
                }
                let myListIds = userList.map { $0.comicId }

                let progressResponse = try await db.listDocuments(
                    databaseId: databaseID,
                    collectionId: reading_progress,
                    queries: [Query.equal("userId",value:  userId)]
                )
                let progressList = try progressResponse.documents.compactMap { doc -> ReadingProgress? in
                    let data = doc.data.mapValues { $0.value }
                    let json = try JSONSerialization.data(withJSONObject: data)
                    return try JSONDecoder().decode(ReadingProgress.self, from: json)
                }
                let progressComicIds = progressList.map { $0.comicId }
                
                let response = try await db.listDocuments(
                    databaseId: databaseID,
                    collectionId: comics_details,
                    queries: [
                        Query.limit(10)
                    ]
                )
                let comics: [Comic] = try response.documents.compactMap { document in
                    let dict = document.data.mapValues { $0.value } // [String: Any]
                    let jsonData = try JSONSerialization.data(withJSONObject: dict)
                    return try JSONDecoder().decode(Comic.self, from: jsonData)
                }

                // --- Fetch Comics for both lists ---
                let allIds = Array(Set(myListIds + progressComicIds)) // deduped union
                getComicsByIds(allIds) { result in
                    switch result {
                    case .success(let comics):
                        let continueReading = comics.filter { progressComicIds.contains($0.id) }
                        let myList = comics.filter { myListIds.contains($0.id) }
                        completion(.success((continueReading: continueReading, myList: myList, treading: comics)))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            } catch {
                print("Error fetching user comics:", error)
                completion(.failure(error))
            }
        }
    }


    
    func fetchChapters(forComicId comicId: String, completion: @escaping (Result<[ChapterModel], Error>) -> Void) {
        let db = Databases(client)
        
        Task {
            do {
                let queries = [
                    Query.equal("comicId", value: comicId)
                ]
    
                let response = try await db.listDocuments(
                    databaseId: databaseID,
                    collectionId: chapters,
                    queries: queries
                )
                
                let chapters: [ChapterModel] = try response.documents.compactMap { document in
                    let dict = document.data.mapValues { $0.value }
                    let jsonData = try JSONSerialization.data(withJSONObject: dict)
                    return try JSONDecoder().decode(ChapterModel.self, from: jsonData)
                }
                
                completion(.success(chapters))
            } catch {
                completion(.failure(error))
            }
        }
    }

}
