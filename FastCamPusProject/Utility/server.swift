//
//  server.swift
//  FastCamPusProject
//
//  Created by 이주형 on 2018. 4. 14..
//  Copyright © 2018년 이주형. All rights reserved.
//

import Foundation
import Alamofire
import GoogleSignIn
import Firebase


enum API {
    static let baseURL = "http://172.30.1.13:3000/"
    
    enum Auth {

    }
    enum Post {
        static let signInAPI = API.baseURL + "UserCreate/API"
        static let signInAPP = API.baseURL + "UserCreate/APP"
        static let start = API.baseURL + "start"
    }
}

protocol AuthServiceType {
    func Login(uid: String,completion: @escaping (Result<String>)->())
    func signInAPI(email: String, photoURL: String, displayName: String, uid: String, completion: @escaping (Result<String>) -> ())
//    func signInAPP(email: String, imageData: Data, displayName: String, uid: String, completion: @escaping (Result<String>) -> ())
    func AuthCredentialLogin(token: AuthCredential, completion: @escaping (Result<String>, User?) -> ())
}


struct AuthService: AuthServiceType {
//    func signInAPP(email: String, imageData: Data, displayName: String, uid: String, completion: @escaping (Result<String>) -> ()) {
//        <#code#>
//    }
    
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



