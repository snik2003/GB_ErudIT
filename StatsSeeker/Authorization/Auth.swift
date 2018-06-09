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
    
    var delegate: LoginViewController!
    
    func autorization(_ login: String, _ password: String, completion: @escaping (String) -> ()) {
        
        var result = ""
        let getServerData = GetServerDataOperation(url: "auth", parameters: nil, method: .post)
        getServerData.completionBlock = {
            //guard let data = getServerData.data else { return }
            
            //guard let json = try? JSON(data: data) else { self.delegate.jsonErrorMessage(); return }
            //print(json)
            
            let userID = self.getRequest(login, password) //json["success"].intValue
            if userID > 0 {
                let token = "1234567890" //json["token_auth"].intValue
                result = "\(userID)_\(token)"
            }
            completion(result)
        }
        OperationQueue().addOperation(getServerData)
    }
    
    func getCurrentUserData(_ userID: Int, _ token: String) {
        
        let getServerData = GetServerDataOperation(url: "users/\(userID)", parameters: nil, method: .get)
        getServerData.completionBlock = {
            guard let data = getServerData.data else { return }
            
            guard let json = try? JSON(data: data) else { self.delegate.jsonErrorMessage(); return }
            //print(json)
            
            appConfig.shared.appUser = User(json: json)
            appConfig.shared.appUser.token = token
            self.saveDefaults()
            self.delegate.performSegue(withIdentifier: "goTabBar", sender: self)
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
    
    func getRequest(_ login: String, _ pass: String) -> Int {
        
        var userID = 0
        if login.lowercased() == "admin1" && pass == "1111" {
            userID = 1
        } else if login.lowercased() == "admin2" && pass == "2222" {
            userID = 2
        } else if login.lowercased() == "user1" && pass == "3333" {
            userID = 3
        } else if login.lowercased() == "user2" && pass == "4444" {
            userID = 4
        }
        
        return userID
    }
}
