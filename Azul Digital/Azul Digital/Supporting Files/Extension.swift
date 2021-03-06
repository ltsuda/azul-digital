//
//  Extension.swift
//  Azul Digital
//
//  Created by Leonardo Tsuda on 7/12/16.
//  Copyright © 2016 Leonardo Tsuda. All rights reserved.
//

import UIKit
import Foundation
import Firebase


extension UIView {
    func applyMotionEffect(magnitude: Float) {
        let xMotion = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        xMotion.minimumRelativeValue = -magnitude
        xMotion.maximumRelativeValue = magnitude
        
        let yMotion = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        yMotion.minimumRelativeValue = -magnitude
        yMotion.maximumRelativeValue = magnitude
        
        let motionGroup = UIMotionEffectGroup()
        motionGroup.motionEffects = [xMotion, yMotion]
        
        self.addMotionEffect(motionGroup)
    }
}

func formatTime(from: Date) -> (String, Date) {
    let date = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "pt-BR")
    dateFormatter.dateFormat = "dd/MM/YYYY HH:mm"
    return ((dateFormatter.string(from: date)), date)
}

extension UIButton {
    
    func configureCorner(to button: UIButton) {
        //        button.backgroundColor = UIColor(red: 15/255, green: 127/255, blue: 223/255, alpha: 1)
        button.layer.cornerRadius = 12
    }
    
}

enum PlaceHolder {
    enum User {
        static let Email = Project.Localizable.Common.email_format.localized
        static let Password = Project.Localizable.Common.password.localized
        static let FirstName = Project.Localizable.Common.first_name.localized
        static let LastName = Project.Localizable.Common.last_name.localized
    }
    
    enum Car {
        static let Brand = Project.Localizable.Common.brand.localized
        static let Model = Project.Localizable.Common.model.localized
        static let Color = Project.Localizable.Common.color.localized
        static let Plate = "CRZ0001"
    }
    
    enum Card {
        static let Number  = "4444000011113333"
        static let Funds  = "R$100,00"
    }
}

extension UIImageView {
    func configureBorder() {
        self.layer.cornerRadius = (self.frame.size.width / 2)
        self.layer.masksToBounds = true
    }
}

extension UITextField {
    
    func configureBorder(to uitextField: String) {
        let placeholder = NSAttributedString(string: uitextField, attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
        self.attributedPlaceholder = placeholder
    }
    func placeHolderText(in uitextField: String) {
        let placeholder = NSAttributedString(string: uitextField, attributes: [NSForegroundColorAttributeName: UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.5)])
        self.textColor = UIColor.black
        self.tintColor = UIColor.lightGray
        self.attributedPlaceholder = placeholder
        
    }
    
}
