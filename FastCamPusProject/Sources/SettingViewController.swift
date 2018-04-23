//
//  SettingViewController.swift
//  TradeDiary
//
//  Created by 주호박 on 2018. 4. 10..
//  Copyright © 2018년 주호박. All rights reserved.
//

import UIKit

var aramTime: Int = 0

class SettingViewController: UIViewController {
    var Alert:customAlert?
    var TempEditField: UITextField?
    @IBOutlet weak var ScrollView: UIScrollView!
    //IBOutlet hook up
    // aram buttons
    @IBOutlet var buttonList: [UIButton]!
    @IBOutlet weak var firendEditUid: UITextField!
    @IBOutlet weak var aramTimeLB: UILabel!
    
    var firendEditString: String?
    
    static var hour: Int = 9{
        didSet{
            aramTime = (hour * 60 * 60) + min * 60
        }
    }
    
    static var min: Int = 10{
        didSet{
            aramTime = (hour * 60 * 60) + min * 60
        }
    }
    
    var timer = Timer()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Alert = customAlert()
        Alert?.view = self
        firendEditUid.delegate = self
        let app = UIApplication.shared
        let notificationSettings = UIUserNotificationSettings(types: [.alert, .sound], categories: nil)
        app.registerUserNotificationSettings(notificationSettings)
        registNotification()
    }
    
    override func loadViewIfNeeded() {
        super.loadViewIfNeeded()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        unregistNotification()
    }
    
    @objc func keyboardDidShow(_ noti:Notification) {
        
        let notiInfo = noti.userInfo! as NSDictionary
        let keyBoardFrame = notiInfo[UIKeyboardFrameEndUserInfoKey] as! CGRect
        
        let contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyBoardFrame.height, 0.0);
        self.ScrollView.contentInset = contentInsets;
        self.ScrollView.scrollIndicatorInsets = contentInsets;
        let aRect: CGRect = self.view.frame;
        if (aRect.contains((firendEditUid?.frame.origin)!)) {
            self.ScrollView.contentSize = CGSize(width: self.ScrollView.frame.width, height:  self.ScrollView.frame.height + keyBoardFrame.height)
            
            self.ScrollView.scrollRectToVisible((self.firendEditUid?.frame)!, animated: true)
        }
        
        let keyBoardFrameAnimation  = notiInfo[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        UIView.animate(withDuration: keyBoardFrameAnimation) {
            self.view.layoutIfNeeded()
        }
        
    }
    
    @objc func keyboardWillHide(_ noti:Notification) {
        print("hide")
        
        let notiInfo = noti.userInfo! as NSDictionary
        ScrollView.contentSize = CGSize(width: self.view.frame.width, height:  self.view.frame.height)
        ScrollView.contentOffset.y = 0
        
        let keyBoardFrameAnimation  = notiInfo[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        UIView.animate(withDuration: keyBoardFrameAnimation) {
            self.view.layoutIfNeeded()
        }
    }
    
    
    func registNotification() -> Void {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    
    func unregistNotification() -> Void {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    
    
    
    @IBAction func firendAddActiom(_ sender: UIButton) {
     
        if(firendEditString == nil || firendEditString == ""){
            print("데이터를 입력해주세요")
        }else{
            var massage = ""
            AuthService.init().friendAdd(myuid: "e2Fbl6GkxwPFPtUaPEYcVna9jJF3", fruenduid: "1KOoPqW6MzgdXXYspb2a4vD6uo13") { (result) in
                switch result {
                case .success(let value):
                    print(value)
                    massage = value
                case .error(let error):
                    print(error)
                }
                self.Alert?.show("친구 추가", message: massage)
                
            }
        }
    }
}
    
    
 
    


extension SettingViewController{
    
    // 0 : 시간 1시간 증가
    // 1 : 분 10분 증가
    // 2 : 분 10분 감소
    // 3: 시간 1시간 감소
    @IBAction func didPushChangeTimerButton(_ sender: UIButton){
        switch sender.tag {
        case 0:// 0 : 시간 1시간 증가
            if SettingViewController.hour == 23{
                SettingViewController.hour = 0
            }else{
                SettingViewController.hour += 1
            }
        case 1:// 1 : 분 10분 증가
            if SettingViewController.min == 55{
                SettingViewController.min = 0
                SettingViewController.hour += 1
            }
            SettingViewController.min += 1
        case 2:// 2 : 분 10분 감소
            if SettingViewController.min != 0{
                SettingViewController.min -= 5
            }else{
                SettingViewController.hour -= 1
                SettingViewController.min = 55
            }
        case 3:// 3: 시간 1시간 감소
            if SettingViewController.hour != 0{
                SettingViewController.hour -= 1
            }
        default:
            print("err ocure in InterfaceBuilder..")
        }
        if SettingViewController.hour < 10{
            if SettingViewController.min == 0 {
                aramTimeLB?.text = "0\(SettingViewController.hour):0\(SettingViewController.min)"
            }else{
                aramTimeLB?.text = "0\(SettingViewController.hour):\(SettingViewController.min)"
            }
        }else if SettingViewController.min == 0{
            aramTimeLB?.text = "\(SettingViewController.hour):0\(SettingViewController.min)"

        }else{
            aramTimeLB?.text = "\(SettingViewController.hour):\(SettingViewController.min)"
        }
    }
}


extension SettingViewController: UITextFieldDelegate {
    //TempEditField firendEditUid
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField {
        case firendEditUid:
            TempEditField  = firendEditUid
        default:
            break
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        switch textField {
        case firendEditUid:
            guard string.unicodeScalars.first?.value != 10 else { return true }
            let text = textField.text ?? ""
            let replacedText = (text as NSString).replacingCharacters(in: range, with: string)
            firendEditString = replacedText
        default:
            break
        }
        return true
        
   

        
        
        
        
        return true
    }
    
}





