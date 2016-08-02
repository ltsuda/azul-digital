//
//  Extension.swift
//  Azul Digital
//
//  Created by Leonardo Tsuda on 7/12/16.
//  Copyright © 2016 Leonardo Tsuda. All rights reserved.
//

import UIKit
import Foundation

extension UIButton {
    
    func configureCorner(to button: UIButton) {
        button.backgroundColor = UIColor.clear
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 10
    }
    
}


enum PlaceHolder: String {
    case email
    case password
    case firstName
    case lastName
    case brand
    case model
    case color
    case plate
    case card
    
    func fill() -> String {
        switch self {
        case .email:
            return "usuario@provedor.com.br"
        case .password:
            return "senha"
        case .firstName:
            return "Nome"
        case .lastName:
            return "Sobrenome"
        case .brand:
            return "Chevrolet"
        case .model:
            return "Cruze"
        case .color:
            return "Preto"
        case .plate:
            return "CRZ0001"
        case .card:
            return "4444000011113333"
        }
    }
    
    
}

extension UIImageView {
    func configureBorder() {
        self.layer.cornerRadius = (self.frame.size.width / 2)
        self.layer.masksToBounds = true
    }
}

extension UITextField {
    
    func configureBorder(to uitextField: () -> String) {
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.white.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        let placeholder = NSAttributedString(string: uitextField(), attributes: [NSForegroundColorAttributeName: UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5)])
        self.textColor = UIColor.white
        self.tintColor = UIColor.white
        self.attributedPlaceholder = placeholder
        self.borderStyle = .none
        self.backgroundColor = UIColor.clear
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
    func placeHolderText(in uitextField: () -> String) {
        let placeholder = NSAttributedString(string: uitextField(), attributes: [NSForegroundColorAttributeName: UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.5)])
        self.textColor = UIColor.black
        self.tintColor = UIColor.lightGray
        self.attributedPlaceholder = placeholder

    }
    
}
