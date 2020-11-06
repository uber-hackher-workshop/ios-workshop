//
//  FeedItemTableViewCell.swift
//  NewsAppDemo
//
//  Created by Flannery Jefferson on 2020-11-06.
//  Copyright © 2020 Flannery Jefferson. All rights reserved.
//

import UIKit

class FeedItemTableViewCell: UITableViewCell {
    
    var imageCache: ImageCache?
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var coverImageView: UIImageView!
    
    @IBOutlet weak var articleTitleLabel: UILabel!
    
    @IBOutlet weak var articleBodyLabel: UILabel!
    
    
    private var currentCoverURLString: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cardView.layer.cornerRadius = 8
        cardView.clipsToBounds = true
        cardView.layer.masksToBounds = true
        articleTitleLabel.numberOfLines = 0
        articleBodyLabel.numberOfLines = 0
    }
    
    func configure(forArticle article: NewsArticle) {
        articleTitleLabel.text = article.title
        articleBodyLabel.text = article.content
        
        if let urlString = article.urlToImage {
            downloadImage(from: urlString)
        } else {
            setPlaceholderImage()
            currentCoverURLString = nil
        }
    }
    
    private func downloadImage(from urlString: String) {
        if let imageData = imageCache?.getImageData(for: urlString) {
            coverImageView.image = UIImage(data: imageData)
            return
        }

        guard let url = URL(string: urlString) else {
            setPlaceholderImage()
            return
        }
        
        coverImageView.image = nil

        getData(from: url) { data, response, error in
            DispatchQueue.main.async() { [weak self] in
                
                guard let data = data, error == nil else {
                    self?.setPlaceholderImage()
                    return
                }
                
                self?.imageCache?.setImageData(data, for: urlString)
                self?.coverImageView.image = UIImage(data: data)
            }
        }
    }
    
    private func setPlaceholderImage() {
        self.coverImageView.image = UIImage(named: "placeholder")
    }
    
    private func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
}
extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
