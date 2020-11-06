//
//  SearchViewController.swift
//  NewsAppDemo
//
//  Created by Flannery Jefferson on 2020-11-06.
//  Copyright © 2020 Flannery Jefferson. All rights reserved.
//


import Foundation
import UIKit


class SearchViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchButton: UIButton!
    
    
    // MARK: - View Controller
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchBar()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
    
    // MARK - Navigation
    
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let feedController = segue.destination as? FeedTableViewController {
            feedController.searchQuery = searchBar.text
        }
    }
    
    // MARK: - Private
    
    private func configureSearchBar() {
        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            textField.delegate = self
            let tintColor = UIColor.systemGray
            
            textField.backgroundColor = .systemBackground
            textField.textColor = tintColor
            let glassIconView = textField.leftView as! UIImageView
            glassIconView.image = glassIconView.image?.withRenderingMode(.alwaysTemplate)
            glassIconView.tintColor = tintColor
            
            
            let clearButton = textField.value(forKey: "clearButton") as! UIButton
            clearButton.setImage(clearButton.imageView?.image?.withRenderingMode(.alwaysTemplate), for: .normal)
            clearButton.tintColor = tintColor
        }
    }
    
    // MARK: - UITextFieldDelegate
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchButton.sendActions(for: .touchUpInside)
        return true
    }
}



