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

func formatTime(from: Date) -> String {
    let date = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "pt-BR")
    dateFormatter.dateFormat = "dd/MM/YYYY HH:mm"
    return (dateFormatter.string(from: date))
}


func getFIRServerTime(completion: @escaping (Any)->()) {
    //        rootFBReference.observeSingleEvent(of: .value, with: { snapshot in
    //
    //            guard let time = snapshot.value as? TimeInterval else { return }
    //            print(time)
    //            let serverTime = Date(timeIntervalSince1970: time)
    //            completion(serverTime)
    //
    //        }) { error in
    //            completion(error)
    //        }
}

extension UIButton {
    
    func configureCorner(to button: UIButton) {
        //        button.backgroundColor = UIColor(red: 15/255, green: 127/255, blue: 223/255, alpha: 1)
        button.layer.cornerRadius = 12
    }
    
}

enum PlaceHolder {
    enum User {
        static let Email = NSLocalizedString("Email-provider", comment: "email-address")
        static let Password = NSLocalizedString("Password", comment: "user-password")
        static let FirstName = NSLocalizedString("First", comment: "user-firstName")
        static let LastName = NSLocalizedString("Last", comment: "user-lastName")
    }
    
    enum Car {
        static let Brand = NSLocalizedString("Brand", comment: "car-brand")
        static let Model = NSLocalizedString("Model", comment: "model-brand")
        static let Color = NSLocalizedString("Color", comment: "color-brand")
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
