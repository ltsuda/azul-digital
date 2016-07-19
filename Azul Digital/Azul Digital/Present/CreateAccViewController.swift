//
//  CreateAccViewController.swift
//  Azul Digital
//
//  Created by Leonardo Tsuda on 7/11/16.
//  Copyright © 2016 Leonardo Tsuda. All rights reserved.
//

import UIKit
import Firebase

class CreateAccViewController: UIViewController, alertable, creatable {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBAction func register(_ sender: AnyObject) {
        guard let email = emailTextField.text , !(emailTextField.text?.isEmpty)!, let password = passwordTextField.text, !(passwordTextField.text?.isEmpty)! else {
            return alert(title: "Campos vazios", message: "Favor preencher os campos Email e Senha", actionTitle: "OK")
        }
        let _ = create(email: email, password: password)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        view.gradientBackbround(to: view)
        cancelButton.configureCorner(to: cancelButton)
        registerButton.configureCorner(to: registerButton)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        emailTextField.configureBorder(to: PlaceHolder.fill(.email))
        passwordTextField.configureBorder(to: PlaceHolder.fill(.password))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "RegisterSegue" {
            
        } else {
            
        }
    }
 

}


