//
//  Auth.swift
//  StatsSeeker
//
//  Created by Сергей Никитин on 04.06.2018.
//  Copyright © 2018 Sergey Nikitin. All rights reserved.
//

import Foundation
import SwiftyJSON

class Auth {
    
    var delegate: UIViewController!
    
    func autorization(_ login: String, _ pass: String, completion: @escaping (Int) -> ()) {
        
        var userID = 0
        let getServerData = GetServerDataOperation(url: "users", parameters: nil)
        getServerData.completionBlock = {
            guard let data = getServerData.data else { return }
            
            guard let json = try? JSON(data: data) else { self.delegate.jsonErrorMessage(); return }
            //print(json)
            
            let users = json.compactMap({ User(json: $0.1) })
            for user in users {
                if login.lowercased() == user.login.lowercased() {
                    if pass == "123456" {
                        appConfig.shared.appUser = user
                        self.saveDefaults()
                        userID = user.id
                    } else {
                        userID = 0
                    }
                }
            }
            
            completion(userID)
        }
        OperationQueue().addOperation(getServerData)
    }
    
    func saveDefaults() {
        if let user = try? JSONEncoder().encode(appConfig.shared.appUser) {
            UserDefaults.standard.set(user, forKey: appConfig.shared.appUserDefaultsKeyName)
        }
    }
    
    func getDefaults() -> Bool {
        
        if let user = UserDefaults.standard.object(forKey: appConfig.shared.appUserDefaultsKeyName) as? Data {
            if let loadUser = try? JSONDecoder().decode(User.self, from: user) {
                appConfig.shared.appUser = loadUser
                return true
            }
        }
        return false
    }
    
    func removeDefaults() {
        UserDefaults.standard.removeObject(forKey: appConfig.shared.appUserDefaultsKeyName)
    }
}
