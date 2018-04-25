//
//  NewPostViewController.swift
//  TradeDiary
//
//  Created by 주호박 on 2018. 4. 10..
//  Copyright © 2018년 주호박. All rights reserved.
//

import UIKit
import Alamofire

class NewPostViewController: UIViewController {
    // MARK:- Properties
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentsView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dailyImageView: UIImageView?
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var isOpen: UISwitch!
    @IBOutlet var tapGesture: UITapGestureRecognizer!
    @IBOutlet weak var textViewBottomHeight: NSLayoutConstraint!
    
    var Service:AuthService = AuthService()
    var hasImage: Bool = false
    var diaryItem: diaryItem!
    var isModifyMode: Bool = false

//    var isPhotoListEmpty: Bool = false
    
    // MARK:- Method
    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
       
        if let post = diaryItem{
            textView.text = post.Contents
            
            AuthService.init().diaryimage(No: post.No) { (result) in
                switch result{
                case .success(let value):
                    self.hasImage = (value != nil) ? true : false
                    print("start ======================================\(post.No)", self.hasImage)
                    if self.hasImage {
                        self.heightConstraint.constant = 115
                        self.dailyImageView?.image = value
                    }
                case .error(let error):
                    print(error)
                }
            }
        }
        
        // 현재 날짜 표시
        dateLabel.text = getCurrentDate()
        dateLabel.font = UIFont(name: "Papyrus", size: 22)
        dateLabel.textAlignment = .center
        
        dailyImageView?.isUserInteractionEnabled = true
        tapGesture.delegate = self
        textView.font = UIFont(name: "SavoyeLetPlain", size: 25)
        scrollView.isScrollEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        makeKeyboardToolBar()
        // Keyboard Observer
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
    /// saveDiary
    ///
    /// - Parameter sender: ???
    func saveDiary(_ sender: Any) {
        // DiaryData 객체를 생성하고, 데이터를 담음.
        let data = DiaryData()
        
        data.contents = self.textView?.text
        data.image = self.dailyImageView?.image
        data.isOpenAnother = self.isOpen.isOn
    }
    
    // CheckIn Method
    @IBAction func checkIsOpen(_ sender: UISwitch) {
        if isOpen.isOn == true {
            isOpen.isOn = true
        } else {
            isOpen.isOn = false
        }
    }

}

// MARK: - Keyboard ToolBar Method
extension NewPostViewController {
    
    /// Keyboard TooBar 설정 Method
    private func makeKeyboardToolBar() {
        // Keyboard ToolBar 생성
        let toolBar = UIToolbar()           // Keyboard Toolbar 생성
        toolBar.sizeToFit()
        // toolBar의 버튼 사이 유연공간 마련
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace,
                                            target: nil,
                                            action: nil)
        // Done Button 설정
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done,
                                         target: self,
                                         action: #selector(doneButtonTuched(_:)))
        // 현재 시간 삽입 label 설정
        let timeStampLabel = UIBarButtonItem(title: "🕔",
                                             style: UIBarButtonItemStyle.done,
                                             target: self,
                                             action: #selector(addCurrentTimeLabel))
        
        // Image 추가
        let addImageButton = UIBarButtonItem(title: "🏞",
                                             style: UIBarButtonItemStyle.done,
                                             target: self,
                                             action: #selector(selectImageSource(_:)))
        
        toolBar.setItems([timeStampLabel, flexibleSpace, addImageButton, flexibleSpace, doneButton], animated: false)   // tool Bar에 BarButtonItems 설정
        textView.inputAccessoryView = toolBar // Text View의 inputAccessoryView에 toolBar 설정.
    }
    
    /// Done Button Touch시 키보드 내려감.
    /// Done 버튼 누르면 자동으로 값을 diary 인스턴스에 저장한다.
    /// - Parameter sender: Done buttyon touch
    @objc private func doneButtonTuched(_ sender: Any) {
        self.view.endEditing(true)
        saveDiary(())
        
        let authority = isOpen.isOn ? "1":"2"
        let Contents = textView.text!
        let image :Data? = (self.dailyImageView?.image != nil) ? UIImagePNGRepresentation((self.dailyImageView?.image)!) : nil
        
        if isModifyMode == true {
            //수정
            print("""
            \(authority)
            \(Contents)
            
            """)
            AuthService.init().diaryModify(No: diaryItem.No , uid: diaryItem.Login_uid, authority: authority, Contents: Contents, image: image) { (result) in
                switch result {
                    
                case .success(let value):
                    print(value)
                case .error(_):
                    print("오류")
                }
            }
        } else {
            Service.diaryCreate(uid: Usertoken!, authority: authority, Contents: Contents, image: image!) { (result) in
                switch result {
                case .success(let value):
                    print(value)
                case .error(let error):
                    print(error.localizedDescription)
                }
            }
        }
//        self.view.removeFromSuperview()// 리스폰더 체인에서 제거
//        self.removeFromParentViewController()//부모로부터 해당 뷰컨을 제거
//        let prevVC = viewControllers.count
//        print(prevVC)
    }
    
    ///  현재 시간을 TextView에 첨부시키는 Method
    @objc private func addCurrentTimeLabel() {
        let timeText: String = getCurrentTime()
        textView.insertText(timeText)
    }
    
    // Keyboard Show Method
    @objc func keyboardWillShow(notification: Notification) {
        if let userInfo = notification.userInfo {
            if let keyboardSize = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                if hasImage == false {
                    textViewBottomHeight.constant = keyboardSize.height
                } else {
                    textViewBottomHeight.constant = keyboardSize.height + 100
                }
            }
        }
    }
    
    // Keyboard hide Method
    @objc func keyboardWillHide(notification: Notification) {
        textViewBottomHeight.constant = 0.0
    }
}

// MARK:- ImagePicker Method
extension NewPostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // Image Picking
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage
        //let cropRect = info[UIImagePickerControllerCropRect]!.CGRectValue
        dailyImageView?.image = pickedImage!
        dailyImageView?.contentMode = .scaleAspectFill
        dailyImageView?.layer.masksToBounds = true
        hasImage = true
        self.heightConstraint.constant = self.hasImage ? 115 : 0
        picker.dismiss(animated: false)
    }
    
    // Image Source Type Select Method
    func imgPicker(_ source: UIImagePickerControllerSourceType) {
        let picker = UIImagePickerController()
        picker.sourceType = source
        picker.delegate = self
        picker.allowsEditing = true
        self.present(picker, animated: true, completion: nil)
    }
    // Image Source Types Explain Method
    @objc func selectImageSource(_ sender: Any) {
        self.view.endEditing(true)
        if hasImage == false {
            
            let alert = UIAlertController(title: nil,
                                          message: "사진을 가져올 곳을 선택해 주세요.",
                                          preferredStyle: .actionSheet)
            // 카메라
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                alert.addAction(UIAlertAction(title: "카메라",
                                              style: .default,
                                              handler: { (_) in
                    self.imgPicker(.camera)
                }))
            }
            // 저장된 앨범
            if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
                alert.addAction(UIAlertAction(title: "저장된 앨범",
                                              style: .default,
                                              handler: { (_) in
                    self.imgPicker(.savedPhotosAlbum)
                }))
            }
            // Photo Library
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                alert.addAction(UIAlertAction(title: "포토 라이브러리",
                                              style: .default,
                                              handler: { (_) in
                    self.imgPicker(.photoLibrary)
                }))
            }
            // Cancel Button
            alert.addAction(UIAlertAction(title: "취소",
                                          style: .cancel,
                                          handler: nil))
            
            // ActionSheet 창 실행
            self.present(alert, animated: true, completion: nil)
        } else {
            deleteImageView()
        }
    }
    
}

// MARK: - Gesture Method
extension NewPostViewController: UIGestureRecognizerDelegate {
    // 이미지를 Tap하면 전체화면으로 사진이 변경되는 메서드
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        // print("tapped")
        let fullImageView = UIImageView()
        fullImageView.frame = CGRect(x: 0,
                                     y: 0 - UIApplication.shared.statusBarFrame.height,
                                     width: self.view.frame.size.width,
                                     height: UIScreen.main.bounds.height )
        UIApplication.shared.statusBarView?.isHidden = true
        fullImageView.image = dailyImageView?.image
        fullImageView.contentMode = .scaleAspectFill
        fullImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullScreenImage(_:)))
        fullImageView.addGestureRecognizer(tap)
        self.view.addSubview(fullImageView)
        return true
    }
    
    // 전체화면으로 확대된 사진에서 원래 화면으로 복귀하는 메서드
    @objc func dismissFullScreenImage(_ sender: UIGestureRecognizer) {
        sender.view?.removeFromSuperview()
        UIApplication.shared.statusBarView?.isHidden = false
    }

    // 이미지를 지우는 메서드
    func deleteImageView() {
        let alert = UIAlertController(title: nil,
                                      message: "사진을 지우시겠습니까?",
                                      preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "지움", style: .default) { (_) in
            self.hasImage = false
            self.dailyImageView?.image = nil
            self.heightConstraint.constant = self.hasImage ? 115 : 10
            let data = DiaryData()
            data.image = nil
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(deleteAction)
        alert.addAction(cancel)
        self.present(alert, animated: false, completion: nil)
    }
}
