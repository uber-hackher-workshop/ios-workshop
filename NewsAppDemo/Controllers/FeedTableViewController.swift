//
//  FeedTableViewController.swift
//  NewsAppDemo
//
//  Created by Flannery Jefferson on 2020-11-06.
//  Copyright © 2020 Flannery Jefferson. All rights reserved.
//

import UIKit

class FeedTableViewController: UITableViewController {

    var searchQuery: String?
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    private let apiClient = NewsAPIClient()
    private var articles: [NewsArticle] = []
    private let imageCache = ImageCache()
    private var debounceTimer: Timer?
    
    private var loadingImageView: UIImageView = {
        let gif = UIImage.gifImageWithName("blocks")
        let imageView = UIImageView(image: gif)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let query = searchQuery, !query.isEmpty {
            navigationItem.title = "Results for '\(query)'"
        } else {
            navigationItem.title = "News Feed"
        }
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refreshTableData(_:)), for: .valueChanged)
                
        setupSubviews()
        setupConstraints()
        updateTableData()
    }
    
    private func setupSubviews() {
        view.addSubview(loadingImageView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            loadingImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            loadingImageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            loadingImageView.widthAnchor.constraint(equalToConstant: 180),
            loadingImageView.heightAnchor.constraint(equalTo: loadingImageView.widthAnchor)
        ])
    }
    
    
    private func updateTableData() {
        let debounceInterval = DispatchTime.now() + 1.5
        loadingImageView.isHidden = false
        articles = []
        tableView.reloadData()
        
        apiClient.fetchArticles(query: searchQuery, completion: { articles, error in
            DispatchQueue.main.asyncAfter(deadline: debounceInterval) { [weak self] in
                self?.loadingImageView.isHidden = true
                self?.refreshControl?.endRefreshing()
                if let articles = articles {
                    self?.articles = articles
                    self?.tableView.reloadData()
                } else if let e = error {
                    self?.showErrorAlert(message: e.userMessage)
                }
            }
        })
    }
    
    @objc func refreshTableData(_: UIRefreshControl) {
        updateTableData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedItemCell", for: indexPath) as! FeedItemTableViewCell
        let article = articles[indexPath.row]
        cell.imageCache = imageCache
        cell.configure(forArticle: article)
        return cell
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailController = segue.destination as? ArticleDetailViewController,
            let selectedIndexPath = tableView.indexPathForSelectedRow {
            detailController.article = articles[selectedIndexPath.row]
        }
    }

}

// Code to make sure that our loader is on-screen for a minimum amount of time (interval)
func debounce(interval: Int, queue: DispatchQueue, action: @escaping (() -> Void)) -> () -> Void {
    var lastFireTime = DispatchTime.now()
    let dispatchDelay = DispatchTimeInterval.milliseconds(interval)

    return {
        lastFireTime = DispatchTime.now()
        let dispatchTime: DispatchTime = DispatchTime.now() + dispatchDelay

        queue.asyncAfter(deadline: dispatchTime) {
            let when: DispatchTime = lastFireTime + dispatchDelay
            let now = DispatchTime.now()
            if now.rawValue >= when.rawValue {
                action()
            }
        }
    }
}
