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
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentsView: UIView!
    
//    @IBOutlet weak var textViewTop: NSLayoutConstraint!
    @IBOutlet weak var heightZero: NSLayoutConstraint!
    
    // 사진첩에서 사진이 추가되면 이쪽으로 추가 시켜야 될것 같아요 그럼 자동으로 CollectionView가 리로드
    var photoList: [UIImage] = []{
        didSet{
            if self.photoList.count > 1{
                self.heightZero.priority = UILayoutPriority(rawValue: 500)
                self.heightZero.isActive = true
            }else{
                self.heightZero.priority = UILayoutPriority(rawValue: 999)
                self.heightZero.isActive = true
            }
            
            

        }
    }
    
    var isPhotoListEmpty: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        // Keyboard ToolBar 호출
        makeKeyboardToolBar()
    }

    // 테스트를 위해 이미지 예시 삽입
    @IBAction func didPushTestButton(_ sender: UIButton){
        if isPhotoListEmpty{// 비어 있으면 List 값 넣어
            setPhotoList()
            isPhotoListEmpty = false
            debugPrint("append photoList New Value ========================== \(photoList.count)")
        }else{// 채워져있음 비워
            photoList = []
            isPhotoListEmpty = true
            debugPrint("Delete All Value photoList ========================== \(photoList.count)")
        }
        
    }

}

extension NewPostViewController{

    func checkImgExist() -> Bool{
        if photoList.count > 1{
            return true
        }
        return false
    }

    
    func setPhotoList(){
//        photoList.append(UIImage(named: "PhotoCellImg")!)
        photoList.append(UIImage(named: "test")!)
        photoList.append(UIImage(named: "test2")!)
        photoList.append(UIImage(named: "test3")!)
//        photoList.append(UIImage(named: "test4")!)
        collectionView.reloadData()
    }
}


extension NewPostViewController: UICollectionViewDataSource{
    // 사진을 추가했을때 NewPostViewController에 사진첩 배열을 만들어서 그 안에 append 하는 식으로 진행해야 될듯.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 1
        return photoList.count// 프로퍼티 배열에 값이 추가되도록 변경된다면 주석 해제
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
//        cell.photoImageView.image = UIImage(named: "PhotoCellImg")
        cell.photoImageView.image = photoList[indexPath.item]
        return cell
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
        let timeStampLabel = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.bookmarks,
                                             target: self,
                                             action: #selector(addCurrentTimeLabel))
        // Image 추가
        let addImageButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.camera,
                                             target: self,
                                             action: #selector(addImage(_:)))
        
        toolBar.setItems([timeStampLabel, flexibleSpace, addImageButton, flexibleSpace, doneButton], animated: false)      // tool Bar에 BarButtonItems 설정
        textView.inputAccessoryView = toolBar // Text View의 inputAccessoryView에 toolBar 설정.
    }
    
    /// Done Button Touch시 키보드 내려감.
    ///
    /// - Parameter sender: Done buttyon touch
    @objc private func doneButtonTuched(_ sender: Any) {
        view.endEditing(true)
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
        // 선택된 이미지를 표시함.
//        let preview: UIImageView!
//        self.preview.image = info[UIImagePickerControllerEditedImage] as? UIImage

        // 이미지 피커 컨트롤러를 닫음
        picker.dismiss(animated: false)
    }

    
}
