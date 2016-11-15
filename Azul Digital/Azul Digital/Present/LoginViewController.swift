//
//  LoginViewController.swift
//  Azul Digital
//
//  Created by Leonardo Tsuda on 7/11/16.
//  Copyright © 2016 Leonardo Tsuda. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, Alertable, Loggable {
    
    @IBOutlet weak var loginCardImage: UIImageView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBAction func login(_ sender: AnyObject) {
        login(emailTextField.text!, password: passwordTextField.text!) { [weak self] (title, message, action) in
            if title != "" && message != "" && action != "" {
                print("\(title, message, action)")
                self?.alert(title, message: message, actionTitle: action)
            } else {
                self?.performSegue(withIdentifier: "MapLoginSegue", sender: nil)
            }
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loginButton.setTitle(Project.Localizable.Common.login.localized, for: .normal)
        cancelButton.setTitle(Project.Localizable.Common.cancel.localized, for: .normal)
        passwordLabel.text = Project.Localizable.Common.password.localized
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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return .lightContent
        }
    }
    
}
