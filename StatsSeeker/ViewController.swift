//
//  ViewController.swift
//  StatsSeeker
//
//  Created by Сергей Никитин on 03.06.2018.
//  Copyright © 2018 Sergey Nikitin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        ViewControllerUtils().showActivityIndicator(uiView: self.view)
        let auth = Auth()
        auth.delegate = self
        auth.getDefaults()
    }
}

