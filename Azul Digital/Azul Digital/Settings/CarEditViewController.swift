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
                        self?.tempCar?.plate = self?.plateEditTextField.text!
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.navigationBar.barTintColor = UIColor(red: 223/255, green: 15/255, blue: 15/255, alpha: 1)
        self.title = NSLocalizedString("Car", comment: "edit-car")
        textView.text = NSLocalizedString("privacy-car", comment: "edit-car")
        
        LoadingIndicatorView.show(overlayTarget: view, loadingText: "Loading Data")
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        read("users", id: id, completionObject: { [weak self] (user, car) in
            guard let plate = car?.plate, let user = user else { return }
            DispatchQueue.main.async {
                self?.user = user
            }
            self?.read("cars", id: plate, completionObject: { [weak self] (_, car) in
                
                DispatchQueue.main.async {
                    self?.tempCar = car
                    self?.brandEditTextField.text = car?.brand
                    self?.modelEditTextField.text = car?.model
                    self?.colorEditTextField.text = car?.color
                    self?.plateEditTextField.text = car?.plate
                    LoadingIndicatorView.hide()
                    self?.navigationItem.rightBarButtonItem?.isEnabled = true
                }
                
                })
            })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension CarEditViewController: FBUpdatable {
    func editCar() {
        let car = Car(plate: (tempCar?.plate)!, brand: brandEditTextField.text!, color: colorEditTextField.text!, model: modelEditTextField.text!, userID: id)
        saveData(withUser: user, withCar: car) { [weak self] (title, message, action) in
            if title != "" && message != "" && action != "" {
                self?.alert(title, message: message, actionTitle: action)
            } else {
                let _ = self?.navigationController?.popViewController(animated: true)
            }
        }
    }
}
