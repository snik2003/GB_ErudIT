//
//  LoginViewController.swift
//  StatsSeeker
//
//  Created by Сергей Никитин on 04.06.2018.
//  Copyright © 2018 Sergey Nikitin. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    @IBOutlet weak var authButton: UIButton!
    @IBOutlet weak var restoreButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        checkActiveAuthButton()
        
        loginTextField.delegate = self
        passTextField.delegate = self
        
        loginTextField.text = appConfig.shared.appUser.login
        
        loginTextField.addTarget(self, action: #selector(checkActiveAuthButton), for: .editingChanged)
        passTextField.addTarget(self, action: #selector(checkActiveAuthButton), for: .editingChanged)
        
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
    
    @objc func checkActiveAuthButton() {
        if loginTextField.text != "", passTextField.text != "" {
            authButton.setTitleColor(appConfig.shared.textColor, for: .normal)
            authButton.isEnabled = true
        } else {
            authButton.setTitleColor(UIColor.lightGray, for: .normal)
            authButton.isEnabled = false
        }
    }
    
    @IBAction func authButtonClick(sender: UIButton) {
        self.hideKeyboard()
        
        if let login = loginTextField.text, let pass = passTextField.text {
            let auth = Auth()
            ViewControllerUtils().showActivityIndicator(uiView: self.view)
            auth.delegate = self
            auth.autorization(login,pass) { (result) in
                OperationQueue.main.addOperation {
                    if result != "" {
                        let comp = result.components(separatedBy: "_")
                        if comp.count > 1, let userID = Int(comp[0]) {
                            let token = comp[1]
                            ViewControllerUtils().hideActivityIndicator()
                            auth.getCurrentUserData(userID, token)
                        }
                    } else {
                        self.passTextField?.text = ""
                        self.checkActiveAuthButton()
                        ViewControllerUtils().hideActivityIndicator()
                        self.failedAuthMessage()
                    }
                }
            }
        }
    }
    
    @IBAction func restoreButtonClick(sender: UIButton) {
        self.hideKeyboard()
        
        self.showErrorMessage(title: "Забыли пароль?", msg: "Функция восстановления пароля доступна только в платной версии приложения.\n\nДля восстановления пароля обратитесь к Администратору системы.")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == loginTextField {
            passTextField.becomeFirstResponder()
        } else if textField == passTextField {
            if authButton.isEnabled {
                authButtonClick(sender: authButton)
            } else {
                loginTextField.becomeFirstResponder()
            }
        }
        return true
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
