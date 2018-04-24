//
//  WeatherManager.swift
//  FastCamPusProject
//
//  Created by 주호박 on 2018. 4. 19..
//  Copyright © 2018년 이주형. All rights reserved.
//

import Foundation
import Alamofire


// MARK : - Weather Manager
// Description : 얘를 불러다가 원하는 UI에 날씨정보를 가져다 사용할 수 있습니다.
class WeatherManager{
    //    static var defaults: WeatherManager = WeatherManager.init()
    var resValues: Weather!
    
    private let appID = "b792f9611dabab4ad3e6738d810faf3c"
    
    func downloadLocationWeatherData(lat: String,lon: String ,completion: @escaping (Result<Weather>) -> ()){
        let url = URL(string:
            "http://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(appID)")!
        //api.openweathermap.org/data/2.5/weather?lat=37&lon=-122&appid=b792f9611dabab4ad3e6738d810faf3c
        Alamofire.request(url)
            .responseData(completionHandler: { (response) in
                switch response.result{
                case .success(let value):
                    // 여기서 valuse -> weather 로 변경
                    // 그걸 completion으로 넘겨준다. 이런식으로 request에 대한 response 처리를 completionHandler로 넘겨줄수 있다.
                    // 때문에 인자로 @escaping이 오는거임.
                    do{
                        let weatherData = try JSONDecoder().decode(Weather.self, from: value)
                        completion(.success(weatherData))
                    }catch{
                        completion(.error(error))
                    }
                case .failure(let error):
                    completion(.error(error))
                }
            })
    }
}

struct Weather: Codable {
    let coord: Coord
    let weather: [WeatherElement]
    let base: String
    let main: Main
    let visibility: Int
    let wind: Wind
    let clouds: Clouds
    let dt: Int
    let sys: Sys
    let id: Int
    let name: String
    let cod: Int
}

struct Clouds: Codable {
    let all: Int
}

struct Coord: Codable {
    let lon, lat: Double
}

struct Main: Codable {
    let temp: Double
    let pressure, humidity: Int
    let tempMin, tempMax: Double
    
    enum CodingKeys: String, CodingKey {
        case temp, pressure, humidity
        case tempMin = "temp_min"
        case tempMax = "temp_max"
    }
}

struct Sys: Codable {
    let type, id: Int
    let message: Double
    let country: String
    let sunrise, sunset: Int
}

struct WeatherElement: Codable {
    let id: Int
    let main, description, icon: String
}

struct Wind: Codable {
    let speed: Double
    let deg: Double
}

extension Weather{
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        coord = try values.decode(Coord.self, forKey: .coord)
        weather = try values.decode([WeatherElement].self, forKey: .weather)
        base = try values.decode(String.self, forKey: .base)
        main = try values.decode(Main.self, forKey: .main)
        visibility = try values.decode(Int.self, forKey: .visibility)
        wind = try values.decode(Wind.self, forKey: .wind)
        clouds = try values.decode(Clouds.self, forKey: .clouds)
        dt = try values.decode(Int.self, forKey: .dt)
        sys = try values.decode(Sys.self, forKey: .sys)
        id = try values.decode(Int.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
        cod = try values.decode(Int.self, forKey: .cod)
    }
}




//enum Result<T> {
//    case success(T)
//    case error(Error)
//
//}

//
////토큰, URL , 파싱 관련한 에러가 발생했을때
//// 응답을 받을때 발생할수있는 놈들
//enum ServiceError: Error {
//    case invalidToken
//    case invalidURL
//    case parsingError
//}

enum WrongWeatherInfo: Error{
    case invalidWeather
}

//// 포스팅 시도했을때 발생 가능 한 에러 정의
//enum PostError: Error {
//    case missingParameter(param: String)
//    case encodingError
//}
//
//// 요청할때 인증 시도 시 발생 가능한 에러 정의
//enum AuthError: Error {
//    case invalidUsername
//    case invalidPassword
//}

protocol GetWeatherData {
    // 날씨 정보 가져오기
    func retrieveCurrentWeatherData(location: String, completion: @escaping (Result<Weather>) -> ())
    
    //    func retrievePostList(completion: @escaping (Result<[Post]>) -> ())// 포스팅 한거확인 하는 걸로
    //    func createPost(title: String, content: String?, imageData: Data?, completion: @escaping (Result<Post>) -> ())// 포스팅 생성
}
