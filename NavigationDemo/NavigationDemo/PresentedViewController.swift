//
//  PresentedViewController.swift
//  NavigationDemo
//
//  Created by Flannery Jefferson on 2020-10-09.
//  Copyright © 2020 Flannery Jefferson. All rights reserved.
//

import UIKit

class PresentedViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Presented Controller"
    }
    
    @IBAction func closeButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}
