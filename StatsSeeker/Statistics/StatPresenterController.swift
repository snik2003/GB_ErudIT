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
    
    var descriptionLabel = ""
    
    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd000000"
        return dateFormatter
    }()
    
    let dateFormatter2: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }()
    
    let dateFormatter3: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, dd MMMM yyyy HH:mm:ss zzz"
        return dateFormatter
    }()
    
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
        
        var url = "persons/rank"
        var parameters: Parameters? = nil
        
        if let date1 = beginDate, let date2 = endDate, let word = self.word {
            url = "persons/rank/\(word.id)/date"
            parameters = [
                "_from": dateFormatter.string(from: date1),
                "_till": dateFormatter.string(from: date2)
            ]
        }
        
        let getServerData = GetServerDataOperation(url: url, parameters: parameters, method: .get)
        getServerData.completionBlock = {
            guard let data = getServerData.data else { return }
            
            guard let json = try? JSON(data: data) else { self.jsonErrorMessage(); return }
            //print(json)
            
            self.ranks = json.compactMap({ Rank(json: $0.1) })
            
            for rank in self.ranks {
                if let site = self.site, self.word == nil {
                    if let wordName = appConfig.shared.words.filter({ $0.id == rank.wordID }).first?.name {
                        //if rank.siteID == site.id {
                            if let num = self.result[wordName] {
                                self.result[wordName] = num + rank.rank
                            } else {
                                self.result[wordName] = rank.rank
                                self.names.append(wordName)
                            }
                        //}
                    }
                } else if self.site == nil, let word = self.word {
                    if let siteName = appConfig.shared.sites.filter({ $0.id == 1 /*rank.siteID*/ }).first?.name {
                        if rank.wordID == word.id {
                            if let num = self.result[siteName] {
                                self.result[siteName] = num + rank.rank
                            } else {
                                self.result[siteName] = rank.rank
                                self.names.append(siteName)
                            }
                        }
                    }
                } else if let site = self.site, let word = self.word {
                    if rank.pageID == site.id, rank.personID == word.id, rank.siteAddBy == site.addedBy, rank.wordAddBy == word.addedBy {
                        
                        if let date = self.dateFormatter3.date(from: rank.foundDate) {
                            
                            let strDate = self.dateFormatter2.string(from: date)
                            if let num = self.result[strDate] {
                                self.result[strDate] = num + rank.rank
                            } else {
                                self.result[strDate] = rank.rank
                                self.names.append(strDate)
                            }
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
                    
                    let barButton = UIBarButtonItem(image: UIImage(named: "chart_button"), style: .plain, target: self, action: #selector(self.tapBarButtonItem(sender:)))
                    self.navigationItem.rightBarButtonItem = barButton
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
        
        if self.beginDate != nil, self.endDate != nil, self.site != nil, self.word != nil {
            
            return 55
        } else if self.site != nil {
            
            return 35
            
        } else if self.word != nil {
            return 35
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
        
        return createSectionHeader()
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
    
    func createSectionHeader() -> UIView {
        if let date1 = self.beginDate, let date2 = self.endDate, let site = self.site, let word = self.word {
            let tview = UIView()
            tview.backgroundColor = appConfig.shared.tintColor.withAlphaComponent(0.95)
            
            let paramLabel = UILabel()
            paramLabel.text = "cайт \(site.name), cлово \(word.name)"
            descriptionLabel = "cайт «\(site.name)», cлово «\(word.name)»"
            paramLabel.startConfigure()
            paramLabel.setColorText(fullString: paramLabel.text!, colorString1: site.name, colorString2: word.name, color: appConfig.shared.textColor)
            paramLabel.frame = CGRect(x: 10, y: 5, width: UIScreen.main.bounds.width-20, height: 20)
            tview.addSubview(paramLabel)
            
            let dateLabel = UILabel()
            dateLabel.text = "Период: \(dateFormatter2.string(from: date1)) — \(dateFormatter2.string(from: date2))"
            dateLabel.startConfigure()
            dateLabel.setColorText(fullString: dateLabel.text!, colorString1: dateFormatter2.string(from: date1), colorString2: dateFormatter2.string(from: date2), color: UIColor.orange)
            dateLabel.frame = CGRect(x: 10, y: 25, width: UIScreen.main.bounds.width-20, height: 20)
            tview.addSubview(dateLabel)
            
            let dopView = UIView()
            dopView.backgroundColor = UIColor.white
            dopView.frame = CGRect(x: 0, y: 50, width: UIScreen.main.bounds.width, height: 5)
            tview.addSubview(dopView)
            
            tview.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 55)
            return tview
        } else if let site = self.site {
            
            let tview = UIView()
            tview.backgroundColor = appConfig.shared.tintColor.withAlphaComponent(0.95)
            
            let paramLabel = UILabel()
            paramLabel.text = "cайт \(site.name)"
            descriptionLabel = "cайт «\(site.name)»"
            paramLabel.startConfigure()
            paramLabel.setColorText(fullString: paramLabel.text!, colorString1: site.name, colorString2: "", color: appConfig.shared.textColor)
            paramLabel.frame = CGRect(x: 10, y: 5, width: UIScreen.main.bounds.width-20, height: 20)
            tview.addSubview(paramLabel)
            
            let dopView = UIView()
            dopView.backgroundColor = UIColor.white
            dopView.frame = CGRect(x: 0, y: 30, width: UIScreen.main.bounds.width, height: 5)
            tview.addSubview(dopView)
            
            tview.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 35)
            return tview
            
        } else if let word = self.word {
            let tview = UIView()
            tview.backgroundColor = appConfig.shared.tintColor.withAlphaComponent(0.95)
            
            let paramLabel = UILabel()
            paramLabel.text = "cлово \(word.name)"
            descriptionLabel = "cлово «\(word.name)»"
            paramLabel.startConfigure()
            paramLabel.setColorText(fullString: paramLabel.text!, colorString1: "", colorString2: word.name, color: appConfig.shared.textColor)
            paramLabel.frame = CGRect(x: 10, y: 5, width: UIScreen.main.bounds.width-20, height: 20)
            tview.addSubview(paramLabel)
            
            let dopView = UIView()
            dopView.backgroundColor = UIColor.white
            dopView.frame = CGRect(x: 0, y: 30, width: UIScreen.main.bounds.width, height: 5)
            tview.addSubview(dopView)
            
            tview.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 35)
            return tview
        }
        
        let tview = UIView()
        tview.backgroundColor = UIColor.white
        
        return tview
    }
    
    @objc func tapBarButtonItem(sender: UIBarButtonItem) {
        if let title = self.title {
            self.openChartController(data: result, names: names, description: descriptionLabel, title: title)
        }
    }
}

extension UILabel {
    func startConfigure() {
        self.font = UIFont(name: "Verdana-Bold", size: 13)
        self.textColor = UIColor.white
        self.textAlignment = .center
        self.adjustsFontSizeToFitWidth = true
        self.minimumScaleFactor = 0.5
    }
    
    func setColorText(fullString: String, colorString1: String, colorString2: String, color: UIColor) {
        let rangeOfColoredString1 = (fullString as NSString).range(of: colorString1)
        let rangeOfColoredString2 = (fullString as NSString).range(of: colorString2)
        
        let attributedString = NSMutableAttributedString(string: fullString)
        attributedString.setAttributes([NSAttributedStringKey.foregroundColor: color, NSAttributedStringKey.font: UIFont(name: "Verdana-Bold", size: 13)!], range: rangeOfColoredString1)
        attributedString.addAttributes([NSAttributedStringKey.foregroundColor: color, NSAttributedStringKey.font: UIFont(name: "Verdana-Bold", size: 13)!], range: rangeOfColoredString2)
        
        self.attributedText = attributedString
    }
}
