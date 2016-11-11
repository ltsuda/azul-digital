//
//  CarViewController.swift
//  Azul Digital
//
//  Created by Leonardo Tsuda on 7/11/16.
//  Copyright © 2016 Leonardo Tsuda. All rights reserved.
//

import UIKit

class CarViewController: UIViewController, Alertable, CheckTextField, ValidatePlate {
    
    @IBOutlet weak var privacyTextView: UITextView!
    @IBOutlet weak var brandTextField: UITextField!
    @IBOutlet weak var modelTextField: UITextField!
    @IBOutlet weak var colorTextField: UITextField!
    @IBOutlet weak var plateTextField: UITextField!
    @IBAction func next(_ sender: AnyObject) {
        checkEmpty([brandTextField.text!, modelTextField.text!, colorTextField.text!, plateTextField.text!]) { [weak self] (title, message, action) in
            if title != "" && message != "" && action != "" {
                self?.alert(title, message: message, actionTitle: action)
            } else {
                let validate = self?.validatePlate((self?.plateTextField.text!)!)
                if validate == true {
                    self?.performSegue(withIdentifier: "CardSegue", sender: nil)
                } else {
                    self?.alert(Project.Localizable.Common.wrong_format.localized, message: Project.Localizable.Common.plate_format_description.localized, actionTitle: Project.Localizable.Common.try_again.localized)
                }
            }
        }
    }
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        privacyTextView.text = Project.Localizable.Common.car_description.localized
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        brandTextField.placeHolderText(in: PlaceHolder.Car.Brand)
        modelTextField.placeHolderText(in: PlaceHolder.Car.Model)
        colorTextField.placeHolderText(in: PlaceHolder.Car.Color)
        plateTextField.placeHolderText(in: PlaceHolder.Car.Plate)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "CardSegue" {
            guard let destination = segue.destination as? CardViewController else {
                return print("failed segue destination")
            }
            let car = Car(plate: plateTextField.text!, brand: brandTextField.text!, color: colorTextField.text!, model: modelTextField.text!, userID: user?.userID)
            user?.carPlate = car.plate
            destination.car = car
            destination.user = user
            
        } else {
            return print("failed segue CardSegue")
            
        }
    }
    
}
