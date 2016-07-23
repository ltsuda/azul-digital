//
//  CarViewController.swift
//  Azul Digital
//
//  Created by Leonardo Tsuda on 7/11/16.
//  Copyright © 2016 Leonardo Tsuda. All rights reserved.
//

import UIKit

class CarViewController: UIViewController, alertable, CheckTextField, ValidatePlate {
    
    @IBOutlet weak var brandTextField: UITextField!
    @IBOutlet weak var modelTextField: UITextField!
    @IBOutlet weak var colorTextField: UITextField!
    @IBOutlet weak var plateTextField: UITextField!
    @IBAction func next(_ sender: AnyObject) {
        checkEmpty(textfield: [brandTextField.text!, modelTextField.text!, colorTextField.text!, plateTextField.text!]) { [weak self] (title, message, action) in
            if title != "" && message != "" && action != "" {
                self?.alert(title: title, message: message, actionTitle: action)
            } else {
                let validate = self?.validatePlate(plate: (self?.plateTextField.text!)!)
                if validate == true {
                    self?.performSegue(withIdentifier: "CardSegue", sender: nil)
                } else {
                    self?.alert(title: "Formato incorreto", message: "Favor preencher a placa no formato ABC0001", actionTitle: "Tentar novamente")
                }
            }
        }
    }
    var user: User?
    
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
        brandTextField.placeHolderText(in: PlaceHolder.fill(.brand))
        modelTextField.placeHolderText(in: PlaceHolder.fill(.model))
        colorTextField.placeHolderText(in: PlaceHolder.fill(.color))
        plateTextField.placeHolderText(in: PlaceHolder.fill(.plate))
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "CardSegue" {
            guard let destination = segue.destinationViewController as? CardViewController else {
                return print("failed segue destination")
            }
            let car = Car(plate: plateTextField.text!, brand: brandTextField.text!, color: colorTextField.text!, model: modelTextField.text!)
            user?.carPlate = car.plate
            destination.car = car
            destination.user = user           
            
        } else {
            return print("failed segue CardSegue")
            
        }
    }
    
    
}
