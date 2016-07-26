//
//  Gradient.swift
//  Azul Digital
//
//  Created by Leonardo Tsuda on 7/11/16.
//  Copyright © 2016 Leonardo Tsuda. All rights reserved.
//

import Foundation
import UIKit


extension UIView {
    
    func gradientBackbround(to view: UIView) {
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [getRGB(red: 79.0, green: 249.0, blue: 215.0), getRGB(red: 15.0, green: 127.0, blue: 223.0)]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 0, y: 1)
        view.layer.insertSublayer(gradient, at: 0)
        
    }
    
    func getRGB(red: CGFloat, green: CGFloat, blue: CGFloat) -> CGColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1.0).cgColor
    }
    
}
