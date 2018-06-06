//
//  Configuration.swift
//  StatsSeeker
//
//  Created by Сергей Никитин on 04.06.2018.
//  Copyright © 2018 Sergey Nikitin. All rights reserved.
//

import UIKit

final class appConfig {
    static let shared = appConfig()
    
    let appName = "ЭрудIT"
    let appSite = "https://dtgb.solutions"
    
    let backColor = UIColor.init(red: 200/255, green: 229/255, blue: 239/255, alpha: 1)
    let textColor = UIColor.init(red: 0/255, green: 250/255, blue: 146/255, alpha: 1)
    
    let apiURL1 = "https://kruserapi.dtgb.solutions"
    let apiURL2 = "https://smallapi.dtgb.solutions"
    
    let apiVersion = "v1"
}
