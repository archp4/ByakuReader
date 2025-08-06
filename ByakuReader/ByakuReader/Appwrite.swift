import Foundation
import Appwrite
import JSONCodable

class Appwrite {
    static let shared = Appwrite()
    var client: Client
    var account: Account
    var databaseID : String = "6840da45001fbb9d0a48"
    var reading_progress : String = "688d2c84001277be7858"
    var user_comic_lists : String = "688d2c34000c11339ed9"
    var comic_engagements : String = "688d2b03002c40b6475b"
    var chapters : String = "684481d40008aaf51951"
    var comics_details : String = "68419d90001f3f73b9d3"
    var users : String = "6840da8b002018e7799b"
    var comic : [Comic] = []
    
    public init() {
        self.client = Client()
            .setEndpoint("https://fra.cloud.appwrite.io/v1")
            .setProject("6840d2580002fa6b80ab")
        
        self.account = Account(client)
    }
    
    public func onRegister(_ email: String,_ password: String, completion: @escaping (Result<UserAppwriteDetail, Error>) -> Void) async -> Void {
        do {
            let user_data = try await account.create(
                userId: ID.unique(),
                email: email,
                password: password
            )
            completion(.success(UserAppwriteDetail(userId: user_data.id, userName: "", userEmail: email, userPassword: password)))
        } catch let error as AppwriteError {
            completion(.failure(error))
        }
        catch {
            completion(.failure(error))
        }
    }
    
    
    public func onLogin(_ email: String, _ password: String, completion: @escaping (Result<UserAppwriteDetail, Error>) -> Void) async -> Void {
        do {
            let user_data = try await account.createEmailPasswordSession(
                email: email.lowercased(),
                password: password
            )
            completion(.success(UserAppwriteDetail(userId: user_data.userId, userName: "", userEmail: email, userPassword: password)))
        } catch let error as AppwriteError {
            completion(.failure(error))
        }
        catch {
            completion(.failure(error))
        }
    }
    
    func fetchComics(completion: @escaping (Result<[Comic], Error>) -> Void) {
        let db = Databases(client)
        Task {
            do {
                let response = try await db.listDocuments(
                    databaseId: databaseID,
                    collectionId: comics_details
                )
                let comics: [Comic] = try response.documents.compactMap { document in
                    let dict = document.data.mapValues { $0.value }
                    let jsonData = try JSONSerialization.data(withJSONObject: dict)
                    return try JSONDecoder().decode(Comic.self, from: jsonData)
                }
                comic = comics
                completion(.success(comics))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func getChapterById(by id: String, completion: @escaping (Result<ChapterDetails, Error>) -> Void) {
        Task{
            do {
                print("Reading Chapter \(id)")
                let db = Databases(client)
                let document = try await db.getDocument(
                    databaseId: databaseID,
                    collectionId: chapters,
                    documentId: id
                )
                let data = document.data.mapValues {$0.value }
                let jsonData = try JSONSerialization.data(withJSONObject: data)
                var object = try JSONDecoder().decode(ChapterDetails.self, from: jsonData)
//                var images : [String] = []
//                for i in object.files {
//                    var ni = await fetchImageUrl(key: i)
//                    images.append(ni!)
//                }
//                object.files = images
                completion(.success(object))
            } catch {
                completion(.failure(error))
                print("Failed to get Chapter Document: \(error.localizedDescription)")
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
                let items: [Comic] = try response.documents.compactMap { document in
                    let dict = document.data.mapValues { $0.value }
                    let jsonData = try JSONSerialization.data(withJSONObject: dict)
                    return try JSONDecoder().decode(Comic.self, from: jsonData)
                }
                completion(.success(items))
            } catch {
                print("Failed treading comic: \(error)")
                completion(.failure(error))
            }
        }
    }
    
    func fetchContinueReading(forUserId userId: String, allcomic allComic: [Comic] ,completion: @escaping (Result<[Comic], Error>) -> Void) {
        let db = Databases(client)
        Task {
            do {
                let queries = [
                    Query.equal("userId", value: userId),
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
                
                let comicIds = progressList.map { $0.comicId }
                print("Reading Progress \(comicIds)")
                let comics = allComic.filter{ comicIds.contains($0.id)}
                completion(.success(comics))
            } catch {
                print("Failed to fetch continue reading:", error)
                completion(.failure(error))
            }
        }
    }
    
    func fetchMyList(forUserId userId: String, allcomic allComic: [Comic], completion: @escaping (Result<[Comic], Error>) -> Void) {
        let db = Databases(client)
        guard !userId.isEmpty else {
            completion(.failure(NSError(domain: "InvalidUserID", code: 400, userInfo: [NSLocalizedDescriptionKey: "User ID is empty."])))
            return
        }
        
        Task {
            do {
                let queries = [
                    Query.equal("userId", value: userId),
                    Query.orderDesc("dateAdded")
                ]
                
                let response = try await db.listDocuments(
                    databaseId: databaseID,
                    collectionId: user_comic_lists,
                    queries: queries
                )
                
                let myList: [UserComicList] = try response.documents.compactMap { doc in
                    let data = doc.data.mapValues { $0.value }
                    let jsonData = try JSONSerialization.data(withJSONObject: data)
                    return try JSONDecoder().decode(UserComicList.self, from: jsonData)
                }
                
                let comicIds = myList.map { $0.comicId }
                print("All MyList \(comicIds)")
                let comics = allComic.filter{ comicIds.contains($0.id)}
                completion(.success(comics))
            } catch {
                print("Failed to fetch My List:", error)
                completion(.failure(error))
            }
        }
    }
    
    func fetchEngagements(completion: @escaping (Result<[ComicEngagement], Error>) -> Void) {
        let db = Databases(client)
        Task {
            do {
                let response = try await db.listDocuments(
                    databaseId: databaseID,
                    collectionId: comic_engagements
                )
                let engagements = try response.documents.map { doc in
                    let data = doc.data.mapValues { $0.value }
                    let jsonData = try JSONSerialization.data(withJSONObject: data)
                    return try JSONDecoder().decode(ComicEngagement.self, from: jsonData)
                }
                
                completion(.success(engagements))
            } catch {
                print("Failed to fetch engagements: \(error)")
                completion(.failure(error))
            }
        }
    }
    
    

    
    func insertReadingProgress(progress: ReadingProgress) async {
        let db = Databases(client)
        
        let data: [String: Any] = [
            "userId": progress.userId,
            "comicId": progress.comicId,
            "chapterId": progress.chapterId,
        ]

        
        do {
            let document = try await db.createDocument(
                databaseId: databaseID,
                collectionId: reading_progress,
                documentId: progress.id,
                data: data
            )
            print("ReadingProgress document created: \(document)")
        } catch {
            print("Failed to create ReadingProgress document: \(error.localizedDescription)")
        }
    }
    
    func insertUserComicList(_ userComicList: UserComicList) async {
        let isoDate = ISO8601DateFormatter().string(from: Date())
        let db = Databases(client)
        let data: [String: AnyCodable] = [
            "userId": AnyCodable(userComicList.userId),
            "comicId": AnyCodable(userComicList.comicId),
            "dateAdded": AnyCodable(isoDate)
        ]
        
        do {
            let document = try await db.createDocument(
                databaseId: databaseID,
                collectionId: user_comic_lists,
                documentId: ID.unique(),
                data: data
            )
            print("UserComicList document created: \(document)")
        } catch {
            print("Failed to create UserComicList document: \(error.localizedDescription)")
        }
    }
    
    func insertComicEngagement(_ engagement: ComicEngagement) async {
        let db = Databases(client)
        let isoTimestamp = ISO8601DateFormatter().string(from: engagement.timestamp)
        
        let data: [String: Any] = [
            "comicId": engagement.comicId,
            "userId": engagement.userId,
            "interactionType": engagement.interactionType,
            "timestamp": isoTimestamp,
            "country": engagement.country,
            "state": engagement.state
        ]
        
        do {
            let document = try await db.createDocument(
                databaseId: databaseID,
                collectionId: comic_engagements,
                documentId: ID.unique(),
                data: data
            )
            print("ComicEngagement document created: \(document)")
        } catch {
            print("Failed to create ComicEngagement document: \(error.localizedDescription)")
        }
    }
    
    func fetchImageUrl(key: String) async -> String? {
        var components = URLComponents(string: "https://s3-helper.vercel.app/get-file-url")
        components?.queryItems = [URLQueryItem(name: "key", value: key)]
        guard let url = components?.url else {
            print("Invalid URL")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response")
                return nil
            }
            
            if httpResponse.statusCode == 200 {
                struct ResponseData: Decodable {
                    let url: String
                }
                let decoded = try JSONDecoder().decode(ResponseData.self, from: data)
                return decoded.url
            } else {
                print("Failed to fetch image URL: \(httpResponse.statusCode)")
                return nil
            }
        } catch {
            print("Error fetching image URL: \(error)")
            return nil
        }
    }
    
    public func onLogout() async throws {
        _ = try await account.deleteSession(
            sessionId: "current"
        )
    }
    
}

