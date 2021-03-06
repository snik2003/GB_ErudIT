//
//  OptionsController.swift
//  StatsSeeker
//
//  Created by Сергей Никитин on 09.06.2018.
//  Copyright © 2018 Sergey Nikitin. All rights reserved.
//

import UIKit

class OptionsController: UIViewController {

    @IBOutlet weak var restSwitch: UISwitch!
    @IBOutlet weak var soapSwitch: UISwitch!
    @IBOutlet weak var hashSwitch: UISwitch!
    
    @IBOutlet weak var urlTextField: UITextField!
    var webs: [UISwitch] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        webs.append(restSwitch)
        webs.append(soapSwitch)
        
        urlTextField.startConfigure()
        urlTextField.text = appConfig.shared.apiURL
        
        hashSwitch.isOn = appConfig.shared.realmOn
        
        let hideKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard))
        self.view.addGestureRecognizer(hideKeyboardGesture)
        
        let saveButton = UIBarButtonItem(title: "Готово", style: .done, target: self, action: #selector(self.tapSaveButton(sender:)))
        self.navigationItem.rightBarButtonItem = saveButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func switchClick(sender: UISwitch) {
        hideKeyboard()
        webs.forEach { $0.isOn = false }
        sender.isOn = true
    }
    
    @IBAction func hashSwitchClick(sender: UISwitch) {
        hideKeyboard()
    }
    
    @objc func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    @objc func tapSaveButton(sender: UIBarButtonItem) {
        
        if let text = urlTextField.text {
            appConfig.shared.apiURL = text
        }
        appConfig.shared.realmOn = hashSwitch.isOn
        
        saveAppConfig()
        getSitesList()
        getWordsList()
        self.navigationController?.popViewController(animated: true)
    }
}
