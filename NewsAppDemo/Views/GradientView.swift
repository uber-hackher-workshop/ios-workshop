//
//  GradientView.swift
//  NewsAppDemo
//
//  Created by Flannery Jefferson on 2020-11-06.
//  Copyright © 2020 Flannery Jefferson. All rights reserved.
//

import Foundation
import UIKit


@IBDesignable
class GradientView: UIView {

    @IBInspectable var firstColor: UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var secondColor: UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    }
    
    override class var layerClass: AnyClass {
       get {
          return CAGradientLayer.self
       }
    }
    
    @IBInspectable var isHorizontal: Bool = true {
       didSet {
          updateView()
       }
    }
    func updateView() {
     let layer = self.layer as! CAGradientLayer
     layer.colors = [firstColor, secondColor].map{$0.cgColor}
     if (self.isHorizontal) {
        layer.startPoint = CGPoint(x: 0, y: 0.5)
        layer.endPoint = CGPoint (x: 1, y: 0.5)
     } else {
        layer.startPoint = CGPoint(x: 0.5, y: 0)
        layer.endPoint = CGPoint (x: 0.5, y: 1)
     }
    }
    
}
