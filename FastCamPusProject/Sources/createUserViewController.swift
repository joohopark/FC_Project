//
//  createUserViewController.swift
//  FastCamPusProject
//
//  Created by 이주형 on 2018. 4. 12..
//  Copyright © 2018년 이주형. All rights reserved.
//

import UIKit
import Firebase


struct eidtingcheck {
    var email: Bool = false
    var password: Bool = false
    var Repassword: Bool = false
    var name: Bool = false
    var view: UIViewController?
    
    mutating func setView(view: UIViewController){
        self.view = view
    }
    
  
    
    func alart(message:String){
        let alert = UIAlertController(title: "경고", message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "확인", style: .default){
            
            (action : UIAlertAction) -> Void in
            self.view?.dismiss(animated: true)
        }
        
        alert.addAction(cancelAction)
        self.view?.present(alert, animated: true, completion: nil)
    }
    

    
    func check() -> Bool {
        var check = true
        if email == false {
            alart(message: "이메일을 확인해주세요")
            check = false
        }else if password == false {
            alart(message: "비밀번호을 확인해주세요")
            check = false
        }else if Repassword == false {
            alart(message: "비밀번호확인을 확인해주세요")
            check = false
        }else if name == false {
            alart(message: "이름을 확인해주세요")
            check = false
        }
        
        return check
        
    }
    
}


class createUserViewController: UIViewController {
    
    @IBOutlet weak var ScrollView: UIScrollView!
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileImageBtn: UIButton!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var Repassword: UITextField!
    @IBOutlet weak var name: UITextField!
      var  UITextFieldTemp: UITextField?
    @IBOutlet weak var crateBtn: UIButton!
    
    var editingCheck:eidtingcheck?
    
    let picker = UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("222")
        delegateinit()
        settinginit()
        registNotification()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        unregistNotification()
    }
    
    override func loadViewIfNeeded() {
        super.loadViewIfNeeded()
        self.navigationController?.showNavigationBar()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func settinginit() -> Void {
        editingCheck = eidtingcheck()
        editingCheck?.setView(view: self)
    }
    
    func frameinit() -> Void {
        self.profileImageBtn.layer.cornerRadius = self.profileImageBtn.bounds.size.width / 2
        self.profileImage.layer.cornerRadius = self.profileImage.bounds.size.width / 2
        self.profileImage.layer.masksToBounds = true
    }
    
    func delegateinit() -> Void {
        
        self.picker.delegate = self
        
        self.email.delegate = self
        self.password.delegate = self
        self.Repassword.delegate = self
        self.name.delegate = self
    
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
    
    
    
    @IBAction func profileAtion(_ sender: UIButton) {
        picker.sourceType = .photoLibrary
        present(picker, animated: false, completion: nil)
        
    }
    
    
    
    @IBAction func UserCreateAction(_ sender: UIButton) {
        print("=================================")
        
        guard editingCheck!.check() else {
            print("띠옹")
            return
        }
        
        
        let email = self.email.text!
        let password = self.password.text!
        
        
        let firebase = Auth.auth()
        firebase.createUser(withEmail: email, password: password ) { (user, error) in
            
            guard error == nil else {
                
                print(error?.localizedDescription)
                print("21")
                if error?.localizedDescription == "The email address is already in use by another account." {
                    
                    self.editingCheck?.alart(message: "사용한 이메일입니다")
                } else if error?.localizedDescription == "The password must be 6 characters long or more." {
                    self.editingCheck?.alart(message: "비밀번호는 6자리이어야 합니다")
                    
                }
                return
            }
            
            
            
            let imageData = UIImagePNGRepresentation(self.profileImage.image!)
            print("============ [ createUser ] ============")
            AuthService.init().signInAPP(email: self.email.text!, password: self.password.text!, imageData:  imageData!, displayName: self.name.text!, uid: (user?.uid)!,  completion: { (result) in
                firebase.signIn(withEmail: self.email.text!, password: self.password.text!) { (user, error) in
                    guard error == nil else { return }
                    print(user)
                }
            })
            
            
           
        }
    }

}


extension createUserViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            self.profileImage.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField {
        case email:
            UITextFieldTemp  = email
        case password:
            UITextFieldTemp  = password
        case Repassword:
            UITextFieldTemp  = Repassword
        case name:
            UITextFieldTemp  = name
        default:
            break
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
        case email:
            if email.text != "" &&  email.text == nil {
                editingCheck?.alart(message: "이메일을 입력해주세요")
            }else{
                editingCheck?.email = true
                self.password.becomeFirstResponder()
            }
        
        case password:
            if password.text != "" &&  password.text == nil {
                editingCheck?.alart(message: "비밀번호을 입력해주세요")
            }else if (password.text?.count)! <= 5 {
                editingCheck?.alart(message: "비밀번호는 6자리이어야 합니다")
            }else{
                editingCheck?.password = true
                self.Repassword.becomeFirstResponder()
            }
            
        case Repassword:
            if Repassword.text != "" &&  Repassword.text == nil {
                editingCheck?.alart(message: "비밀번호확인을 입력해주세요")
            }else if Repassword.text != password.text {
                editingCheck?.alart(message: "두비밀번호가 일치 하지 않습니다.")
            }else{
                editingCheck?.Repassword = true
                self.name.becomeFirstResponder()
            }
            
        case name:
            if name.text != "" &&  name.text == nil {
                editingCheck?.alart(message: "이름을 입력해주세요")
            }else{
                editingCheck?.name = true
                self.view.endEditing(true)
            }
            
        default:
            break
        }
   
        return true
    }
    
    @objc func keyboardDidShow(_ noti:Notification) {
        
        let notiInfo = noti.userInfo! as NSDictionary
        let keyBoardFrame = notiInfo[UIKeyboardFrameEndUserInfoKey] as! CGRect

        let contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyBoardFrame.height, 0.0);
        self.ScrollView.contentInset = contentInsets;
        self.ScrollView.scrollIndicatorInsets = contentInsets;
        let aRect: CGRect = self.view.frame;
        if (aRect.contains((UITextFieldTemp?.frame.origin)!)) {
            self.ScrollView.contentSize = CGSize(width: self.ScrollView.frame.width, height:  self.ScrollView.frame.height + keyBoardFrame.height)
            
            self.ScrollView.scrollRectToVisible((self.UITextFieldTemp?.frame)!, animated: true)
        }
        
        let keyBoardFrameAnimation  = notiInfo[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        UIView.animate(withDuration: keyBoardFrameAnimation) {
            self.view.layoutIfNeeded()
        }
        
    }
    
    @objc func keyboardWillHide(_ noti:Notification) {
        print("hide")
        
        let notiInfo = noti.userInfo! as NSDictionary

        ScrollView.contentOffset.y = 0
        
        let keyBoardFrameAnimation  = notiInfo[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        UIView.animate(withDuration: keyBoardFrameAnimation) {
            self.view.layoutIfNeeded()
        }
    }
    
}





