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
    var statType: String = ""
    
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
                if rank.site.count > 0 {
                    print(rank.site[0].name)
                }
                if rank.word.count > 0 {
                    print(rank.word[0].name)
                }
                print("\n")
            }
            
            
            OperationQueue.main.addOperation {
                self.tableView.reloadData()
                ViewControllerUtils().hideActivityIndicator()
                self.tableView.separatorStyle = .singleLine
                
                /*if self.names.count == 0 {
                    self.showErrorMessage(title: self.itemsMenu[self.selectedMenu], msg: "Ошибка! В базе данных отсутствует информация по данному виду статистики.")
                } else {
                    self.tableView.separatorStyle = .singleLine
                }*/
            }
        }
        queue.addOperation(getServerData)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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

        
        return cell
    }
}
