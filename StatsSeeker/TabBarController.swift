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

    let queue: OperationQueue = {
        let queue = OperationQueue()
        queue.qualityOfService = .userInteractive
        return queue
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectedIndex = 1
        getSitesList()
        getWordsList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getSitesList() {
        
        let getServerData = GetServerDataOperation(url: "sites", parameters: nil, method: .get)
        getServerData.completionBlock = {
            guard let data = getServerData.data else { return }
            
            guard let json = try? JSON(data: data) else { return }
            //print(json)
            
            var sites = json.compactMap { Site(json: $0.1) }
                
            for site in sites {
                if site.addedBy != appConfig.shared.appUser.addedBy {
                    sites.delete(element: site)
                }
            }
                
            appConfig.shared.sites = sites
        }
        queue.addOperation(getServerData)
    }
    
    func getWordsList() {
        
        let getServerData = GetServerDataOperation(url: "persons", parameters: nil, method: .get)
        getServerData.completionBlock = {
            guard let data = getServerData.data else { return }
            
            guard let json = try? JSON(data: data) else { self.jsonErrorMessage(); return }
            //print(json)
            
            var words = json.compactMap { Word(json: $0.1) }
                
            for word in words {
                if word.addedBy != appConfig.shared.appUser.addedBy {
                    words.delete(element: word)
                }
            }
            
            appConfig.shared.words = words
        }
        queue.addOperation(getServerData)
    }
}
