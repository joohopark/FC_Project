//
//  DiaryData.swift
//  FastCamPusProject
//
//  Created by dave on 23/04/2018.
//  Copyright © 2018 이주형. All rights reserved.
//

import UIKit

class DiaryData {
    var contents: String?   // Diary 내용
    var image: UIImage?     // 이미지
    var registerDate: Date? // 작성일자
    var isOpenAnother: Bool = true      // 공개 여부 ( true: privit, false: show to friend)
}
