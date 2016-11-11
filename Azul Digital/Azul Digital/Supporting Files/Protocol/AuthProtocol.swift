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
    func create(_ email: String?, password: String?, completion: @escaping (String, String, String) -> ())
}

extension Creatable {
    func create(_ email: String?, password: String?, completion: @escaping (String, String, String) -> ()) {
        guard let email = email , !(email.isEmpty), let password = password, !(password.isEmpty) else {
            return completion(Project.Localizable.Common.empty.localized, Project.Localizable.Common.fill_email_pass.localized, Project.Localizable.Common.try_again.localized)
        }
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (_, error) in
            
            if error != nil {
                if let code = (error as? NSError)?.code {
                    if let firebaseCode = FIRAuthErrorCode(rawValue: (code)) {
                        switch firebaseCode {
                        case .errorCodeInvalidEmail:
                            completion("\(Project.Localizable.Common.invalid_email.localized): \(firebaseCode.rawValue)", Project.Localizable.Common.invalid_email_description.localized, Project.Localizable.Common.try_again.localized)
                        case .errorCodeEmailAlreadyInUse:
                            completion("\(Project.Localizable.Common.email_used.localized): \(firebaseCode.rawValue)", Project.Localizable.Common.email_used_description.localized, Project.Localizable.Common.try_again.localized)
                        case .errorCodeWeakPassword:
                            completion("\(Project.Localizable.Common.weak_pass.localized): \(firebaseCode.rawValue)", Project.Localizable.Common.weak_pass_description.localized, Project.Localizable.Common.try_again.localized)
                        default:
                            completion("\(Project.Localizable.Common.code.localized): \(firebaseCode.rawValue)", "\(error?.localizedDescription)", Project.Localizable.Common.ok.localized)
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
    func login(_ email: String?, password: String?, completion: @escaping (String, String, String) -> ())
}

extension Loggable {
    func login(_ email: String?, password: String?, completion: @escaping (String, String, String) -> ()) {
        guard let email = email , !(email.isEmpty), let password = password, !(password.isEmpty) else {
            return completion(Project.Localizable.Common.empty.localized, Project.Localizable.Common.fill_email_pass.localized, Project.Localizable.Common.try_again.localized)
        }
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                if let code = (error as? NSError)?.code {
                    if let firebaseCode = FIRAuthErrorCode(rawValue: (code)) {
                        switch firebaseCode {
                        case .errorCodeInvalidEmail:
                            completion("\(Project.Localizable.Common.invalid_email.localized): \(firebaseCode.rawValue)", Project.Localizable.Common.invalid_email_description.localized, Project.Localizable.Common.try_again.localized)
                        case .errorCodeOperationNotAllowed:
                            completion("\(Project.Localizable.Common.service_disabled.localized): \(firebaseCode.rawValue)", Project.Localizable.Common.service_disabled_description.localized,Project.Localizable.Common.try_again.localized)
                        case .errorCodeUserDisabled:
                            completion("\(Project.Localizable.Common.account_disabled.localized): \(firebaseCode.rawValue)", Project.Localizable.Common.service_disabled_description.localized, Project.Localizable.Common.try_again.localized)
                        case .errorCodeWrongPassword:
                            completion("\(Project.Localizable.Common.wrong_pass.localized): \(firebaseCode.rawValue)", Project.Localizable.Common.wrong_pass_description.localized, Project.Localizable.Common.try_again.localized)
                        default:
                            completion("\(Project.Localizable.Common.code.localized): \(firebaseCode.rawValue)", "\(error?.localizedDescription)", Project.Localizable.Common.ok.localized)
                            
                        }
                    }
                }
            } else {
                completion("", "", "")
            }
        })
    }
}
