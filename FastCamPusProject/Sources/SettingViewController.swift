//
//  SettingViewController.swift
//  TradeDiary
//
//  Created by 주호박 on 2018. 4. 10..
//  Copyright © 2018년 주호박. All rights reserved.
//

import UIKit

var aramTime: Int = 0

class SettingViewController: UIViewController {

    //IBOutlet hook up
    // aram buttons
    @IBOutlet var buttonList: [UIButton]!
    
    @IBOutlet weak var aramTimeLB: UILabel!
    
    static var hour: Int = 9{
        didSet{
            aramTime = (hour * 60 * 60) + min * 60
        }
    }
    
    static var min: Int = 10{
        didSet{
            aramTime = (hour * 60 * 60) + min * 60
        }
    }
    
    var timer = Timer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let app = UIApplication.shared
        let notificationSettings = UIUserNotificationSettings(types: [.alert, .sound], categories: nil)
        app.registerUserNotificationSettings(notificationSettings)
        
    }
}

extension SettingViewController{
    
    // 0 : 시간 1시간 증가
    // 1 : 분 10분 증가
    // 2 : 분 10분 감소
    // 3: 시간 1시간 감소
    @IBAction func didPushChangeTimerButton(_ sender: UIButton){
        switch sender.tag {
        case 0:// 0 : 시간 1시간 증가
            if SettingViewController.hour == 23{
                SettingViewController.hour = 0
            }else{
                SettingViewController.hour += 1
            }
        case 1:// 1 : 분 10분 증가
            if SettingViewController.min == 55{
                SettingViewController.min = 0
                SettingViewController.hour += 1
            }
            SettingViewController.min += 1
        case 2:// 2 : 분 10분 감소
            if SettingViewController.min != 0{
                SettingViewController.min -= 5
            }else{
                SettingViewController.hour -= 1
                SettingViewController.min = 55
            }
        case 3:// 3: 시간 1시간 감소
            if SettingViewController.hour != 0{
                SettingViewController.hour -= 1
            }
        default:
            print("err ocure in InterfaceBuilder..")
        }
        if SettingViewController.hour < 10{
            if SettingViewController.min == 0 {
                aramTimeLB?.text = "0\(SettingViewController.hour):0\(SettingViewController.min)"
            }else{
                aramTimeLB?.text = "0\(SettingViewController.hour):\(SettingViewController.min)"
            }
        }else if SettingViewController.min == 0{
            aramTimeLB?.text = "\(SettingViewController.hour):0\(SettingViewController.min)"

        }else{
            aramTimeLB?.text = "\(SettingViewController.hour):\(SettingViewController.min)"
        }
    }
}




