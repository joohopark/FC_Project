//
//  MonthCollectionViewController.swift
//  FastCamPusProject
//
//  Created by 주호박 on 2018. 4. 19..
//  Copyright © 2018년 이주형. All rights reserved.
//

import UIKit

//private let reuseIdentifier = "Cell"



class MonthCollectionViewController: UICollectionViewController {

    private let monthList: [String] = ["JAN","FEB","MAR","APR","MAY","JUN","JUL","AUG","SEP","OCT","NOV","DEC"]
    let yearList = [Int](2008...2018)
    
    var isViewControllerMonth = true
    var delegate: SendDataDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView?.register(UINib(nibName: "MonthCellXIB", bundle: nil), forCellWithReuseIdentifier: "MonthCell")

        // Do any additional setup after loading the view.
    }



    // MARK: UICollectionViewDataSource

//    override func numberOfSections(in collectionView: UICollectionView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        if isViewControllerMonth{
            return monthList.count
        }
        return yearList.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MonthCell", for: indexPath) as! MonthCell
    
        if isViewControllerMonth{
            cell.backgroundColor = .gray
            cell.labelName = monthList[indexPath.item]
            cell.label?.textColor = .black
            cell.layer.cornerRadius = cell.frame.height / 2
        }else{
            cell.backgroundColor = .white
            cell.labelName = String(yearList[indexPath.item])
            cell.label?.textColor = .black
            cell.layer.cornerRadius = cell.frame.height / 2
        }
        
        // Configure the cell
        
        
        
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}

extension MonthCollectionViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        print("======================== [ MonthCollectionViewController  sizeForItemAt ] ========================")
        return CGSize(width: 40, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        print("======================== [ MonthCollectionViewController  insetForSectionAt ] ========================")
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        print("======================== [ MonthCollectionViewController  didSelectItemAt ] ========================")
        if isViewControllerMonth{
                delegate?.sendData(data: monthList[indexPath.item], isSelectBtn: isViewControllerMonth)
        }else{
            delegate?.sendData(data: String(yearList[indexPath.item]),isSelectBtn: isViewControllerMonth)
        }
        
        self.willMove(toParentViewController: nil)
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
    }
    
}


protocol SendDataDelegate {
    func sendData(data: String, isSelectBtn: Bool)
}




