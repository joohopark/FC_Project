//
//  diaryCell.swift
//  PCMprojectTest
//
//  Created by 이주형 on 2018. 4. 23..
//  Copyright © 2018년 이주형. All rights reserved.
//

import UIKit

class diaryCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var Privatekey: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        self.imageView = UIImage(named: "yang.jpg")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
