//
//  server.swift
//  FastCamPusProject
//
//  Created by 이주형 on 2018. 4. 14..
//  Copyright © 2018년 이주형. All rights reserved.
//

import UIKit

import Alamofire
import GoogleSignIn
import Firebase



enum API {

    static let baseURL = "http://192.168.0.10:3000/"

    enum Auth {
        static let diaryimage = API.baseURL + "diaryimage/"
    }
    enum Post {
        //API로 회원가입
        static let signInAPI = API.baseURL + "UserCreate/API"
        //APP로 회원가입
        static let signInAPP = API.baseURL + "UserCreate/APP"
        //Login시 사용자 정보 불러오기
        static let start = API.baseURL + "start"
        //Login시 친구 리스트 불러오기
        static let friendList = API.baseURL + "friendList"
        //일기장 불러오기
        static let diaryList = API.baseURL + "diaryList"
        //친구 추가
        static let friendAdd = API.baseURL + "friendAdd"
        //작성글에 이미지 들고 오고
        static let diaryCreate = API.baseURL + "friendAdd"
        // 글자성하기
    }
}

protocol AuthServiceType {
    func Login(uid: String,completion: @escaping (Result<String>)->())
    func signInAPP(email: String,password: String,imageData: Data, displayName: String, uid: String,completion: @escaping (Result<String>) -> ())
    func AuthCredentialLogin(token: AuthCredential, completion: @escaping (Result<String>, User?) -> ())
    func AuthFriendList(uid: String, completion: @escaping (ResultDdata<[Userinfo]>) -> ())
    //uid month year
    func diaryList(uid:String, year: String ,month:String, completion: @escaping (ResultDdata<[Objects]>) -> ())
    
    func diaryimage(No:Int, completion:@escaping (ResultDdata<UIImage?>) -> ())
    
    func friendAdd(myuid:String, fruenduid:String, completion: @escaping (ResultDdata<String>) -> ())
    
//    uid authority Contents image = Data
    func diaryCreate(uid:String, authority:String, Contents:String, image:Data, completion: @escaping (ResultDdata<String>) -> ())
}


struct AuthService: AuthServiceType {

    
    func diaryCreate(uid: String, authority: String, Contents: String, image: Data, completion: @escaping (ResultDdata<String>) -> ()) {
        print("")
    }
    

   
    
    
    
    
    func diaryimage(No: Int, completion: @escaping (ResultDdata<UIImage?>) -> ()) {
        Alamofire.request(API.Auth.diaryimage+"\(No).png").responseData { (response) in
            switch response.result {
                
            case .success(let value):
                    if let data = response.data {
                       let image = UIImage(data: data)
                        completion(.success(image))
                    }
            case .failure(let error):
                completion(.error(error))
            }
        }
            
    }
    
    
    
    func friendAdd(myuid: String, fruenduid: String, completion: @escaping (ResultDdata<String>) -> ()) {
        
        
        
        let parameters: Parameters = [
            "myuid": myuid,
            "fruenduid": fruenduid
        ]
        
        Alamofire.request(API.Post.friendAdd, method: .post, parameters: parameters, encoding: URLEncoding.httpBody).responseString { (response) in
            
            switch response.result {
                case .success(let value) :
                    print(value)
                    completion(.success(value))
                case .failure(let error) :
                    completion(.error(error))
            }
        }
        
        
    }
    
    func diaryList(uid: String, year: String, month: String, completion: @escaping (ResultDdata<[Objects]>) -> ()) {
        let parameters: Parameters = [
            "uid": uid,
            "year": year,
            "month": month
            ]
      
        
        Alamofire.request(API.Post.diaryList, method: .post, parameters: parameters, encoding: URLEncoding.httpBody).responseData { (response) in
            switch response.result{
            case .success(let value):
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .formatted(DateFormatter.yyyyMMdd)
                    let rssFeed = try! decoder.decode([diaryItem].self, from: value)
                    
                    let array = converting(array: rssFeed)
                    
                    completion(.success(array))
                    
                } catch {
                    completion(.error(error))
                }
            case .failure(let error):
                completion(.error(error))
            }
        }

    }
    
    
    
    
    func AuthFriendList(uid: String, completion: @escaping (ResultDdata<[Userinfo]>) -> ()) {
        
        let parameters = [
            "uid": uid
        ]
        let alamofire:DataRequest = Alamofire.request(API.Post.friendList, method: .post, parameters: parameters, encoding: URLEncoding.httpBody)
        alamofire.responseData { (response) in
            
            switch response.result {
            case .success(let value):
                do {
                    let friendList = try JSONDecoder().decode([Userinfo].self, from: value)
                    completion(.success(friendList))
                } catch {
                    completion(.error(error))
                }
                
            case .failure(let error):
                completion(.error(error))
            }
        }
    }
    
    func Login(uid: String, completion: @escaping (Result<String>) -> ()) {
        print("===================== [ Login ] =====================")
        print(uid)
        let parameters = [
            "uid":uid
        ]
        Alamofire.request(API.Post.start, method: .post, parameters: parameters, encoding: URLEncoding.httpBody).responseString { (response) in
            switch (response.result) {
            case .success(let value) :
                print("===================== [ Login success ] =====================")
                print(value)
            case .failure(let erorr) :
                print("===================== [ Login failure ] =====================")
                print(erorr.localizedDescription)
            }
        }
        
    }
    
    func signInAPP(email: String,password: String,imageData: Data, displayName: String, uid: String,completion: @escaping (Result<String>) -> () ) {
        
        
        
        let parameters = [
            "UserEmail":email,
            "Name":displayName,
            "UserPwd": password,
            "Login_uid": uid
        ]
    
        print(API.Post.signInAPP)
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: .utf8)!, withName: key as String)
            }
            
            if let data:Data = imageData {
                multipartFormData.append(data, withName: "image", fileName: "image", mimeType: "image/png")
            }
            
        }, to: API.Post.signInAPP) { (encodingResult) in
            switch encodingResult {
                case .success(request: let upload, _, _):
                    upload.responseString { (response) in
                        switch response.result {
                        case .success(let value):
                            completion(.success(value))

                        case .failure(let error):
                             print(error)
                            completion(.error(error))
                        }
                    }
                case .failure(let error):
                    completion(.error(error))
                }
        }

        

    }
    
    func AuthCredentialLogin(token: AuthCredential, completion: @escaping (Result<String>, User?) -> ()){
        
        Auth.auth().signIn(with: token) { (user, error) in
            
            guard error == nil else {
                completion(.loginerror(error!),nil)
                return
            }
            
            let email = user?.email ?? ""
            let photoURL = user?.photoURL?.absoluteString ?? ""
            let displayName = user?.displayName ?? ""
            let uid = user?.uid ?? ""
            self.signInAPI(email: email, photoURL: photoURL, displayName: displayName, uid: uid, completion: { (result) in
                switch result {
                    case .success(let value):
                        completion(.success(value),user)
                    case .error(let error):
                        completion(.error(error),user)
                    case .loginerror(_):
                        break
                }
            })
        }
    }
    

    func signInAPI(email: String, photoURL: String, displayName: String, uid: String, completion: @escaping (Result<String>) -> ()) {
        let parameters = [
            "Email":email,
            "Name":displayName,
            "image":photoURL,
            "uid": uid
        ]
        let alamofire:DataRequest = Alamofire.request(API.Post.signInAPI, method: .post, parameters: parameters, encoding: URLEncoding.httpBody)
        alamofire.responseString { (response) in
                switch response.result {
                case .success(let value):
                    
                        completion(.success(value))
                   
                case .failure(let error):
                    completion(.error(error))
                }
            }
        }
    
}



