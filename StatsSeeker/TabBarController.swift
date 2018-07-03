//
//  TabBarController.swift
//  StatsSeeker
//
//  Created by Сергей Никитин on 04.06.2018.
//  Copyright © 2018 Sergey Nikitin. All rights reserved.
//

import UIKit
import SwiftyJSON

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        readAppConfig()
        
        selectedIndex = 1
        getSitesList()
        getWordsList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
