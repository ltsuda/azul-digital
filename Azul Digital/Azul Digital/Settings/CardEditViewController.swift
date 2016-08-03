//
//  CardEditViewController.swift
//  Azul Digital
//
//  Created by Leonardo Tsuda on 7/25/16.
//  Copyright © 2016 Leonardo Tsuda. All rights reserved.
//

import UIKit

class CardEditViewController: UIViewController, Readable {

    @IBOutlet weak var cardEditTextField: UITextField!
    @IBOutlet weak var textView: UITextView!
    @IBAction func save(_ sender: AnyObject) {
    }

    var id = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        LoadingIndicatorView.show(loadingText: "Loading data")
        read(child: "users", id: id, completionObject: { [weak self] (user, _) in
            
            DispatchQueue.main.async {
                LoadingIndicatorView.hide()
                self?.cardEditTextField.text = user?.card
            }

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
