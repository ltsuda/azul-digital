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
        checkEmpty([cardTextField.text!, cashTextField.text!]) { [weak self] (title, message, action) in
            if title != "" && message != "" && action != "" {
                self?.alert(title, message: message, actionTitle: action)
            } else {
                let cardIsValid = self?.validateCard((self?.cardTextField.text!)!)
                if cardIsValid == true {
                    self?.user?.card = self?.cardTextField.text!
                    self?.user?.cash = roundTwoDecimal((self?.cashTextField.text!)!)
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
    @IBOutlet weak var cashTextField: UITextField!
    @IBOutlet weak var cardTextField: UITextField!
    var user: User?
    var car: Car?
    var tryUser = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        cashTextField.delegate = self
        cardTextField.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        cardTextField.placeHolderText(in: PlaceHolder.Card.Number)
        cashTextField.placeHolderText(in: PlaceHolder.Card.Funds)
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

extension CardViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
