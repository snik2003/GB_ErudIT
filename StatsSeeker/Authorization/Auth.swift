//
//  Auth.swift
//  StatsSeeker
//
//  Created by Сергей Никитин on 04.06.2018.
//  Copyright © 2018 Sergey Nikitin. All rights reserved.
//

import Foundation
import SwiftyJSON
import SwiftHash

class Auth {
    
    var delegate: UIViewController!
    
    func autorization(_ login: String, _ password: String, completion: @escaping (String) -> ()) {
        
        var result = ""
        
        let parameters = [
            "user": login,
            "password": password
            ]
        
        let getServerData = GetServerDataOperation2(url: "auth", parameters: parameters, method: .post)
        getServerData.completionBlock = {
            guard let data = getServerData.data else { self.delegate.jsonErrorMessage(); return }
            
            guard let json = try? JSON(data: data) else { self.delegate.jsonErrorMessage(); return }
            //print(json)
            
            let success = json["success"].intValue
            if success == 1 {
                let userID = json["user_id"].intValue
                let token = json["token_auth"].stringValue
                result = "\(userID)_\(token)"
            }
            completion(result)
        }
        OperationQueue().addOperation(getServerData)
    }
    
    func signOut(token: String) {
        
        let parameters = [ "token_auth": token ]
        
        let getServerData = GetServerDataOperation2(url: "auth", parameters: parameters, method: .delete)
        getServerData.completionBlock = {
            guard let data = getServerData.data else { self.delegate.jsonErrorMessage(); return }
            
            guard let json = try? JSON(data: data) else { self.delegate.jsonErrorMessage(); return }
            //print(json)
            
            let success = json["success"].intValue
            print("sign out = \(success)")
            OperationQueue.main.addOperation {
                if let controller = self.delegate.storyboard?.instantiateViewController(withIdentifier: "StartViewController") as? ViewController {
            
                    self.removeDefaults()
                    UIApplication.shared.keyWindow?.rootViewController = controller
                }
            }
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
            OperationQueue.main.addOperation {
                self.delegate.performSegue(withIdentifier: "goTabBar", sender: self)
            }
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
