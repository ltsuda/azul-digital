//
//  Protocols.swift
//  Azul Digital
//
//  Created by Leonardo Tsuda on 7/15/16.
//  Copyright © 2016 Leonardo Tsuda. All rights reserved.
//

import UIKit

protocol Alertable {
    func alert(_ title: String, message: String, actionTitle: String)
}

extension Alertable where Self: UIViewController {
    func alert(_ title: String, message: String, actionTitle: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: actionTitle, style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}


protocol CheckTextField {
    func checkEmpty(_ textfield: [String]?, completion: (String, String, String) -> ())
}
extension CheckTextField {
    func checkEmpty(_ textfield: [String]?, completion: (String, String, String) -> ()) {
        var isFilled = true
        for text in textfield! {
            if text.isEmpty {
                isFilled = false
                break
            }
        }
        if isFilled == false {
            completion("Campos vazios", "Favor preencher todos os campos", "Tentar novamente")
        } else {
            completion("", "", "")
        }
    }
}

protocol ValidatePlate {
    func validatePlate(_ plate: String) -> Bool
}

extension ValidatePlate {
    func validatePlate(_ plate: String) -> Bool {
        let regex = try! NSRegularExpression(pattern: "^[A-Za-z]{3}[0-9]{4}$", options: [.caseInsensitive])
        
        let regexResult = regex.firstMatch(in: plate, options:[], range: NSRange(location: 0, length: plate.characters.count)) != nil
        
        if !regexResult {
            return false
        }
        
        return true
    }
}

protocol ValidateCard {
    func validateCard(_ card: String) -> Bool
}

extension ValidateCard {
    func validateCard(_ card: String) -> Bool {
        let regex = try! NSRegularExpression(pattern: "^[0-9]{16}$", options: [.caseInsensitive])
        
        let regexResult = regex.firstMatch(in: card, options:[], range: NSRange(location: 0, length: card.characters.count)) != nil
        
        if !regexResult {
            return false
        }
        
        return true
    }
}

//protocol ValidateFunds {
//    func validatefunds(_ funds: String) -> Bool
//}
//
//extension ValidateFunds {
//    func validatefunds(_ funds: String) -> Bool {
//        let regex = try! NSRegularExpression(pattern: "^\\d{1,}(\\,{1})\\d{2}$", options: [.anchorsMatchLines])
//
//        let regexResult = regex.firstMatch(in: funds, options:[], range: NSRange(location: 0, length: funds.characters.count)) != nil
//
//        if !regexResult {
//            return false
//        }
//
//        return true
//    }
//}

func roundTwoDecimal(_ number: String) -> Double? {
    let format = NumberFormatter()
    format.numberStyle = .currency
    format.currencySymbol = ""
    format.alwaysShowsDecimalSeparator = true
    format.minimumFractionDigits = 2
    format.maximumFractionDigits = 2
    format.locale = Locale.current
    return format.number(from: number)?.doubleValue
}
