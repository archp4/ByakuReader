import Foundation
import Appwrite

class AppwriteManager {
    static let shared = AppwriteManager()

    var client: Client
    var account: Account
    var databaseID = "6840da45001fbb9d0a48"
    var comics_details = "68419d90001f3f73b9d3"
    var user_comic_lists = "688d2c34000c11339ed9"
    var reading_progress = "688d2c84001277be7858"
    var chapters = "684481d40008aaf51951"

    private init() {
        self.client = Client()
            .setEndpoint("https://fra.cloud.appwrite.io/v1")
            .setProject("6840d2580002fa6b80ab")
        self.account = Account(client)
    }

    // MARK: - Authentication

    func onRegister(email: String, password: String, name: String) async -> Bool {
        do {
            _ = try await account.create(
                userId: ID.unique(),
                email: email,
                password: password,
                name: name
            )
            return true
        } catch let error as AppwriteError {
            print("Registration failed: \(error.message)")
            return false
        } catch {
            print("Unexpected error during registration: \(error)")
            return false
        }
    }

    func onLogin(_ email: String, _ password: String) async -> Bool {
        do {
            _ = try await account.createEmailPasswordSession(
                email: email,
                password: password
            )
            return true
        } catch {
            print("Login failed: \(error)")
            return false
        }
    }

    func onLogout() async -> Bool {
        do {
            _ = try await account.deleteSession(sessionId: "current")
            return true
        } catch {
            print("Logout failed: \(error)")
            return false
        }
    }

    func getUser() async throws -> UserModel {
        let appwriteUser = try await account.get()
        return UserModel(
            id: appwriteUser.id,
            name: appwriteUser.name,
            email: appwriteUser.email
        )
    }

    // MARK: - Comics

    func fetchTreadingComics(completion: @escaping (Result<[Comic], Error>) -> Void) {
        let db = Databases(client)
        Task {
            do {
                let response = try await db.listDocuments(
                    databaseId: databaseID,
                    collectionId: comics_details,
                    queries: [Query.limit(10)]
                )
                let comics: [Comic] = try response.documents.compactMap { doc in
                    let data = doc.data.mapValues { $0.value }
                    let jsonData = try JSONSerialization.data(withJSONObject: data)
                    return try JSONDecoder().decode(Comic.self, from: jsonData)
                }
                completion(.success(comics))
            } catch {
                completion(.failure(error))
            }
        }
    }

    func fetchContinueReading(for userId: String, completion: @escaping (Result<[Comic], Error>) -> Void) {
        let db = Databases(client)
        Task {
            do {
                let query = [Query.equal("userId", value: userId)]
                let response = try await db.listDocuments(
                    databaseId: databaseID,
                    collectionId: reading_progress,
                    queries: query
                )
                let comicIds = response.documents.compactMap { $0.data["comicId"]?.value as? String }
                getComicsByIds(comicIds, completion: completion)
            } catch {
                completion(.failure(error))
            }
        }
    }

    func fetchMyList(for userId: String, completion: @escaping (Result<[Comic], Error>) -> Void) {
        let db = Databases(client)
        Task {
            do {
                let query = [Query.equal("userId", value: userId)]
                let response = try await db.listDocuments(
                    databaseId: databaseID,
                    collectionId: user_comic_lists,
                    queries: query
                )
                let comicIds = response.documents.compactMap { $0.data["comicId"]?.value as? String }
                getComicsByIds(comicIds, completion: completion)
            } catch {
                completion(.failure(error))
            }
        }
    }

    func getComicsByIds(_ ids: [String], completion: @escaping (Result<[Comic], Error>) -> Void) {
        let db = Databases(client)
        Task {
            do {
                let queries = [Query.equal("$id", value: ids)]
                let response = try await db.listDocuments(
                    databaseId: databaseID,
                    collectionId: comics_details,
                    queries: queries
                )
                let comics: [Comic] = try response.documents.compactMap { doc in
                    let data = doc.data.mapValues { $0.value }
                    let jsonData = try JSONSerialization.data(withJSONObject: data)
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
                let queries = [Query.equal("comicId", value: comicId)]
                let response = try await db.listDocuments(
                    databaseId: databaseID,
                    collectionId: chapters,
                    queries: queries
                )
                let chapters: [ChapterModel] = try response.documents.compactMap { doc in
                    let data = doc.data.mapValues { $0.value }
                    let jsonData = try JSONSerialization.data(withJSONObject: data)
                    return try JSONDecoder().decode(ChapterModel.self, from: jsonData)
                }
                completion(.success(chapters))
            } catch {
                completion(.failure(error))
            }
        }
    }
}
