//
//  RegisterTextField.swift
//  Azul Digital
//
//  Created by Leonardo Tsuda on 11/09/16.
//  Copyright © 2016 Leonardo Tsuda. All rights reserved.
//

import UIKit

@IBDesignable
class RegisterTextField: UITextField {

    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.borderColor = UIColor(white: 228/255, alpha: 1).cgColor
        self.layer.borderWidth = 1
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 8, dy: 7)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
}
