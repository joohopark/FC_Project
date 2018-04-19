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


struct Userinfo: Codable {
    var Userindex: Int
    var UserEmail:String?
    var UserPwd: String?
    var Name: String
    var PushToken: String?
    var Login_uid: String
    
    private enum CodingKeys: String, CodingKey {
        case Userindex = "Userindex"
        case UserEmail = "UserEmail"
        case UserPwd = "UserPwd"
        case Name = "Name"
        case PushToken = "PushToken"
        case Login_uid = "Login_uid"
    }
}




