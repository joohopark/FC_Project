//
//  ListingDiaryViewController.swift
//  TradeDiary
//
//  Created by 주호박 on 2018. 4. 10..
//  Copyright © 2018년 주호박. All rights reserved.
//

import UIKit

class ListingDiaryViewController: UIViewController {
    var delegate: dateDelegete?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
   
        
        // Do any additional setup after loading the view.
    }
    
    
    func tabl() -> Void {
        print("씨발")
    }
    
    
    
}


//extension ListingDiaryViewController: dateDelegete {
//    func setYearMonth(Date month: String, year: String) {
//        print("setYearMonth")
//    }
//
//
//}


//MARK:- TableView Setting
extension ListingDiaryViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    // 셀의 종류는 서버에서 받아올 값이 있는지 없는지를 판단해서
    // 결정해서 반환한다.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostingCell", for: indexPath) as! PostingCell
            cell.dalilyLB.text = "14"
            cell.dateLB.text = "MON"
            cell.contentsTextView.text = """
            더미 데이터 입니다.
            """
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "NonPostingCell", for: indexPath) as! NonPostingCell
        return cell
    }
}
