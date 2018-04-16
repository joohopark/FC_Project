//
//  NavigationBar.swift
//  FastCamPusProject
//
//  Created by 이주형 on 2018. 4. 12..
//  Copyright © 2018년 이주형. All rights reserved.
//

import Foundation
import UIKit


extension UINavigationController {
    func hideNavigationBar(){
        // Hide the navigation bar on the this view controller
        self.setNavigationBarHidden(true, animated: false)
        
    }
    
    func showNavigationBar() {
        // Show the navigation bar on other view controllers
        self.setNavigationBarHidden(false, animated: false)
    }
}
