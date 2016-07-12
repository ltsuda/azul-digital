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
    @IBAction func createAcc(_ sender: AnyObject) {
    }
    @IBOutlet weak var alreadyMemberButton: UIButton!
    @IBAction func alreadyMember(_ sender: AnyObject) {
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        view.gradientBackbround(to: view)
        createAccButton.configureCorner(to: createAccButton)
        alreadyMemberButton.configureCorner(to: alreadyMemberButton)

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
