//
//  Protocols.swift
//  Azul Digital
//
//  Created by Leonardo Tsuda on 7/15/16.
//  Copyright © 2016 Leonardo Tsuda. All rights reserved.
//

import FirebaseAuth
import UIKit

protocol alertable {
    func alert(title: String, message: String, actionTitle: String)
}

extension alertable where Self: UIViewController {
    func alert(title: String, message: String, actionTitle: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: actionTitle, style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

protocol creatable {
    func create(email: String?, password: String?, completion: (String, String, String) -> ())
}

extension creatable {
    func create(email: String?, password: String?, completion: (String, String, String) -> ()) {
        guard let email = email , !(email.isEmpty), let password = password, !(password.isEmpty) else {
            return completion("Campos vazios", "Favor preencher os campos Email e Senha", "Tentar novamente")
        }
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                if let code = FIRAuthErrorCode(rawValue: (error?.code)!) {
                    switch code {
                    case .errorCodeInvalidEmail:
                        completion("Email inválido: \(code.rawValue)", "Favor preencher no formato usuario@provedor.com.br", "Tentar novamente")
                    case .errorCodeEmailAlreadyInUse:
                        completion("Email em uso: \(code.rawValue)", "Este email já está em uso, favor utilizar outro email", "Tentar novamente")
                    case .errorCodeWeakPassword:
                        completion("Senha insegura: \(code.rawValue)", "Favor utilizar uma senha com mais de 6 dígitos", "Tentar novamente")
                    default:
                        completion("Código: \(code.rawValue)", "\(error?.localizedDescription)", "OK")
                    }
                }
            } else {
                completion("", "", "")
            }
        })
    }
}

protocol loggable {
    func login(email: String?, password: String?, completion: (String, String, String) -> ())
}

extension loggable {
    func login(email: String?, password: String?, completion: (String, String, String) -> ()) {
        guard let email = email , !(email.isEmpty), let password = password, !(password.isEmpty) else {
            return completion("Campos vazios", "Favor preencher os campos Email e Senha", "Tentar novamente")
        }
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                if let code = FIRAuthErrorCode(rawValue: (error?.code)!) {
                    switch code {
                    case .errorCodeInvalidEmail:
                        completion("Email inválido: \(code.rawValue)", "Favor preencher no formato usuario@provedor.com.br", "Tentar novamente")
                    case .errorCodeOperationNotAllowed:
                        completion("Serviço desabilitado: \(code.rawValue)", "Favor entrar em contato com o desenvolvedor", "Tentar novamente")
                    case .errorCodeUserDisabled:
                        completion("Conta desabilitada: \(code.rawValue)", "Favor entrar em contato com o desenvolvedor", "Tentar novamente")
                    case .errorCodeWrongPassword:
                        completion("Senha incorreta: \(code.rawValue)", "Favor verifique sua senha", "Tentar novamente")
                    default:
                        completion("Código: \(code.rawValue)", "\(error?.localizedDescription)", "OK")
                    }
                }
            } else {
                completion("", "", "")
            }
        })
    }
}

protocol CheckTextField {
    func checkEmpty(textfield: [String]?, completion: (String, String, String) -> ())
}
extension CheckTextField {
    func checkEmpty(textfield: [String]?, completion: (String, String, String) -> ()) {
        var isFilled = true
        for text in textfield! {
            if text.isEmpty {
                isFilled = false
                break
            }
        }
        if isFilled == false {
            completion("Campos vazios", "Favor preencher os campos Nome e Sobrenome", "Tentar novamente")
        } else {
            completion("", "", "")
        }
    }
}

protocol ValidatePlate {
    func validatePlate(plate: String) -> Bool
}

extension ValidatePlate {
    func validatePlate(plate: String) -> Bool {
        let regex = try! RegularExpression(pattern: "^[A-Za-z]{3}[0-9]{4}$", options: [.caseInsensitive])
        
        let regexResult = regex.firstMatch(in: plate, options:[], range: NSRange(location: 0, length: plate.characters.count)) != nil
        
        if !regexResult {
            return false
        }
        
        return true
    }
}

protocol ValidateCard {
    func validateCard(card: String) -> Bool
}

extension ValidateCard {
    func validateCard(card: String) -> Bool {
        let regex = try! RegularExpression(pattern: "^[0-9]{16}$", options: [.caseInsensitive])
        
        let regexResult = regex.firstMatch(in: card, options:[], range: NSRange(location: 0, length: card.characters.count)) != nil
        
        if !regexResult {
            return false
        }
        
        return true
    }
}









