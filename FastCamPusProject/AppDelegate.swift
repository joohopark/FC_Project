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
    

    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }

    
    
    func application(_ application: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any])
        -> Bool {
            
            let sourceApplication = options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String?
       
            let google = GIDSignIn.sharedInstance().handle(url,sourceApplication:options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
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
        FBSDKLoginManager.init().logOut()
        try! Auth.auth().signOut()
        
        let storboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        var mainVc = storboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = mainVc
        self.window?.makeKeyAndVisible()
        
    
     
        
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if  user == nil {
                let storboard:UIStoryboard = UIStoryboard(name: "Lee", bundle: nil)
                let next = storboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                let navi = UINavigationController(rootViewController: next)
                self.window?.rootViewController = navi
                self.window?.makeKeyAndVisible()
            } else {
                let storboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                var mainVc = storboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                let navi = UINavigationController(rootViewController: mainVc)
                self.window?.rootViewController = navi
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
        
        let app = UIApplication.shared
        let notificationSettings = UIUserNotificationSettings(types: [.alert, .sound], categories: nil)
        app.registerUserNotificationSettings(notificationSettings)
        
        
//        let nowDate : NSDate = NSDate(timeIntervalSinceNow: Double(time.secondsFromGMT)) // 로컬 시간
//        print(nowDate) // 결과: 2016-07-04 03:51:14 +0000

        
        let time : TimeZone = TimeZone(identifier: "Asia/Yakutsk")!
        let date = Date(timeIntervalSinceNow: Double(time.secondsFromGMT()))
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute, .second], from: date)
        
        
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        dateFormatter.locale = NSLocale(localeIdentifier: "ko_KR") as Locale?
        
        let currentTimeTransSeconds = (components.hour!-9)*60*60 + components.minute!*60 + components.second!
        dump("현재 시간 : \(date)")
        dump(currentTimeTransSeconds)
        
        
        // 총시간 - 현재시간 + 설정시간
        // 음수 값이면 하루 이후로 되야 하고
        // 양수 값이면 앞으로 몇 분후가 되는거임.
        let alertTime: NSDate = NSDate()
        if currentTimeTransSeconds - aramTime < 0{
            alertTime.addingTimeInterval(TimeInterval((86400-currentTimeTransSeconds)+aramTime-54000))
        }else{
            alertTime.addingTimeInterval(TimeInterval(currentTimeTransSeconds-aramTime))
        }
        
        
        
        dump("설정 시간 : \(aramTime)")
        dump(TimeInterval((86400-currentTimeTransSeconds)))
        dump(TimeInterval((86400-currentTimeTransSeconds)+aramTime))
        dump("알람 시간 : \(alertTime)")
        let notifyAlarm = UILocalNotification()
        
        notifyAlarm.fireDate = alertTime as Date
        notifyAlarm.timeZone = NSTimeZone.default
        notifyAlarm.soundName = "bell_tree.mp3"
        notifyAlarm.alertBody = "일기쓸 시간입니다."
        app.scheduleLocalNotification(notifyAlarm)
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


