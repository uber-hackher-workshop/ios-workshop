//
//  ImageCache.swift
//  NewsAppDemo
//
//  Created by Flannery Jefferson on 2020-11-06.
//  Copyright © 2020 Flannery Jefferson. All rights reserved.
//

import Foundation
import UIKit

class ImageCache {
    
    private let dictionary = NSMutableDictionary(dictionary: [String: Data]())
    
    init() {}
    
    func getImageData(for key: String) -> Data? {
        return dictionary.value(forKey: key) as? Data
    }
    
    func setImageData(_ data: Data, for key: String) {
        dictionary.setValue(data, forKey: key)
    }
}
