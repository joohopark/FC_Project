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
    
    // 사진첩에서 사진이 추가되면 이쪽으로 추가 시켜야 될것 같아요 그럼 자동으로 CollectionView가 리로드
    var photoList: [UIImage] = []{
        didSet{
            self.collectionView.reloadData()
            collectionView.isHidden = false
        }
    }
    
    var isPhotoListEmpty: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for const in collectionView.constraints{
            if const.firstAttribute == NSLayoutAttribute.height && const.constant == 28{
                
//                singInfacebook.removeConstraint(const)
                
            }
            print(const)
        }
        // 이쪽에서 저 배열에 값이 추가되는지 확인
    }

    // 테스트를 위해 이미지 예시 삽입
    @IBAction func didPushTestButton(_ sender: UIButton){
        if isPhotoListEmpty{// 비어 있으면 List 값 넣어
            setPhotoList()
            debugPrint("append photoList New Value ========================== \(photoList.count)")
        }else{// 채워져있음 비워
            photoList = []
            debugPrint("Delete All Value photoList ========================== \(photoList.count)")
        }
        
    }
    
    @IBAction func didPushRedrawButton(_ sender: UIButton){
        textViewMakeConstraints()
        
//        view.translatesAutoresizingMaskIntoConstraints = NO
    }
    
}

extension NewPostViewController{

    func textViewMakeConstraints(){
        if checkImgExist(){
//            collectionView.isHidden = false// 보여줘
            textView.snp.makeConstraints { (make) in
                make.top.equalTo(collectionView).offset(20)//기존 배치 TextView위치로 옮긴다.
            }
            self.view.layoutIfNeeded()
        }else{
            collectionView.isHidden = true// 없애줘
            // 텍스트 뷰의 콘스테인 이걸 다시 잡는걸 코드로?
            textView.snp.makeConstraints { (make) in
                make.top.equalTo(contentsView).offset(20)// 원래 컬렉션 뷰의 자리로 옮겨 준다.
            }
            self.view.layoutIfNeeded()
        }
    }
    
    
    func checkImgExist() -> Bool{
        if photoList.count > 1{
            return true
        }
        return false
    }

    
    func setPhotoList(){
        photoList.append(UIImage(named: "PhotoCellImg")!)
        photoList.append(UIImage(named: "test")!)
        photoList.append(UIImage(named: "test2")!)
        photoList.append(UIImage(named: "test3")!)
        photoList.append(UIImage(named: "test4")!)
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

