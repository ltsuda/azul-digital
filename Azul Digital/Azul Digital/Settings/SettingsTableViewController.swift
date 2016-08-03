//
//  SettingsTableViewController.swift
//  Azul Digital
//
//  Created by Leonardo Tsuda on 7/25/16.
//  Copyright © 2016 Leonardo Tsuda. All rights reserved.
//

import UIKit
import FirebaseAuth

class SettingsTableViewController: UITableViewController {

    @IBAction func cancelModification(withSegue segue: UIStoryboardSegue) {
        
    }
    
    var userID = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Configuração"

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        guard let id = FIRAuth.auth()?.currentUser?.uid else { return }
        userID = id
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "CardEditSegue" {
            guard let destination = segue.destination as? CardEditViewController else { return print("failed CardEditViewController")}
            destination.id = userID
        } else if segue.identifier == "CarEditSegue" {
            guard let destination = segue.destination as? CarEditViewController else { return print("failed CarEditViewController")}
            destination.id = userID
        } else if segue.identifier == "ProfileEditSegue" {
            guard let destination = segue.destination as? ProfileEditViewController else { return print("failed ProfileEditViewController")}
            destination.id = userID
        }
        
    }
}
