import Foundation
import Appwrite
import JSONCodable

class Appwrite {
    var client: Client
    var account: Account
    
    public init() {
        self.client = Client()
            .setEndpoint("https://fra.cloud.appwrite.io/v1")
            .setProject("6840d2580002fa6b80ab")
        
        self.account = Account(client)
    }
    
    public func onRegister(
            _ email: String,
            _ password: String
        ) async -> Bool {
            do {
                print("This is your \(email)")
                _ = try await account.create(
                    userId: ID.unique(),
                    email: email,
                    password: password
                )
                return true // Return true if registration is successful
            } catch let error as AppwriteError {
                print("Registration failed with Appwrite error: \(error.message)")
                return false
            }
            catch {
                print("Registration failed with error: \(error)")
                return false // Return false if registration fails
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
    
}

