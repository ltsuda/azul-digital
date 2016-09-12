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
//        button.backgroundColor = UIColor(red: 15/255, green: 127/255, blue: 223/255, alpha: 1)
        button.layer.cornerRadius = 12
    }
    
}

enum PlaceHolder {
    enum User {
        static let Email = "usuario@provedor.com.br"
        static let Password = "senha"
        static let FirstName = "Nome"
        static let LastName = "Sobrenome"
    }
    
    enum Car {
        static let Brand = "Chevrolet"
        static let Model = "Cruze"
        static let Color = "Preto"
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
