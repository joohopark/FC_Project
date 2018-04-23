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
    

    var date:(String,String) = ("",""){
        didSet{
            self.dataloading(year: self.date.0, month: monthConverting(pibot: self.date.1))
        }
    }
    
    
    func monthConverting(pibot:String) -> String {
        
        var bot = ""
        switch pibot {
        case "JAN":
            bot = "1"
        case "FEB":
            bot = "2"
        case "MAR":
            bot = "3"
        case "APR":
            bot = "4"
        case "MAY":
            bot = "5"
        case "JUN":
            bot = "6"
        case "JUL":
            bot = "7"
        case "AUG":
            bot = "8"
        case "SEP":
            bot = "9"
        case "OCT":
            bot = "10"
        case "NOV":
            bot = "11"
        case "DEC":
            bot = "12"
        default:
            bot = pibot
        }
        return bot
    }
    
    
    
    
    @IBOutlet weak var mytableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        mytableview.backgroundView = UIImageView(image: UIImage(named: "yang.jpg"))
        
        mytableview.register(UINib(nibName: "diaryCell", bundle: nil), forCellReuseIdentifier: "diaryCell")
        mytableview.register(UINib(nibName: "diarySectionsCell", bundle: nil), forCellReuseIdentifier: "diarySectionsCell")
        print(Usertoken)
        
        // Do any additional setup after loading the view.
    }
    
    func dataloading(year:String, month:String){
        AuthService.init().diaryList(uid: Usertoken!, year: year, month: month) { (result) in
            switch result {
                
            case .success(let value):
                self.array = value
                self.mytableview.reloadData()
            case .error(let error):
                print(error.localizedDescription)
            }
        }
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(70)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(100)
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
        guard let sectionName = self.array[section].sectionName else { return nil }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy /MM /dd .EE"
        let dateString = dateFormatter.string(from: sectionName)
        //        let dateFormatter = DateFormatter()
        //        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        //        dateFormatter.locale = NSLocale(localeIdentifier: "ko_KR") as Locale?
        cell.createdDay?.text = "\(dateString)"
        return cell
    }
    
    
}
