//
//  AppDelegate.swift
//  FastCamPusProject
//
//  Created by 이주형 on 2018. 4. 8..
//  Copyright © 2018년 이주형. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FBSDKLoginKit





@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    
    var alert: customAlert?
    var window: UIWindow?


    //구글 로그인 관련
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        // ...
        print("=================[ google login ]=================")
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
                self.alert?.show(erorr: error!)
                print(loginError.localizedDescription)
            }
        }
        
    }
    
//        Auth.auth().signIn(with: credential) { (user, error) in
//            print("=================[ firebase login ]=================")
//            guard error == nil else { return }
//
//            print("=================[ DB ]=================")
//            print(user?.photoURL as? String ?? "")
//            print(user?.photoURL?.path)
//            print(user?.photoURL)
//            AuthService.init().signInAPI(email: (user?.email)!, photoURL: (user?.photoURL?.absoluteString)!, displayName: (user?.displayName)!, uid: (user?.uid)!, completion: { (restul) in
        //                switch restul {
        //                case .success(let value):
        //                    print(value)
        //                case .error(let error):
        //                    print(error)
        //                }
//            })
    
            
            

    
    
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
        print("지금이니")
    }

    
    
    func application(_ application: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any])
        -> Bool {
            
            
            
            let sourceApplication = options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String?
       
            
            
            
            let google = GIDSignIn.sharedInstance().handle(url,
                                                           sourceApplication:options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                                           annotation: [:])
            
            let facebook = FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
            
            return google || facebook
    }
    
    
    
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        let google = GIDSignIn.sharedInstance().handle(url,sourceApplication: sourceApplication, annotation: annotation)
        
        let facebook =  FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        
        return google || facebook
    }



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
        alert = customAlert()
        alert?.view = self.window?.rootViewController;
        
        //google Login
        FirebaseApp.configure()
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        //Facebook
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        //Login Button UI
        
        let storboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        var mainVc = storboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = mainVc
        self.window?.makeKeyAndVisible()
      
    
        
        
        Auth.auth().addStateDidChangeListener { (auth, user) in
            print("addStateDidChangeListener 222")
            if  user == nil {
                let storboard:UIStoryboard = UIStoryboard(name: "Lee", bundle: nil)
                let next = storboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                self.window?.rootViewController = next
                self.window?.makeKeyAndVisible()
            } else {
                let storboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let next = storboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                self.window?.rootViewController = next
                self.window?.makeKeyAndVisible()
            }
        }
        
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}


