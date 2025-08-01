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
