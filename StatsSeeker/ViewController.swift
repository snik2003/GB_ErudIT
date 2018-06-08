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
        
        if Auth().getDefaults() {
            performSegue(withIdentifier: "goTabBar", sender: self)
        } else {
            performSegue(withIdentifier: "goLoginForm", sender: self)
        }
    }
}

