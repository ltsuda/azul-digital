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
    func create(email: String, password: String, completion: (String, String, String) -> ())
}

extension creatable {
    func create(email: String, password: String, completion: (String, String, String) -> ()) {
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                if let code = FIRAuthErrorCode(rawValue: (error?.code)!) {
                    switch code {
                    case .errorCodeInvalidEmail:
                        completion("Email inválido", "Favor preencher no formato usuario@provedor.com.br", "Tentar novamente")
                    case .errorCodeEmailAlreadyInUse:
                        completion("Email em uso", "Este email já está em uso, favor utilizar outro email", "Tentar novamente")
                    case .errorCodeWeakPassword:
                        completion("Senha insegura", "Favor utilizar uma senha com mais de 6 dígitos", "Tentar novamente")
                    default:
                        completion("\(code.rawValue)", "\(error?.localizedDescription)", "teste")
                    }
                }
            } else {
                completion("", "", "")
            }
        })
    }

}









