//
//  CardViewController.swift
//  Azul Digital
//
//  Created by Leonardo Tsuda on 7/11/16.
//  Copyright © 2016 Leonardo Tsuda. All rights reserved.
//

import UIKit

class CardViewController: UIViewController, alertable, CheckTextField, ValidateCard {

    @IBAction func finalizar(_ sender: AnyObject) {
        checkEmpty(textfield: [cardTextField.text!]) { [weak self] (title, message, action) in
            if title != "" && message != "" && action != "" {
                self?.alert(title: title, message: message, actionTitle: action)
            } else {
                let validate = self?.validateCard(card: (self?.cardTextField.text!)!)
                if validate == true {
                    self?.performSegue(withIdentifier: "MapSegue", sender: nil)
                } else {
                    self?.alert(title: "Formato incorreto", message: "Favor preencher o numero do cartão corretamente", actionTitle: "Tentar novamente")
                }
            }
        }
    }
    @IBOutlet weak var cardTextField: UITextField!
    var user: User?
    var car: Car?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation
    //TODO: Implement Firebase methods to save User and Car's data into FirebaseDataBase   
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
