//
//  TimeHandler.swift
//  FastCamPusProject
//
//  Created by dave on 16/04/2018.
//  Copyright © 2018 이주형. All rights reserved.
//

import Foundation

/// 현재 시간을 불러오기 위한 메서드
/// "3:56 pm" 형식으로 반환
/// - Returns: 현재 시간 값 반환(String type)
func getCurrentTime() -> String {
    let currentTime = Date()
    let timeFormatter = DateFormatter()
    timeFormatter.locale = Locale(identifier: "en_US_POSIX")
    timeFormatter.dateFormat = "h:mm a"
    timeFormatter.amSymbol = "am"
    timeFormatter.pmSymbol = "pm"
    let stringTime = timeFormatter.string(from: currentTime)
    return stringTime
}

func getCurrentDate() -> String {
    let currentDate = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    dateFormatter.dateFormat = "EEEE / MMMM dd / yyyy"
    let stringDate = dateFormatter.string(from: currentDate)
    return stringDate
}
