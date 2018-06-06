//
//  OptionsController.swift
//  StatsSeeker
//
//  Created by Сергей Никитин on 05.06.2018.
//  Copyright © 2018 Sergey Nikitin. All rights reserved.
//

import UIKit

class OptionsController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.white
        
        return view
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.white
        
        return view
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // change password
        if indexPath.section == 0 && indexPath.row == 0 {
            self.showErrorMessage(title: "Приложение «\(appConfig.shared.appName)»", msg: "Данный раздел находится в стадии разработки. Приносим извинения за неудобства.")
        }
        
        // options of app
        if indexPath.section == 0 && indexPath.row == 1 {
            self.showErrorMessage(title: "Приложение «\(appConfig.shared.appName)»", msg: "Данный раздел находится в стадии разработки. Приносим извинения за неудобства.")
        }
        
        // about company
        if indexPath.section == 0 && indexPath.row == 2 {
            let alertController = UIAlertController(title: appConfig.shared.appSite, message: nil, preferredStyle: .actionSheet)
            
            let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
            alertController.addAction(cancelAction)
            
            let action = UIAlertAction(title: "Открыть сайт в Safari", style: .default) { action in
                if let url = URL(string: appConfig.shared.appSite) {
                    UIApplication.shared.open(url, options: [:])
                }
            }
            alertController.addAction(action)
            present(alertController, animated: true)
        }
        
        // buy the paid version of app
        if indexPath.section == 1 && indexPath.row == 0 {
            self.showErrorMessage(title: "Приложение «\(appConfig.shared.appName)»", msg: "Данный раздел находится в стадии разработки. Приносим извинения за неудобства.")
        }
        
        // change user
        if indexPath.section == 2 && indexPath.row == 0 {
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
            alertController.addAction(cancelAction)
            
            let action = UIAlertAction(title: "Сменить пользователя", style: .destructive) { action in
                if let controller = self.storyboard?.instantiateViewController(withIdentifier: "StartViewController") as? ViewController {
                
                    UIApplication.shared.keyWindow?.rootViewController = controller
                }
            }
            alertController.addAction(action)
            present(alertController, animated: true)
        }
    }
}
