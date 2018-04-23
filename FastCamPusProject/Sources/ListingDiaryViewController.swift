//
//  ListingDiaryViewController.swift
//  TradeDiary
//
//  Created by 주호박 on 2018. 4. 10..
//  Copyright © 2018년 주호박. All rights reserved.
//

import UIKit






class ListingDiaryViewController: UIViewController {
    var array: [Objects] = []
    @IBOutlet weak var mytableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mytableview.register(UINib(nibName: "diaryCell", bundle: nil), forCellReuseIdentifier: "diaryCell")
        mytableview.register(UINib(nibName: "diarySectionsCell", bundle: nil), forCellReuseIdentifier: "diarySectionsCell")
        print(Usertoken)
        AuthService.init().diaryList(uid: Usertoken!, year: 2018, month: 04) { (result) in
            switch result {
                
            case .success(let value):
                self.array = value
                self.mytableview.reloadData()
            case .error(let error):
                print(error.localizedDescription)
            }
        }
        // Do any additional setup after loading the view.
    }
}


//MARK:- TableView Setting
extension ListingDiaryViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.array.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.array[section].sectionObjects.count
    }
    
    // 셀의 종류는 서버에서 받아올 값이 있는지 없는지를 판단해서
    // 결정해서 반환한다.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "diaryCell") as! diaryCell
        cell.name.text = self.array[indexPath.section].sectionObjects[indexPath.row].Name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "diarySectionsCell") as! diarySections_Cell
        cell.createdDay.text = "\(self.array[section].sectionName)"
        return cell
    }
    
    
}
