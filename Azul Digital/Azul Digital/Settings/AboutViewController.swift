//
//  AboutViewController.swift
//  Azul Digital
//
//  Created by Leonardo Tsuda on 08/10/16.
//  Copyright © 2016 Leonardo Tsuda. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.navigationBar.barTintColor = UIColor(red: 15/255, green: 223/255, blue: 129/255, alpha: 1)
    }
}
