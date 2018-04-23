//
//  ListingDiaryViewController.swift
//  TradeDiary
//
//  Created by 주호박 on 2018. 4. 10..
//  Copyright © 2018년 주호박. All rights reserved.
//

import UIKit


extension DateFormatter {
    static let yyyyMMdd: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "ko_kr")
        return formatter
    }()
}

struct Objects {
    
    var sectionName : Date!
    var sectionObjects : [diaryItem]!
}


func converting(array:[diaryItem]) -> [Objects] {
    var objarray: [Objects] = []
    
    for value in array
    {
        let valuye = objarray.filter{ $0.sectionName  == value.date }
        
        if (valuye.isEmpty){
            objarray.append(Objects(sectionName: value.date, sectionObjects: [value]))
        }else{
            for v2 in 0..<objarray.count {
                if objarray[v2].sectionName == value.date {
                    objarray[v2].sectionObjects.append(value)
                }
            }
        }
    }
    
    return objarray
}




class ListingDiaryViewController: UIViewController {
    var array: [Objects] = []
    @IBOutlet weak var mytableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        mytableview.backgroundView = UIImageView(image: UIImage(named: "yang.jpg"))
        
        mytableview.register(UINib(nibName: "diaryCell", bundle: nil), forCellReuseIdentifier: "diaryCell")
        mytableview.register(UINib(nibName: "diarySectionsCell", bundle: nil), forCellReuseIdentifier: "diarySectionsCell")
        
        
        
        let jsonString = """
        [
            {
                "Userindex":206,
                "UserEmail":"tkdrb4807@gmail.com",
                "Name":"이주형",
                "Login_uid":"e2Fbl6GkxwPFPtUaPEYcVna9jJF3",
                "No":3,
                "authority":1,
                "Contents":"내용이당33",
                "date":"2018-04-15"

            },
        {"Userindex":218,"UserEmail":"hyeng@naver.com","Name":"gg","Login_uid":"JdTVD2bKSkesx5bPqrc2avmXl6c2","No":6,"authority":2,"Contents":"내용33","date":"2018-04-15"},
        {"Userindex":206,"UserEmail":"tkdrb4807@gmail.com","Name":"이주형","Login_uid":"e2Fbl6GkxwPFPtUaPEYcVna9jJF3","No":2,"authority":1,"Contents":"내용이당22","date":"2018-04-14"},
        {"Userindex":218,"UserEmail":"hyeng@naver.com","Name":"gg","Login_uid":"JdTVD2bKSkesx5bPqrc2avmXl6c2","No":5,"authority":2,"Contents":"내용22","date":"2018-04-14"},
        {"Userindex":206,"UserEmail":"tkdrb4807@gmail.com","Name":"이주형","Login_uid":"e2Fbl6GkxwPFPtUaPEYcVna9jJF3","No":1,"authority":1,"Contents":"내용이당11","date":"2018-04-13"},
        {"Userindex":218,"UserEmail":"hyeng@naver.com","Name":"gg","Login_uid":"JdTVD2bKSkesx5bPqrc2avmXl6c2","No":4,"authority":2,"Contents":"내용11","date":"2018-04-13"}]
        """
        
        let jsonData = jsonString.data(using: .utf8)!
        
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(DateFormatter.yyyyMMdd)
            let rssFeed = try! decoder.decode([diaryItem].self, from: jsonData)
            
            self.array = converting(array: rssFeed)
            self.mytableview.reloadData()
        } catch {
            print(error.localizedDescription)
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
