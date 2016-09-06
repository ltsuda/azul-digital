//
//  CarEditViewController.swift
//  Azul Digital
//
//  Created by Leonardo Tsuda on 7/25/16.
//  Copyright © 2016 Leonardo Tsuda. All rights reserved.
//

import UIKit

class CarEditViewController: UIViewController, Readable, CheckTextField, Alertable, ValidatePlate {
    
    @IBOutlet weak var brandEditTextField: UITextField!
    @IBOutlet weak var modelEditTextField: UITextField!
    @IBOutlet weak var colorEditTextField: UITextField!
    @IBOutlet weak var plateEditTextField: UITextField!
    @IBOutlet weak var textView: UITextView!
    
    @IBAction func save(_ sender: AnyObject) {
        checkEmpty([brandEditTextField.text!, modelEditTextField.text!, colorEditTextField.text!, plateEditTextField.text!]) { [weak self] (title, message, action) in
            if title != "" && message != "" && action != "" {
                self?.alert(title, message: message, actionTitle: action)
            } else {
                let validate = self?.validatePlate((self?.plateEditTextField.text!)!)
                if validate == true {
                    if self?.plateEditTextField.text! != self?.tempCar?.plate {
                        self?.editCar()
                    } else {
                        self?.alert("Veículo já existente", message: "Favor preencher os campos com os dados do seu novo veículo", actionTitle: "Tentar novamente")
                    }
                } else {
                    self?.alert("Formato incorreto", message: "Favor preencher a placa no formato ABC0001", actionTitle: "Tentar novamente")
                }
            }
        }
    }
    
    var id = String()
    var user: User?
    var tempCar: Car?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        brandEditTextField.delegate = self
        modelEditTextField.delegate = self
        colorEditTextField.delegate = self
        plateEditTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        LoadingIndicatorView.show("Loading data")
        
        read("users", id: id, completionObject: { [weak self] (user, car) in
            guard let plate = car?.plate, let user = user else { return }
            DispatchQueue.main.async {
                self?.user = user
            }
            self?.read("cars", id: plate, completionObject: { [weak self] (_, car) in
                
                DispatchQueue.main.async {
                    LoadingIndicatorView.hide()
                    self?.tempCar = car
                    self?.brandEditTextField.text = car?.brand
                    self?.modelEditTextField.text = car?.model
                    self?.colorEditTextField.text = car?.color
                    self?.plateEditTextField.text = car?.plate
                }
                
                })
            })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


extension CarEditViewController: SaveCar, EditableCar {
    
    func editCar() {
        let car = Car(plate: plateEditTextField.text!, brand: brandEditTextField.text!, color: colorEditTextField.text!, model: modelEditTextField.text!, userID: id)
        user?.carPlate = car.plate
        save(car, completion: { [weak self] (title, message, action) in
            if title != "" && message != "" && action != "" {
                self?.alert(title, message: message, actionTitle: action)
            } else {
                self?.editCar((self?.id)!, plate: self?.user?.carPlate, completion: { (title, message, action) in
                    if title != "" && message != "" && action != "" {
                        self?.alert(title, message: message, actionTitle: action)
                    } else {
                        let _ = self?.navigationController?.popViewController(animated: true)
                    }
                })
            }
            })
    }
}

extension CarEditViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
