//
//  DailyStatController.swift
//  StatsSeeker
//
//  Created by Сергей Никитин on 06.06.2018.
//  Copyright © 2018 Sergey Nikitin. All rights reserved.
//

import UIKit
import SwiftyJSON
import DropDown

class DailyStatController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var siteTextField: UITextField!
    var siteDrop = DropDown()
    var siteIndex = 0
    var sitePicker: [String] = []
    var sites: [Site] = []
    
    @IBOutlet weak var wordTextField: UITextField!
    var wordDrop = DropDown()
    var wordIndex = 0
    var wordPicker: [String] = []
    var words: [Word] = []
    
    @IBOutlet weak var beginDateTextField: UITextField!
    @IBOutlet weak var endDateTextField: UITextField!
    @IBOutlet weak var datePicker1: UIDatePicker!
    @IBOutlet weak var datePicker2: UIDatePicker!
    
    @IBOutlet weak var statButton: UIButton!
    
    let dateFormatter: DateFormatter = {
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

        siteTextField.startConfigure()
        wordTextField.startConfigure()
        beginDateTextField.startConfigure()
        endDateTextField.startConfigure()
        statButton.startConfigure()
        
        getObjectList(url: "sites")
        getObjectList(url: "persons")
        
        let selectSiteTap = UITapGestureRecognizer(target: self, action: #selector(self.selectSite))
        siteTextField.addGestureRecognizer(selectSiteTap)
        
        siteDrop.anchorView = siteTextField
        siteDrop.startConfigure()
        
        siteDrop.selectionAction = { [unowned self] (index: Int, item: String) in
            self.siteIndex = index
            self.siteTextField.text = item
            self.siteDrop.hide()
            self.checkActiveStatButton()
        }
        
        let selectWordTap = UITapGestureRecognizer(target: self, action: #selector(self.selectWord))
        wordTextField.addGestureRecognizer(selectWordTap)
        
        wordDrop.anchorView = wordTextField
        wordDrop.startConfigure()
        
        wordDrop.selectionAction = { [unowned self] (index: Int, item: String) in
            self.wordIndex = index
            self.wordTextField.text = item
            self.wordDrop.hide()
            self.checkActiveStatButton()
        }

        beginDateTextField.delegate = self
        endDateTextField.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard))
        self.view.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func hideKeyboard() {
        hideDatePickers()
        self.view.endEditing(true)
    }
    
    @objc func selectSite() {
        hideDatePickers()
        
        if sitePicker.count > 0 {
            view.endEditing(true)
            siteDrop.selectRow(siteIndex)
            siteDrop.show()
        } else {
            siteTextField.endEditing(true)
            self.showErrorMessage(title: "Приложение \(appConfig.shared.appName)", msg: "Ошибка! В базе данных отсутствует информация по данному виду статистики.")
        }
    }
    
    @objc func selectWord() {
        hideDatePickers()
        
        if wordPicker.count > 0 {
            view.endEditing(true)
            wordDrop.selectRow(wordIndex)
            wordDrop.show()
        } else {
            wordTextField.endEditing(true)
            self.showErrorMessage(title: "Приложение \(appConfig.shared.appName)", msg: "Ошибка! В базе данных отсутствует информация по данному виду статистики.")
        }
    }
    
    func getObjectList(url: String) {
        
        let getServerData = GetServerDataOperation(url: url, parameters: nil, method: .get)
        getServerData.completionBlock = {
            guard let data = getServerData.data else { return }
            
            guard let json = try? JSON(data: data) else { return }
            //print(json)
            
            OperationQueue.main.addOperation {
                if url == "sites" {
                    self.sites = json.compactMap { Site(json: $0.1) }
                    
                    for site in self.sites {
                        if site.addedBy != appConfig.shared.appUser.addedBy {
                            self.sites.delete(element: site)
                        }
                    }
                    
                    for site in self.sites {
                        self.sitePicker.append(site.name)
                    }
                    self.siteDrop.dataSource = self.sitePicker
                } else if url == "persons" {
                    self.words = json.compactMap { Word(json: $0.1) }
                    
                    for word in self.words {
                        if word.addedBy != appConfig.shared.appUser.addedBy {
                            self.words.delete(element: word)
                        }
                    }
                    
                    for word in self.words {
                        self.wordPicker.append(word.name)
                    }
                    self.wordDrop.dataSource = self.wordPicker
                }
            }
        }
        queue.addOperation(getServerData)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        view.endEditing(true)
        hideDatePickers()
        
        if textField == beginDateTextField {
            datePicker1.startConfigure()
            
            if let text = textField.text, let date = dateFormatter.date(from: text) {
                datePicker1.date = date
            } else {
                datePicker1.date = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
            }
            textField.text = dateFormatter.string(from: datePicker1.date)
            textField.inputView = datePicker1
            
            datePicker1.addTarget(self, action: #selector(beginDatePickerValueChanged), for: .valueChanged)
            checkActiveStatButton()
            
        } else if textField == endDateTextField {
            datePicker2.startConfigure()
            
            if let text = textField.text, let date = dateFormatter.date(from: text) {
                datePicker2.date = date
            } else {
                datePicker2.date = Date()
            }
            textField.text = dateFormatter.string(from: datePicker2.date)
            textField.inputView = datePicker2
            
            datePicker2.addTarget(self, action: #selector(endDatePickerValueChanged), for: .valueChanged)
            checkActiveStatButton()
            
        }
    }
    
    @objc func beginDatePickerValueChanged(sender: UIDatePicker) {
        beginDateTextField.text = dateFormatter.string(from: sender.date)
        checkActiveStatButton()
    }

    @objc func endDatePickerValueChanged(sender: UIDatePicker) {
        endDateTextField.text = dateFormatter.string(from: sender.date)
        checkActiveStatButton()
    }
    
    func hideDatePickers() {
        datePicker1.isHidden = true
        datePicker2.isHidden = true
    }
    
    func checkActiveStatButton() {
        
        if let date1 = dateFormatter.date(from: beginDateTextField.text!), let date2 = dateFormatter.date(from: endDateTextField.text!), siteTextField.text != "", wordTextField.text != "" {
            
            if date1 <= date2 {
                statButton.setTitleColor(appConfig.shared.textColor, for: .normal)
                statButton.isEnabled = true
            } else {
                statButton.setTitleColor(UIColor.lightGray, for: .normal)
                statButton.isEnabled = false
                self.showErrorMessage(title: "Ежедневная статистика", msg: "Ошибка! Начальная дата должна быть меньше конечной.")
            }
        } else {
            
            statButton.setTitleColor(UIColor.lightGray, for: .normal)
            statButton.isEnabled = false
        }
    }
    
    @IBAction func tapStatButton(sender: UIButton) {
        hideKeyboard()
        
        if let date1 = dateFormatter.date(from: beginDateTextField.text!), let date2 = dateFormatter.date(from: endDateTextField.text!) {
            let controller = storyboard?.instantiateViewController(withIdentifier: "StatPresenterController") as! StatPresenterController
            
            controller.site = sites[siteIndex]
            controller.word = words[wordIndex]
            
            controller.beginDate = date1
            controller.endDate = date2
            controller.title = "Ежедневная статистика"
            
            self.navigationController?.pushViewController(controller, animated: true)
        } else {
            self.showErrorMessage(title: "Ежедневная статистика", msg: "Ошибка! Неверный формат начальных значений дат.")
        }
    }
}

extension DropDown {
    func startConfigure() {
        self.textColor = UIColor.black
        self.textFont = UIFont(name: "Verdana", size: 11)!
        self.backgroundColor = UIColor.white
        self.selectionBackgroundColor = appConfig.shared.backColor.withAlphaComponent(0.5)
        self.cellHeight = 30
    }
}

extension UIDatePicker {
    func startConfigure() {
        self.datePickerMode = .date
        self.locale = NSLocale(localeIdentifier: "ru_RU") as Locale?
        self.backgroundColor = appConfig.shared.backColor
        self.isHidden = false
    }
}

