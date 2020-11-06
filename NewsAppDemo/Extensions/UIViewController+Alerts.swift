//
//  UIViewController+Alerts.swift
//  NewsAppDemo
//
//  Created by Flannery Jefferson on 2020-11-06.
//  Copyright © 2020 Flannery Jefferson. All rights reserved.
//

import Foundation
import UIKit


extension UIViewController {
    
    func showErrorAlert(title: String? = "Something went wrong", message: String?) {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
            controller.dismiss(animated: true, completion: nil)
        })
        controller.addAction(okAction)
        present(controller, animated: true, completion: nil)
    }
}
