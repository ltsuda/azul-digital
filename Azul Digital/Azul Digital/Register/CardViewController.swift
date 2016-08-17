//
//  CardViewController.swift
//  Azul Digital
//
//  Created by Leonardo Tsuda on 7/11/16.
//  Copyright © 2016 Leonardo Tsuda. All rights reserved.
//

import UIKit

class CardViewController: UIViewController, Alertable, CheckTextField, ValidateCard {
    
    @IBAction func finalizar(_ sender: AnyObject) {
        checkEmpty([cardTextField.text!, fundsTextField.text!]) { [weak self] (title, message, action) in
            if title != "" && message != "" && action != "" {
                self?.alert(title, message: message, actionTitle: action)
            } else {
                let cardIsValid = self?.validateCard((self?.cardTextField.text!)!)
                if cardIsValid == true {
                    self?.user?.card = self?.cardTextField.text!
                    self?.user?.funds = roundTwoDecimal((self?.fundsTextField.text!)!)
                    self?.tryUser = true
                } else {
                    self?.tryUser = false
                    self?.alert("Formato incorreto", message: "Favor preencher os campos corretamente", actionTitle: "Tentar novamente")
                }
            }
        }
        
        if tryUser == true {
            saveUser()
        }
        
    }
    @IBOutlet weak var fundsTextField: UITextField!
    @IBOutlet weak var cardTextField: UITextField!
    var user: User?
    var car: Car?
    var tryUser = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        cardTextField.placeHolderText(in: PlaceHolder.Card.Number)
        fundsTextField.placeHolderText(in: PlaceHolder.Card.Funds)
    }
}

extension CardViewController: SaveUser, SaveCar {
    func saveUser() {
        saveData(user, completion: { [weak self] (title, message, action) in
            if title != "" && message != "" && action != "" {
                self?.alert(title, message: message, actionTitle: action)
                self?.tryUser = false
            } else {
                self?.saveCar()
            }
            })
    }
    func saveCar() {
        save(car, completion: { [weak self] (title, message, action) in
            if title != "" && message != "" && action != "" {
                self?.alert(title, message: message, actionTitle: action)
            } else {
                self?.performSegue(withIdentifier: "MapSegue", sender: nil)
            }
            })
    }
}
