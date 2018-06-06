//
//  StatPresenterController.swift
//  StatsSeeker
//
//  Created by Сергей Никитин on 05.06.2018.
//  Copyright © 2018 Sergey Nikitin. All rights reserved.
//

import UIKit
import SwiftyJSON

class StatPresenterController: UITableViewController {

    var site: Site?
    var word: Word?
    
    var ranks: [Rank] = []
    
    var result: [String: Int] = [:]
    var names: [String] = []
    
    let queue: OperationQueue = {
        let queue = OperationQueue()
        queue.qualityOfService = .userInteractive
        return queue
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getStat()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func getStat() {
        ranks.removeAll(keepingCapacity: false)
        names.removeAll(keepingCapacity: false)
        result.removeAll(keepingCapacity: false)
        
        tableView.separatorStyle = .none
        ViewControllerUtils().showActivityIndicator(uiView: self.tableView)
        
        let url = "persons/rank"
        let getServerData = GetServerDataOperation(url: url, parameters: nil)
        getServerData.completionBlock = {
            guard let data = getServerData.data else { return }
            
            guard let json = try? JSON(data: data) else { self.jsonErrorMessage(); return }
            //print(json)
            
            self.ranks = json.compactMap({ Rank(json: $0.1) })
            
            for rank in self.ranks {
                if let site = self.site {
                    if rank.siteID == site.id {
                        if let num = self.result[rank.wordName] {
                            self.result[rank.wordName] = num + rank.rank
                        } else {
                            self.result[rank.wordName] = rank.rank
                            self.names.append(rank.wordName)
                        }
                    }
                } else if let word = self.word {
                    if rank.wordID == word.id {
                        if let num = self.result[rank.siteName] {
                            self.result[rank.siteName] = num + rank.rank
                        } else {
                            self.result[rank.siteName] = rank.rank
                            self.names.append(rank.siteName)
                        }
                    }
                }
            }
            
            OperationQueue.main.addOperation {
                self.tableView.reloadData()
                ViewControllerUtils().hideActivityIndicator()
                
                if self.names.count == 0, let title = self.title {
                    self.showErrorMessage(title: title, msg: "Ошибка! В базе данных отсутствует информация по данному виду статистики.")
                } else {
                    self.tableView.separatorStyle = .singleLine
                }
            }
        }
        queue.addOperation(getServerData)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if names.count > 0 {
            return 10
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if names.count > 0 {
            return 10
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

        cell.textLabel?.text = "\(indexPath.row+1). \(names[indexPath.row])"
        
        if let rank = result[names[indexPath.row]] {
            cell.detailTextLabel?.text = "\(rank)"
        }
        
        return cell
    }
}
