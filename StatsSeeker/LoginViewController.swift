//
//  LoginViewController.swift
//  StatsSeeker
//
//  Created by Сергей Никитин on 04.06.2018.
//  Copyright © 2018 Sergey Nikitin. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    @IBOutlet weak var authButton: UIButton!
    @IBOutlet weak var restoreButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let hideKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard))
        self.scrollView?.addGestureRecognizer(hideKeyboardGesture)
        
        configureStartView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShown(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
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
    
    @objc func keyboardWasShown(notification: Notification) {
        
        if let info = notification.userInfo as NSDictionary?, let kbSize = (info.value(forKey: UIKeyboardFrameEndUserInfoKey) as? NSValue)?.cgRectValue.size {
            
            let contentInsets = UIEdgeInsetsMake(0, 0, kbSize.height, 0)
            self.scrollView?.contentInset = contentInsets
            self.scrollView?.scrollIndicatorInsets = contentInsets
            
            if let maxY = self.scrollView?.contentSize.height {
                self.scrollView?.scrollRectToVisible(CGRect(x: 0, y: maxY, width: 1, height: 1), animated: true)
            }
        }
    }
    
    @objc func keyboardWillBeHidden(notification: Notification) {
        
        let contentInsets = UIEdgeInsets.zero
        self.scrollView?.contentInset = contentInsets
        self.scrollView?.scrollIndicatorInsets = contentInsets
    }
    
    @objc func hideKeyboard() {
        self.scrollView?.endEditing(true)
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
