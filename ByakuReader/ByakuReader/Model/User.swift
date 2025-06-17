//
//  User.swift
//  ByakuReader
//
//  Created by Arch Umeshbhai Patel on 2025-06-13.
//

import Foundation

class User : ObservableObject {
    @Published var userId : String
    @Published var userName: String
    @Published var userEmail: String
    @Published var userPassword: String
        
    init(userId: String, userName: String, userEmail: String, userPassword: String) {
        self.userId = userId
        self.userName = userName
        self.userEmail = userEmail
        self.userPassword = userPassword
    }
    
    init(){
        self.userId = "Demo ID"
        self.userName = "Demo User"
        self.userEmail = "Demo Email"
        self.userPassword = "Demo Password"
    }
}
