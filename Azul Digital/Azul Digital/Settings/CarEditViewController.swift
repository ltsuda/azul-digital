//
//  CarEditViewController.swift
//  Azul Digital
//
//  Created by Leonardo Tsuda on 7/25/16.
//  Copyright © 2016 Leonardo Tsuda. All rights reserved.
//

import UIKit

class CarEditViewController: UIViewController, Readable {
    
    @IBOutlet weak var brandEditTextField: UITextField!
    @IBOutlet weak var modelEditTextField: UITextField!
    @IBOutlet weak var colorEditTextField: UITextField!
    @IBOutlet weak var plateEditTextField: UITextField!
    @IBOutlet weak var textView: UITextView!
    
    @IBAction func save(_ sender: AnyObject) {
    }
    
    var id = String()
    var carPlate = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        LoadingIndicatorView.show(loadingText: "Loading data")
        
        read(child: "users", id: id, completionObject: { [weak self] (_, car) in
            guard let plate = car?.plate else { return }
            self?.read(child: "cars", id: plate, completionObject: { [weak self] (_, car) in
                
                DispatchQueue.main.async {
                    LoadingIndicatorView.hide()
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
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
