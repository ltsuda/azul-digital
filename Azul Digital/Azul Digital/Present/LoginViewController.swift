//
//  LoginViewController.swift
//  Azul Digital
//
//  Created by Leonardo Tsuda on 7/11/16.
//  Copyright © 2016 Leonardo Tsuda. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBAction func login(_ sender: AnyObject) {
        performSegue(withIdentifier: "LoginSegue", sender: nil)
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
        if segue.identifier == "LoginSegue" {
            let storyboard = UIStoryboard(name: "Map", bundle: nil)
            let destination = storyboard.instantiateInitialViewController()
            present(destination!, animated: true, completion: nil)
        }
    }
 

}
