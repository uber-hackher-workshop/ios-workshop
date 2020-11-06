//
//  ArticleDetailViewController.swift
//  NewsAppDemo
//
//  Created by Flannery Jefferson on 2020-11-06.
//  Copyright © 2020 Flannery Jefferson. All rights reserved.
//

import Foundation
import UIKit

class ArticleDetailViewController: UIViewController {
    
    var article: NewsArticle?
    
    
    @IBOutlet weak var articleTitleLabel: UILabel!
    @IBOutlet weak var articleBodyLabel: UILabel!
    
    @IBOutlet weak var linkToFullStory: UIButton!
    
    override func viewDidLoad() {
        articleTitleLabel.text = article?.title
        articleBodyLabel.text = article?.content
        linkToFullStory.addTarget(self, action: #selector(didTapLinkToFullStory(_:)), for: .touchUpInside)
    }
    
    
    @objc func didTapLinkToFullStory(_ sender: UIButton) {
        if let urlString = article?.url, let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        } else {
            // handle invalid url error
        }
    }
}
