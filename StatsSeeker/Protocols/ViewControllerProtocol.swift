//
//  ViewControllerProtocol.swift
//  StatsSeeker
//
//  Created by Сергей Никитин on 04.06.2018.
//  Copyright © 2018 Sergey Nikitin. All rights reserved.
//

import UIKit
import SwiftyJSON
import SCLAlertView

protocol ViewControllerProtocol {
    
    func showErrorMessage(title: String, msg: String)
    
    func showSuccessMessage(title: String, msg: String)
    
    func showInfoMessage(title: String, msg: String)
    
    func jsonErrorMessage()
    
    func failedAuthMessage()
    
    func openStatPresenter(site: Site?, word: Word?, title: String)
    
    func openChartController(data: [String: Int], names: [String], description: String, title: String)
}

extension UIViewController: ViewControllerProtocol {
    
    func saveAppConfig() {
        UserDefaults.standard.set(appConfig.shared.apiURL, forKey: "apiURL")
        UserDefaults.standard.set(appConfig.shared.realmOn, forKey: "realmOn")
    }
    
    func readAppConfig() {
        if let text = UserDefaults.standard.string(forKey: "apiURL") {
            appConfig.shared.apiURL = text
        }
        appConfig.shared.realmOn = UserDefaults.standard.bool(forKey: "realmOn")
    }
    
    func getSitesList() {
        
        let parameters = [
            "token_auth": appConfig.shared.appUser.token
        ]
        let getServerData = GetServerDataOperation(url: "sites", parameters: parameters, method: .get)
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
        OperationQueue().addOperation(getServerData)
    }
    
    func getWordsList() {
        
        let parameters = [
            "token_auth": appConfig.shared.appUser.token
        ]
        let getServerData = GetServerDataOperation(url: "persons", parameters: parameters, method: .get)
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
        OperationQueue().addOperation(getServerData)
    }
    
    func showErrorMessage(title: String, msg: String) {
        
        OperationQueue.main.addOperation {
            let appearance = SCLAlertView.SCLAppearance(
                kWindowWidth: UIScreen.main.bounds.width - 40,
                kTitleFont: UIFont(name: "Verdana", size: 13)!,
                kTextFont: UIFont(name: "Verdana", size: 12)!,
                kButtonFont: UIFont(name: "Verdana-Bold", size: 12)!,
                showCloseButton: false
            )
            
            let alert = SCLAlertView(appearance: appearance)
            
            alert.addButton("OK", action: {})
            alert.showError(title, subTitle: msg)
        }
    }
    
    func showSuccessMessage(title: String, msg: String) {
        
        OperationQueue.main.addOperation {
            let appearance = SCLAlertView.SCLAppearance(
                kWindowWidth: UIScreen.main.bounds.width - 40,
                kTitleFont: UIFont(name: "Verdana", size: 13)!,
                kTextFont: UIFont(name: "Verdana", size: 12)!,
                kButtonFont: UIFont(name: "Verdana-Bold", size: 12)!,
                showCloseButton: false
            )
            
            let alert = SCLAlertView(appearance: appearance)
            
            alert.addButton("OK", action: {})
            alert.showSuccess(title, subTitle: msg)
        }
    }
    
    func showInfoMessage(title: String, msg: String) {
        
        OperationQueue.main.addOperation {
            let appearance = SCLAlertView.SCLAppearance(
                kWindowWidth: UIScreen.main.bounds.width - 40,
                kTitleFont: UIFont(name: "Verdana", size: 13)!,
                kTextFont: UIFont(name: "Verdana", size: 12)!,
                kButtonFont: UIFont(name: "Verdana-Bold", size: 12)!,
                showCloseButton: false
            )
            
            let alert = SCLAlertView(appearance: appearance)
            
            alert.addButton("OK", action: {})
            alert.showInfo(title, subTitle: msg)
        }
    }
    
    func jsonErrorMessage() {
        OperationQueue.main.addOperation {
            ViewControllerUtils().hideActivityIndicator()
            self.showErrorMessage(title: "Ошибка в \(appConfig.shared.appName)!", msg: "Ошибка получения данных. Проверьте подключение к Интернету.")
        }
    }
    
    func failedAuthMessage() {
        OperationQueue.main.addOperation {
            self.showErrorMessage(title: "Ошибка авторизации!", msg: "Неверное имя пользователя или пароль. Повторите попытку.\n")
        }
    }
    
    func openStatPresenter(site: Site?, word: Word?, title: String) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "StatPresenterController") as! StatPresenterController
        
        controller.site = site
        controller.word = word
        controller.title = title
        
        self.navigationController?.navigationItem.leftBarButtonItem?.title = "Назад"
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func openChartController(data: [String: Int], names: [String], description: String, title: String) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "ChartController") as! ChartController
        
        controller.data = data
        controller.names = names
        controller.descriptionLabel = description
        controller.title = title
        
        self.navigationController?.navigationItem.leftBarButtonItem?.title = "Назад"
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

extension Array where Element: Equatable  {
    mutating func delete(element: Iterator.Element) {
        self = self.filter{$0 != element }
    }
}
