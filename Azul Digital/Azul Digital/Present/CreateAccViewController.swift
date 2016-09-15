//
//  CreateAccViewController.swift
//  Azul Digital
//
//  Created by Leonardo Tsuda on 7/11/16.
//  Copyright © 2016 Leonardo Tsuda. All rights reserved.
//

import UIKit
import FirebaseAuth

class CreateAccViewController: UIViewController, Alertable, Creatable {
    
    @IBOutlet weak var registerCardImage: UIImageView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBAction func register(_ sender: AnyObject) {
        // create account with email/password and if there're an error, use closure to send an alert, else perform RegisterSegue
        create(emailTextField.text!, password: passwordTextField.text!) { [weak self] (title, message, action) in
            if title != "" && message != "" && action != "" {
                self?.alert(title, message: message, actionTitle: action)
            } else {
                self?.performSegue(withIdentifier: "RegisterSegue", sender: nil)
            }
        }       
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        backgroundImage.applyMotionEffect(magnitude: 10)
        registerCardImage.applyMotionEffect(magnitude: -20)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        cancelButton.configureCorner(to: cancelButton)
        registerButton.configureCorner(to: registerButton)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        emailTextField.configureBorder(to: PlaceHolder.User.Email)
        passwordTextField.configureBorder(to: PlaceHolder.User.Password)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return .lightContent
        }
    }
}

extension CreateAccViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

