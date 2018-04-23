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
    
    
    func show(_ title:String, message:String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "확인", style: .default){
            
            (action : UIAlertAction) -> Void in
            self.view?.dismiss(animated: true)
        }
        
        alert.addAction(cancelAction)
        self.view?.present(alert, animated: true, completion: nil)
    }
    
    func show(erorr: Error){
        
        var message = ""
        
        
        let overlapEmail = "An account already exists with the same email address but different sign-in credentials. Sign in using a provider associated with this email address."
        
        
        let passwordErorr = "The password is invalid or the user does not have a password."
        
        let emailnotfind = "There is no user record corresponding to this identifier. The user may have been deleted."
        
        let errorString = erorr.localizedDescription
        
        
        
        if(errorString == overlapEmail){
            message = "사용돤 적이 있는 이메일입니다."
        }else if(errorString == emailnotfind){
            message = "유효한 Email이 없습니다."
        }else if(errorString == passwordErorr){
            message = "비밀번호가 틀렸습니다."
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
