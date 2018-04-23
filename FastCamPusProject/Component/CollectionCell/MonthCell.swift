//
//  MonthCell.swift
//  FastCamPusProject
//
//  Created by 주호박 on 2018. 4. 19..
//  Copyright © 2018년 이주형. All rights reserved.
//

import UIKit

class MonthCell: UICollectionViewCell {
    @IBOutlet weak var label:UILabel!
    var labelName: String {
        get{
            return label?.text ?? "Loading..."
        }
        set{
            label?.text = newValue
        }
    }
}
