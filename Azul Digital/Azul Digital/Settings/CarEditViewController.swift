//
//  CarEditViewController.swift
//  Azul Digital
//
//  Created by Leonardo Tsuda on 7/25/16.
//  Copyright © 2016 Leonardo Tsuda. All rights reserved.
//

import UIKit

class CarEditViewController: UIViewController {

    @IBOutlet weak var brandEditTextField: UITextField!
    @IBOutlet weak var modelEditTextField: UITextField!
    @IBOutlet weak var colorEditTextField: UITextField!
    @IBOutlet weak var plateEditTextField: UITextField!
    @IBOutlet weak var textView: UITextView!

    @IBAction func save(_ sender: AnyObject) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
