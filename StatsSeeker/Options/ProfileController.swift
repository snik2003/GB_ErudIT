//
//  ProfileController.swift
//  StatsSeeker
//
//  Created by Сергей Никитин on 05.06.2018.
//  Copyright © 2018 Sergey Nikitin. All rights reserved.
//

import UIKit

class ProfileController: UITableViewController {

    @IBOutlet weak var userCell: UITableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let userLabel = userCell.viewWithTag(1) as? UILabel, let roleLabel = userCell.viewWithTag(2) as? UILabel, let mailLabel = userCell.viewWithTag(3) as? UILabel, let avatar = userCell.viewWithTag(4) as? UIImageView {
            
            userLabel.text = appConfig.shared.appUser.login
            mailLabel.text = appConfig.shared.appUser.email
            
            if appConfig.shared.appUser.isAdmin == 0 {
                roleLabel.text = "Пользователь"
            } else {
                roleLabel.text = "Администратор"
            }
            
            avatar.layer.borderWidth = 0.7
            avatar.layer.borderColor = UIColor.lightGray.cgColor
            avatar.layer.cornerRadius = 25
            
            userCell.isHidden = false
            
            print("token = \(appConfig.shared.appUser.token)")
        }
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
        if indexPath.section == 1 && indexPath.row == 0 {
            self.showErrorMessage(title: "Приложение «\(appConfig.shared.appName)»", msg: "Данный раздел находится в стадии разработки. Приносим извинения за неудобства.")
        }
        
        // options of app
        if indexPath.section == 1 && indexPath.row == 1 {
            performSegue(withIdentifier: "options", sender: self)
        }
        
        // about company
        if indexPath.section == 1 && indexPath.row == 2 {
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
        if indexPath.section == 2 && indexPath.row == 0 {
            self.showErrorMessage(title: "Приложение «\(appConfig.shared.appName)»", msg: "Данный раздел находится в стадии разработки. Приносим извинения за неудобства.")
        }
        
        // change user
        if indexPath.section == 3 && indexPath.row == 0 {
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
            alertController.addAction(cancelAction)
            
            let action = UIAlertAction(title: "Выйти из пользователя «\(appConfig.shared.appUser.login)»", style: .destructive) { action in
                if let controller = self.storyboard?.instantiateViewController(withIdentifier: "StartViewController") as? ViewController {
                
                    Auth().removeDefaults()
                    UIApplication.shared.keyWindow?.rootViewController = controller
                }
            }
            alertController.addAction(action)
            present(alertController, animated: true)
        }
        
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
