//
//  CardViewController.swift
//  Azul Digital
//
//  Created by Leonardo Tsuda on 7/11/16.
//  Copyright © 2016 Leonardo Tsuda. All rights reserved.
//

import UIKit

class CardViewController: UIViewController, Alertable, CheckTextField, ValidateCard, ValidateFunds {
    
    @IBAction func finalizar(_ sender: AnyObject) {
        checkEmpty(textfield: [cardTextField.text!, fundsTextField.text!]) { [weak self] (title, message, action) in
            if title != "" && message != "" && action != "" {
                self?.alert(title: title, message: message, actionTitle: action)
            } else {
                let cardIsValid = self?.validateCard(card: (self?.cardTextField.text!)!)
                let fundsIsValid = self?.validatefunds(funds: (self?.fundsTextField.text!)!)
                if cardIsValid == true && fundsIsValid == true {
                    self?.user?.card = self?.cardTextField.text!
                    let fundString = (self?.fundsTextField.text!)!
                    let formattedFund = fundString.roundTwoDecimal(number: fundString)
                    self?.user?.funds = formattedFund
                    print(self?.user?.funds)
                    self?.tryUser = true
                } else {
                    self?.tryUser = false
                    self?.alert(title: "Formato incorreto", message: "Favor preencher os campos corretamente", actionTitle: "Tentar novamente")
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
        saveData(user: user, completion: { [weak self] (title, message, action) in
            if title != "" && message != "" && action != "" {
                self?.alert(title: title, message: message, actionTitle: action)
                self?.tryUser = false
            } else {
                self?.saveCar()
            }
            })
    }
    func saveCar() {
        save(car: car, completion: { [weak self] (title, message, action) in
            if title != "" && message != "" && action != "" {
                self?.alert(title: title, message: message, actionTitle: action)
            } else {
                self?.performSegue(withIdentifier: "MapSegue", sender: nil)
            }
            })
    }
}
