//
//  AuthProtocol.swift
//  Azul Digital
//
//  Created by Leonardo Tsuda on 7/25/16.
//  Copyright © 2016 Leonardo Tsuda. All rights reserved.
//

import Foundation
import FirebaseAuth

protocol Creatable {
    func create(email: String?, password: String?, completion: (String, String, String) -> ())
}

extension Creatable {
    func create(email: String?, password: String?, completion: (String, String, String) -> ()) {
        guard let email = email , !(email.isEmpty), let password = password, !(password.isEmpty) else {
            return completion("Campos vazios", "Favor preencher os campos Email e Senha", "Tentar novamente")
        }
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (_, error) in
            
            if error != nil {
                if let code = (error as? NSError)?.code {
                    if let firebaseCode = FIRAuthErrorCode(rawValue: (code)) {
                        switch firebaseCode {
                        case .errorCodeInvalidEmail:
                            completion("Email inválido: \(firebaseCode.rawValue)", "Favor preencher no formato usuario@provedor.com.br", "Tentar novamente")
                        case .errorCodeEmailAlreadyInUse:
                            completion("Email em uso: \(firebaseCode.rawValue)", "Este email já está em uso, favor utilizar outro email", "Tentar novamente")
                        case .errorCodeWeakPassword:
                            completion("Senha insegura: \(firebaseCode.rawValue)", "Favor utilizar uma senha com mais de 6 dígitos", "Tentar novamente")
                        default:
                            completion("Código: \(firebaseCode.rawValue)", "\(error?.localizedDescription)", "OK")
                        }
                    }
                }
                
            } else {
                completion("", "", "")
            }
        })
        
    }
}

protocol Loggable {
    func login(email: String?, password: String?, completion: (String, String, String) -> ())
}

extension Loggable {
    func login(email: String?, password: String?, completion: (String, String, String) -> ()) {
        guard let email = email , !(email.isEmpty), let password = password, !(password.isEmpty) else {
            return completion("Campos vazios", "Favor preencher os campos Email e Senha", "Tentar novamente")
        }
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                if let code = (error as? NSError)?.code {
                    if let firebaseCode = FIRAuthErrorCode(rawValue: (code)) {
                        switch firebaseCode {
                        case .errorCodeInvalidEmail:
                            completion("Email inválido: \(firebaseCode.rawValue)", "Favor preencher no formato usuario@provedor.com.br", "Tentar novamente")
                        case .errorCodeOperationNotAllowed:
                            completion("Serviço desabilitado: \(firebaseCode.rawValue)", "Favor entrar em contato com o desenvolvedor", "Tentar novamente")
                        case .errorCodeUserDisabled:
                            completion("Conta desabilitada: \(firebaseCode.rawValue)", "Favor entrar em contato com o desenvolvedor", "Tentar novamente")
                        case .errorCodeWrongPassword:
                            completion("Senha incorreta: \(firebaseCode.rawValue)", "Favor verifique sua senha", "Tentar novamente")
                        default:
                            completion("Código: \(firebaseCode.rawValue)", "\(error?.localizedDescription)", "OK")
                            
                        }
                    } else {
                        completion("", "", "")
                    }
                }
            }
        })
    }
}
