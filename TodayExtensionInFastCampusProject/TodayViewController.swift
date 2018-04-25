//
//  TodayViewController.swift
//  TodayExtensionInFastCampusProject
//
//  Created by 주호박 on 2018. 4. 19..
//  Copyright © 2018년 이주형. All rights reserved.
//


import CoreLocation
import MapKit
import UIKit
import NotificationCenter
import Alamofire


class TodayViewController: UIViewController, NCWidgetProviding, CLLocationManagerDelegate {
    let locationManager: CLLocationManager = CLLocationManager()
    var lat, lon: Double!
    
    @IBOutlet weak var weatherImgView: UIImageView!
    @IBOutlet weak var friendImgView: UIImageView!
//    @IBOutlet weak var dDayLB: UILabel!
    @IBOutlet weak var cityLB: UILabel!
    @IBOutlet weak var tempLB: UILabel!
    @IBOutlet weak var todayMentLB: UILabel!
    
    
    var userUID: String!
    var friendList: [Userinfo] = []
    
    var weatherManager = WeatherManager()
    var weatherData: Weather!{
        didSet{
            switch weatherData.weather[0].main {
            case "Clear":
                weatherImgView.image = UIImage(named: "clear")
                todayMentLB.text = "햇빛이 쨍쨍~"
            case "Clouds":
                weatherImgView.image = UIImage(named: "clouds")
                todayMentLB.text = "구름이 심란해요~"
            case "Rain":
                weatherImgView.image = UIImage(named: "rain")
                todayMentLB.text = "우산 꼭 챙기세요~"
            case "Mist":
                weatherImgView.image = UIImage(named: "mist")
                todayMentLB.text = "운전 조심하세요~"
            case "Haze":
                weatherImgView.image = UIImage(named: "haze")
                todayMentLB.text = "바람이 많이 불어요~"
            default:
                print(WrongWeatherInfo.invalidWeather)
            }
            cityLB.text = weatherData.sys.country
            tempLB.text = String(weatherData.main.temp)
            
            dump(weatherData)
                print("weather Infomation Loading End==========")
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.extensionContext?.widgetLargestAvailableDisplayMode = NCWidgetDisplayMode.expanded
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        //        locationManager.stopUpdatingLocation()
        //        downloadWeatherData()
        

        if let userDefaults = UserDefaults(suiteName: "group.jhbob.weatherTest") {
            print(userDefaults.string(forKey: "testkey")!)
            userUID = userDefaults.string(forKey: "testkey")!
        }
        
        guard let uid = userUID else { return }
        AuthService.init().AuthFriendList(uid: uid) { (result) in
            switch result{
            case .success(let value):
                self.friendList = value
                print("friendList : \(value)")
                AuthService.init().userProfileimage(userindex: self.friendList[0].Userindex) { (result) in
                    switch result{
                    case .success(let value):
                        self.friendImgView.image = value
                    case .error(let error):
                        print(error)
                    }
                }

            case .error(let error):
                print(error)
            }
        }
        
        print(userUID, friendList)
        dump(friendList)
        
        
        
        
        
        AuthService.init().diaryimage(No: 1) { (result) in
            switch result{
            case .success(let value):
                print(value)
            case .error(let error):
                print(error)
            }
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        for currentLocaion in locations{
            print("위치 받아라~ : \(index): \(currentLocaion)")
            lat = currentLocaion.coordinate.latitude
            lon = currentLocaion.coordinate.longitude
        }
        
        downloadWeatherData()
    }
    
}

extension TodayViewController{
    private func downloadWeatherData(){
        weatherManager.downloadLocationWeatherData(lat: String(lat), lon: String(lon), completion: { result in
            //downloadLocationWeatherData 가 location에 대한 응답을 가져옵니다.
            // switch 를 통해 원하는 UI에 값을 넣어 줄수 있습니다.
            switch result{
            case .success(let value):
//                print(value)
                self.weatherData = value
            case .error(let error):
                print(error.localizedDescription)
                //                print(error)
            case .loginerror(_):
                print("===========================뭔가 잘못 되었어..")
            }
        })
    }
}
