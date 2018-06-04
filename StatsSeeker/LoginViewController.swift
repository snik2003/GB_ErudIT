//
//  LoginViewController.swift
//  StatsSeeker
//
//  Created by Сергей Никитин on 04.06.2018.
//  Copyright © 2018 Sergey Nikitin. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    @IBOutlet weak var authButton: UIButton!
    @IBOutlet weak var restoreButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureStartView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func configureStartView() {
        logoImageView.layer.borderWidth = 0.7
        logoImageView.layer.borderColor = UIColor.lightGray.cgColor
        logoImageView.layer.cornerRadius = 20
        logoImageView.clipsToBounds = true
        
        loginTextField.startConfigure()
        passTextField.startConfigure()
        
        authButton.startConfigure()
        restoreButton.startConfigure()
    }
}

extension UITextField {
    func startConfigure() {
        self.layer.borderWidth = 0.7
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
    }
}

extension UIButton {
    func startConfigure() {
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
    }
}
