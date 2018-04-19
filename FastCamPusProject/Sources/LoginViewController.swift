//
//  ViewController.swift
//  FastCamPusProject
//
//  Created by 이주형 on 2018. 4. 8..
//  Copyright © 2018년 이주형. All rights reserved.
//

import UIKit
import GoogleSignIn
import Firebase
import FBSDKLoginKit

class LoginViewController: UIViewController{
    
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var signInGoogle: GIDSignInButton!

    @IBOutlet weak var singInfacebook: FBSDKLoginButton!
    var alert: customAlert?
    
    

    
    
    @IBOutlet weak var SignInbtn: UIButton!
    @IBOutlet weak var createUserbtn: UIButton!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        print("============ [ LoginViewController ] ============")
        alert = customAlert()
        alert?.view = self
        singInfacebook.readPermissions = ["email", "public_profile"]
        
        
        
        
        GIDSignIn.sharedInstance().delegate = self
        
        GIDSignIn.sharedInstance().uiDelegate = self
        singInfacebook.delegate = self
        
        for const in singInfacebook.constraints{
            if const.firstAttribute == NSLayoutAttribute.height && const.constant == 28{
                singInfacebook.removeConstraint(const)
            }
        }

    }
    
    override func loadViewIfNeeded() {
        super.loadViewIfNeeded()
        self.navigationController?.hideNavigationBar()
    }

    @IBAction func SignIn(_ sender: UIButton) {
        print("SignIn")
        Auth.auth().signIn(withEmail: self.email.text!, password: self.password.text!) { (user, error) in
            
            guard error == nil else {
                self.alert?.show(erorr: error!)
                return
            }
            
            
        }
    }
    
    
    @IBAction func createUser(_ sender: UIButton) {
        print("createUser")
        let storyboryboard = UIStoryboard(name: "Lee", bundle: nil)
        let nextview: createUserViewController = storyboryboard.instantiateViewController(withIdentifier: "createUserViewController") as! createUserViewController
        self.navigationController?.pushViewController(nextview, animated: true)
    }
    
    
    
    @IBAction func logincheck(_ sender: UIButton) {
        print("=================== [ logout ] ===================")
        
        
     
       let user = Auth.auth().currentUser
        
        if user != nil {
            print("User is signed in.")
            print(user?.displayName! ?? "")
            print(user?.photoURL! ?? "")
        } else {
            print("No user is signed in.")
        }
    }
    @IBAction func logout(_ sender: UIButton) {
        FBSDKLoginManager.init().logOut()
        try! Auth.auth().signOut()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    
    
    
    
    
    
}

extension LoginViewController : GIDSignInUIDelegate ,GIDSignInDelegate, FBSDKLoginButtonDelegate, UITextFieldDelegate {
    
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        // ...
        print("=============2====[ google login ]===2==============")
        if let error = error {
            // ...GoogleService-Info.plist
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        //        AuthCredential
        
        
        AuthService.init().AuthCredentialLogin(token: credential) { (restul,user) in
            switch restul {
            case .success(let value):
                print(value)
            case .error(let error):
                print(error)
            case .loginerror(let loginError):
                self.alert?.show(erorr: loginError)
                print(loginError.localizedDescription)
            }
        }
    }
    
    
    
    func signInWillDispatch(signIn: GIDSignIn!, error: NSError!) {
        print("signInWillDispatch")
    }
    
    // Present a view that prompts the user to sign in with Google
    func signIn(signIn: GIDSignIn!,
                presentViewController viewController: UIViewController!) {
        print("presentViewController")
    }
    
    // Dismiss the "Sign in with Google" view
    func signIn(signIn: GIDSignIn!,
                dismissViewController viewController: UIViewController!) {
        print("dismissViewController")
    }
    
    
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!){
        
        guard error == nil else { return }
        guard result != nil else { return }
       
        
  
        getFBUserData()
//        print(result)
//
//        Auth.auth().signIn(with: credential) { (user, error) in
//            guard error == nil else { return }
//            print(user?.displayName)
//            print(user?.email)
//        }
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("띠옹")
    }
    

    

    
    
    func getFBUserData(){
//        sizeThatFits
//        let ss = FBSDKButton.init(frame: CGRect.zero)
//        ss.sizeThatFits(<#T##size: CGSize##CGSize#>)
        
        print("===============[ getFBUserData ]===============")
      guard FBSDKAccessToken.current() != nil else { return }
        
        FBSDKGraphRequest(graphPath: "me", parameters:["fields": "name, picture.type(large), email"])
            .start(completionHandler: { (connection, result, error) -> Void in
                
                guard error == nil else { return }
                print("===============[ FBSDKGraphRequest ]===============")
                
                guard let data = result as? [String:Any] else { return }
                print(data)
                guard  let image = ((data["picture"] as! [String:Any])["data"] as! [String:Any])["url"] as? String else { return }
                print(image)
                guard let name = data["name"] as? String else { return }
               print(name)
                let email = data["email"] as? String ?? ""
                print(email)
                
                print("===============[ FaceBook -> Firebase result ]===============")

                let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                AuthService.init().AuthCredentialLogin(token: credential, completion: { (result,user)  in
                    switch result {
                        case .success(let value):
                            print("===============[ FaceBook -> Firebase result   success  ]===============")
                            print(value)
                        
//                            self.presentingViewController?.dismiss(animated: true, completion: nil)
                        case .error(let error):
                            print("===============[ FaceBook -> Firebase result   error  ]===============")
                            print(error)
                        case .loginerror(let loginerror):
                            
                            print("===============[ FaceBook -> Firebase result   loginerror  ]===============")
                            print(loginerror.localizedDescription)
                            FBSDKLoginManager.init().logOut()
                            self.alert?.show(erorr: loginerror)

                        
                        
                        }
                })
            })
    }
}



