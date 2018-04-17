//
//  sss.swift
//  FastCamPusProject
//
//  Created by 이주형 on 2018. 4. 16..
//  Copyright © 2018년 이주형. All rights reserved.
//

import Foundation



enum Result<T> {
    case success(T)
    case error(Error)
    case loginerror(Error)
}

enum ServiceError: Error {
    case invalidToken
    case invalidURL
    case parsingError
}

enum PostError: Error {
    case missingParameter(param: String)
    case encodingError
}

enum AuthError: Error {
    case invalidUsername
    case invalidPassword
}

//
//struct Userinfo: Codable {
//    let userindex, userEmail: String?
//    let userPwd: String?
//    let name: String?
//    let pushToken: String?
//    let loginUid : String?
//    
//    
//    
//    enum CodingKeys: String, CodingKey {
//        case userindex = "Userindex"
//        case userEmail = "UserEmail"
//        case userPwd = "UserPwd"
//        case name = "Name"
//        case pushToken = "PushToken"
//        case loginUid = "Login_uid"
//        case artistName = "name"
//    }
//}




