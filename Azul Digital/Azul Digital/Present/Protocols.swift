//
//  Protocols.swift
//  Azul Digital
//
//  Created by Leonardo Tsuda on 7/15/16.
//  Copyright © 2016 Leonardo Tsuda. All rights reserved.
//

import Firebase
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
    func create(email: String, password: String) -> (String, String, String)
}

extension creatable {
    func create(email: String, password: String) -> (String, String, String) {
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user: FIRUser?, error: NSError?) in
            if error != nil {
                
            } else {
                
            }
            
        })
        
        
        
        
        
        return ("", "", "")
    }

}









