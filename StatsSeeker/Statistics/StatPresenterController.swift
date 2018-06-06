//
//  StatPresenterController.swift
//  StatsSeeker
//
//  Created by Сергей Никитин on 05.06.2018.
//  Copyright © 2018 Sergey Nikitin. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class StatPresenterController: UITableViewController {

    var site: Site?
    var word: Word?
    
    var beginDate: Date?
    var endDate: Date?
    
    var ranks: [Rank] = []
    
    var result: [String: Int] = [:]
    var names: [String] = []
    
    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd0000"
        return dateFormatter
    }()
    
    let dateFormatter2: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }()
    
    let queue: OperationQueue = {
        let queue = OperationQueue()
        queue.qualityOfService = .userInteractive
        return queue
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        createTableViewHeader()
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
        
        var url = "persons/rank"
        var parameters: Parameters? = nil
        if let date1 = beginDate, let date2 = endDate {
            url = "persons/rank/date"
            parameters = [
                "_from": dateFormatter.string(from: date1),
                "_till": dateFormatter.string(from: date2)
            ]
        }
        let getServerData = GetServerDataOperation(url: url, parameters: parameters)
        getServerData.completionBlock = {
            guard let data = getServerData.data else { return }
            
            guard let json = try? JSON(data: data) else { self.jsonErrorMessage(); return }
            //print(json)
            
            self.ranks = json.compactMap({ Rank(json: $0.1) })
            
            for rank in self.ranks {
                if let site = self.site, self.word == nil {
                    if rank.siteID == site.id {
                        if let num = self.result[rank.wordName] {
                            self.result[rank.wordName] = num + rank.rank
                        } else {
                            self.result[rank.wordName] = rank.rank
                            self.names.append(rank.wordName)
                        }
                    }
                } else if self.site == nil, let word = self.word {
                    if rank.wordID == word.id {
                        if let num = self.result[rank.siteName] {
                            self.result[rank.siteName] = num + rank.rank
                        } else {
                            self.result[rank.siteName] = rank.rank
                            self.names.append(rank.siteName)
                        }
                    }
                } else if let site = self.site, let word = self.word {
                    if rank.siteID == site.id, rank.wordID == word.id {
                        
                        let strDate = rank.foundDateTime.components(separatedBy: " ")[0]
                        if let num = self.result[strDate] {
                            self.result[strDate] = num + rank.rank
                        } else {
                            self.result[strDate] = rank.rank
                            self.names.append(strDate)
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
        if names.count > 0 || self.beginDate != nil {
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

        cell.textLabel?.text = "\(indexPath.row+1). \(names[indexPath.row])"
        
        if let rank = result[names[indexPath.row]] {
            cell.detailTextLabel?.text = "\(rank)"
        }
        
        return cell
    }
    
    func createTableViewHeader() {
        if let date1 = self.beginDate, let date2 = self.endDate, let site = self.site, let word = self.word {
            let tview = UIView()
            tview.backgroundColor = appConfig.shared.backColor
            
            let paramLabel = UILabel()
            paramLabel.text = "cайт \(site.name), cлово \(word.name)"
            paramLabel.startConfigure()
            paramLabel.setColorText(fullString: paramLabel.text!, colorString1: site.name, colorString2: word.name)
            paramLabel.frame = CGRect(x: 10, y: 5, width: UIScreen.main.bounds.width-20, height: 20)
            tview.addSubview(paramLabel)
            
            let dateLabel = UILabel()
            dateLabel.text = "Период: \(dateFormatter2.string(from: date1)) — \(dateFormatter2.string(from: date2))"
            dateLabel.startConfigure()
            dateLabel.setColorText(fullString: dateLabel.text!, colorString1: dateFormatter2.string(from: date1), colorString2: dateFormatter2.string(from: date2))
            dateLabel.frame = CGRect(x: 10, y: 25, width: UIScreen.main.bounds.width-20, height: 20)
            tview.addSubview(dateLabel)
            
            tview.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50)
            self.tableView.tableHeaderView = tview
        } else if let site = self.site {
            let tview = UIView()
            tview.backgroundColor = appConfig.shared.backColor
            
            let paramLabel = UILabel()
            paramLabel.text = "cайт \(site.name)"
            paramLabel.startConfigure()
            paramLabel.setColorText(fullString: paramLabel.text!, colorString1: site.name, colorString2: "")
            paramLabel.frame = CGRect(x: 10, y: 5, width: UIScreen.main.bounds.width-20, height: 20)
            tview.addSubview(paramLabel)
            
            tview.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 30)
            self.tableView.tableHeaderView = tview
        } else if let word = self.word {
            let tview = UIView()
            tview.backgroundColor = appConfig.shared.backColor
            
            let paramLabel = UILabel()
            paramLabel.text = "cлово \(word.name)"
            paramLabel.startConfigure()
            paramLabel.setColorText(fullString: paramLabel.text!, colorString1: "", colorString2: word.name)
            paramLabel.frame = CGRect(x: 10, y: 5, width: UIScreen.main.bounds.width-20, height: 20)
            tview.addSubview(paramLabel)
            
            tview.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 30)
            self.tableView.tableHeaderView = tview
        }
    }
}

extension UILabel {
    func startConfigure() {
        self.font = UIFont(name: "Verdana", size: 13)
        self.textAlignment = .center
        self.adjustsFontSizeToFitWidth = true
        self.minimumScaleFactor = 0.5
    }
    
    func setColorText(fullString: String, colorString1: String, colorString2: String) {
        let rangeOfColoredString1 = (fullString as NSString).range(of: colorString1)
        let rangeOfColoredString2 = (fullString as NSString).range(of: colorString2)
        
        let attributedString = NSMutableAttributedString(string: fullString)
        attributedString.setAttributes([NSAttributedStringKey.foregroundColor: UIColor.blue, NSAttributedStringKey.font: UIFont(name: "Verdana-Bold", size: 13)!], range: rangeOfColoredString1)
        attributedString.addAttributes([NSAttributedStringKey.foregroundColor: UIColor.blue, NSAttributedStringKey.font: UIFont(name: "Verdana-Bold", size: 13)!], range: rangeOfColoredString2)
        
        self.attributedText = attributedString
    }
}