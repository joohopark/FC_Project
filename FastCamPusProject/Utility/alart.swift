//
//  alart.swift
//  FastCamPusProject
//
//  Created by 이주형 on 2018. 4. 16..
//  Copyright © 2018년 이주형. All rights reserved.
//

import UIKit



struct customAlert {
    var view: UIViewController?
    
    func show(erorr: Error){
        
        var message = ""
        
        
        let overlapEmail = "An account already exists with the same email address but different sign-in credentials. Sign in using a provider associated with this email address."
        
        let errorString = erorr.localizedDescription
        
        
        
        if(errorString == overlapEmail){
            message = "사용돤 이메일입니다."
        }
        
        
        
        
        
        let alert = UIAlertController(title: "경고", message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "확인", style: .default){
            
            (action : UIAlertAction) -> Void in
            self.view?.dismiss(animated: true)
        }
        
        alert.addAction(cancelAction)
        self.view?.present(alert, animated: true, completion: nil)
    }
    
}
