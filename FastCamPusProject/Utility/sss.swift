//
//  sss.swift
//  FastCamPusProject
//
//  Created by 이주형 on 2018. 4. 16..
//  Copyright © 2018년 이주형. All rights reserved.
//

import Foundation


enum ResultDdata<T> {
    case success(T)
    case error(Error)
}

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


struct Userinfo: Decodable {
    var Userindex: Int
    var UserEmail:String
    var Name: String
    var PushToken: String? 
    var Login_uid: String
    
    private enum CodingKeys: String, CodingKey {
        case Userindex = "Userindex"
        case UserEmail = "UserEmail"
        case Name = "Name"
        case PushToken = "PushToken"
        case Login_uid = "Login_uid"
    }
}


extension DateFormatter {
    static let yyyyMMdd: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "ko_kr")
        return formatter
    }()
}

struct Objects {
    
    var sectionName : Date!
    var sectionObjects : [diaryItem]!
}


func converting(array:[diaryItem]) -> [Objects] {
    var objarray: [Objects] = []
    
    for value in array
    {
        let valuye = objarray.filter{ $0.sectionName  == value.date }
        
        if (valuye.isEmpty){
            objarray.append(Objects(sectionName: value.date, sectionObjects: [value]))
        }else{
            for v2 in 0..<objarray.count {
                if objarray[v2].sectionName == value.date {
                    objarray[v2].sectionObjects.append(value)
                }
            }
        }
    }
    
    return objarray
}



struct diaryItem: Decodable {
//    var Userindex: Int
//    var UserEmail:String?
//    var Name: String
//    var Login_uid: String
//    var No: Int
//    var authority: Int
//    var Contents: String
//    var Date_created: Date

    var Userindex: Int
    var UserEmail:String?
    var Name: String
    var Login_uid: String
    var No: Int
    var authority: Int
    var Contents: String
    var date: Date
}

//    var Userindex: Int
//    var UserEmail:String?
//    var Name: String
//    var Login_uid: String
//    var No: Int
//    var authority: Int
//    var Contents: String
//    var date: Date


