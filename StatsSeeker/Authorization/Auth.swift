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
    
    func autorization(_ login: String, _ pass: String) -> Bool {
        //return false
        
        var userID = 3
        if login == "Admin1" {
            userID = 1
        } else if login == "Admin2" {
            userID = 2
        }
        
        saveUserData(userID: userID)
        
        return true
    }
    
    func saveUserData(userID: Int) {
        
        let url = "users/\(userID)"
        let getServerData = GetServerDataOperation(url: url, parameters: nil)
        getServerData.completionBlock = {
            guard let data = getServerData.data else { return }
            
            guard let json = try? JSON(data: data) else { self.delegate.jsonErrorMessage(); return }
            //print(json)
            
            var user = AppUser()
            user.id = json["id"].intValue
            user.isAdmin = json["isAdmin"].intValue
            user.login = json["login"].stringValue
            user.email = json["email"].stringValue
            if user.isAdmin == 1 {
                user.addedBy = user.id
            } else {
                user.addedBy = json["addedBy"].intValue
            }
            appConfig.shared.appUser = user
            self.saveDefaults()
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
            if let loadUser = try? JSONDecoder().decode(AppUser.self, from: user) {
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
