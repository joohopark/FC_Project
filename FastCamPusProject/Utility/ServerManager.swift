//
//  ServerManager.swift
//  FastCamPusProject
//
//  Created by 주호박 on 2018. 4. 20..
//  Copyright © 2018년 이주형. All rights reserved.
//

import Foundation
import Alamofire

protocol ServiceManagerType {
    func retrievePostList(completion: @escaping (Result<[Post]>) -> ())// 포스팅 한거확인 하는 걸로
//    func createPost()
}


//
struct Post: Decodable {
    let pk: Int
    let title: String
    let content: String

    
    private enum CodingKeys: String, CodingKey {
        case pk
        case title
        case content
    }
}


class ServiceManager: ServiceManagerType{
    func retrievePostList(completion: @escaping (Result<[Post]>) -> ()) {
        
        Alamofire
            .request(API.Post.start, method: .get)
            .responseData { (response) in
                switch response.result{
                case .success(let value):
                    do {
                        let postList = try JSONDecoder().decode([Post].self, from: value)
                        completion(.success(postList))
                    } catch {
                        completion(.error(error))
                    }
                case .failure(let err):
                    debugPrint(err.localizedDescription)
                }
        }
    }
    
}
