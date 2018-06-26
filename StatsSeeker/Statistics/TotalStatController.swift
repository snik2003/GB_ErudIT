//
//  TotalStatController.swift
//  StatsSeeker
//
//  Created by Сергей Никитин on 05.06.2018.
//  Copyright © 2018 Sergey Nikitin. All rights reserved.
//

import UIKit
import SwiftyJSON
import BTNavigationDropdownMenu

class TotalStatController: UITableViewController {

    var selectedMenu = 0
    let itemsMenu = ["Статистика по сайту", "Статистика по слову"]
    
    var statType = "sites"
    var names: [String] = []
    
    let queue: OperationQueue = {
        let queue = OperationQueue()
        queue.qualityOfService = .userInteractive
        return queue
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let menuView = BTNavigationDropdownMenu(title: itemsMenu[0], items: itemsMenu as [AnyObject])
        menuView.arrowTintColor = appConfig.shared.textColor
        menuView.cellBackgroundColor = UIColor.white
        menuView.cellSelectionColor = UIColor.white
        menuView.cellTextLabelAlignment = .center
        menuView.cellTextLabelColor = UIColor.black
        menuView.selectedCellTextLabelColor = UIColor.red
        menuView.cellTextLabelFont = UIFont.boldSystemFont(ofSize: 14)
        menuView.navigationBarTitleFont = UIFont.boldSystemFont(ofSize: 15)
        navigationItem.titleView = menuView
        
        menuView.didSelectItemAtIndexHandler = {[weak self] (indexPath: Int) -> () in
            self?.selectedMenu = indexPath
            switch indexPath {
            case 0:
                self?.statType = "sites"
                self?.getStat()
                break
            case 1:
                self?.statType = "persons"
                self?.getStat()
                break
            default:
                break
            }
        }
        
        getStat()
    }

    func getStat() {
        names.removeAll(keepingCapacity: false)
        
        tableView.separatorStyle = .none
        ViewControllerUtils().showActivityIndicator(uiView: self.tableView)
    
        if self.statType == "sites" {
            for site in appConfig.shared.sites {
                self.names.append(site.name)
            }
        } else if self.statType == "persons" {
            for word in appConfig.shared.words {
                self.names.append(word.name)
            }
        }
        
        self.tableView.reloadData()
        ViewControllerUtils().hideActivityIndicator()
        if self.names.count == 0 {
            self.showErrorMessage(title: self.itemsMenu[self.selectedMenu], msg: "Ошибка! В базе данных отсутствует информация по данному виду статистики.")
        } else {
            self.tableView.separatorStyle = .singleLine
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if names.count > 0 {
            return 5
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if names.count > 0 {
            return 5
        }
        return 0
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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "statCell", for: indexPath)

        if self.statType == "sites" {
            cell.textLabel?.text = "\(indexPath.row+1). \(appConfig.shared.sites[indexPath.row].name)"
            cell.detailTextLabel?.text = appConfig.shared.sites[indexPath.row].siteDescription
        } else if self.statType == "persons" {
            cell.textLabel?.text = "\(indexPath.row+1). \(appConfig.shared.words[indexPath.row].name)"
            cell.detailTextLabel?.text = ""
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.statType == "sites" {
            self.openStatPresenter(site: appConfig.shared.sites[indexPath.row], word: nil, title: itemsMenu[0])
        } else if self.statType == "persons" {
            self.openStatPresenter(site: nil, word: appConfig.shared.words[indexPath.row], title: itemsMenu[1])
        }
    }
}
