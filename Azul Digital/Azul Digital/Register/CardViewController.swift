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
                    self?.alert(Project.Localizable.Common.wrong_format.localized, message: Project.Localizable.Common.wrong_format_description.localized, actionTitle: Project.Localizable.Common.try_again.localized)
                }
            }
        }
        
        if tryUser == true {
            save()
        }
        
    }
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var privacyTextView: UITextView!
    @IBOutlet weak var cashTextField: UITextField!
    @IBOutlet weak var cardTextField: UITextField!
    var user: User?
    var car: Car?
    var tryUser = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Project.Localizable.Common.card.localized
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        doneButton.title = Project.Localizable.Common.done.localized
        privacyTextView.text = Project.Localizable.Common.card_description.localized
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

extension CardViewController: FBUpdatable {
    func save() {
        saveData(withUser: user, withCar: car) { [weak self] (title, message, action) in
            if title != "" && message != "" && action != "" {
                self?.alert(title, message: message, actionTitle: action)
            } else {
                self?.performSegue(withIdentifier: "MapSegue", sender: nil)
            }
        }
    }
}
