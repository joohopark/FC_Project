//
//  NewPostViewController.swift
//  TradeDiary
//
//  Created by 주호박 on 2018. 4. 10..
//  Copyright © 2018년 주호박. All rights reserved.
//

import UIKit
import SnapKit

class NewPostViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentsView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dailyImageView: UIImageView?
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var isOpen: UISwitch!
    
    var hasImage: Bool = false
    
    

//    var isPhotoListEmpty: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // 현재 날짜 표시
        dateLabel.text = getCurrentDate()
        //dateLabel.font = UIFont.fontNames(forFamilyName: "BiauKai")
        dateLabel.font = UIFont(name: "Papyrus", size: 22)
        dateLabel.textAlignment = .center
    }
    
    override func viewWillAppear(_ animated: Bool) {
        makeKeyboardToolBar()
        
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
        
        toolBar.setItems([timeStampLabel, flexibleSpace, addImageButton, flexibleSpace, doneButton], animated: false)      // tool Bar에 BarButtonItems 설정
        textView.inputAccessoryView = toolBar // Text View의 inputAccessoryView에 toolBar 설정.
    }
    
    /// Done Button Touch시 키보드 내려감.
    /// Done 버튼 누르면 자동으로 값을 diary 인스턴스에 저장한다.
    /// - Parameter sender: Done buttyon touch
    @objc private func doneButtonTuched(_ sender: Any) {
        view.endEditing(true)
        saveDiary(())
    }
    
    ///  현재 시간을 TextView에 첨부시키는 Method
    @objc private func addCurrentTimeLabel() {
        let timeText: String = getCurrentTime()
        textView.text.append(timeText)
    }
}

// MARK: - ImagePicker
extension NewPostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    /// 이미지 추가 버튼
    @objc func addImage(_ sender: Any) {
        // Image PIcker Instance 생성
        let picker = UIImagePickerController()
        // Image Picker 화면에 표시
        picker.delegate = self
        picker.allowsEditing = true
        self.present(picker, animated: false)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage
        //let cropRect = info[UIImagePickerControllerCropRect]!.CGRectValue
        dailyImageView?.image = pickedImage!
        hasImage = true
        heightConstraint.constant = hasImage ? 115 : 0
        picker.dismiss(animated: false)
    }
    
    func imgPicker(_ source: UIImagePickerControllerSourceType) {
        let picker = UIImagePickerController()
        picker.sourceType = source
        picker.delegate = self
        picker.allowsEditing = true
        self.present(picker, animated: true, completion: nil)
    }
    
    @objc func selectImageSource(_ sender: Any) {
        let alert = UIAlertController(title: nil,
                                      message: "사진을 가져올 곳을 선택해 주세요.",
                                      preferredStyle: .actionSheet)
        // 카메라
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alert.addAction(UIAlertAction(title: "카메라", style: .default, handler: { (_) in
                self.imgPicker(.camera)
            }))
        }
        // 저장된 앨범
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            alert.addAction(UIAlertAction(title: "저장된 앨범", style: .default, handler: { (_) in
                self.imgPicker(.savedPhotosAlbum)
            }))
        }
        // Photo Library
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            alert.addAction(UIAlertAction(title: "포토 라이브러리", style: .default, handler: { (_) in
                self.imgPicker(.photoLibrary)
            }))
        }
        // Cancel Button
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        
        // ActionSheet 창 실행
        self.present(alert, animated: true, completion: nil)
    }
    
}
