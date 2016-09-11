//
//  PresentViewController.swift
//  Azul Digital
//
//  Created by Leonardo Tsuda on 7/11/16.
//  Copyright © 2016 Leonardo Tsuda. All rights reserved.
//

import UIKit

class PresentViewController: UIViewController {

    @IBOutlet weak var createAccButton: UIButton!
    @IBOutlet weak var alreadyMemberButton: UIButton!
    @IBAction func unwindToPresent(withSegue segue: UIStoryboardSegue) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
      
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        view.gradientBackbround(to: view)
        createAccButton.configureCorner(to: createAccButton)
        alreadyMemberButton.configureCorner(to: alreadyMemberButton)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return .lightContent
        }
    }
    
}
