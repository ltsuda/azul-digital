//
//  LoginViewController.swift
//  Azul Digital
//
//  Created by Leonardo Tsuda on 7/11/16.
//  Copyright © 2016 Leonardo Tsuda. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, Alertable, Loggable {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBAction func login(_ sender: AnyObject) {
        login(email: emailTextField.text!, password: passwordTextField.text!) { [weak self] (title, message, action) in
            if title != "" && message != "" && action != "" {
                print("\(title, message, action)")
                self?.alert(title: title, message: message, actionTitle: action)
            } else {
                print("login success")
                self?.performSegue(withIdentifier: "MapLoginSegue", sender: nil)
            }
        }

    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        view.gradientBackbround(to: view)
        cancelButton.configureCorner(to: cancelButton)
        loginButton.configureCorner(to: loginButton)
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

}
