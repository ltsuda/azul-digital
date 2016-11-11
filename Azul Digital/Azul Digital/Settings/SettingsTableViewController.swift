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
        
        self.title = Project.Localizable.Common.settings.localized
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.navigationBar.barTintColor = UIColor(red: 15/255, green: 127/255, blue: 223/255, alpha: 1)
        guard let current = FIRAuth.auth()?.currentUser else { return }
        userID = current.uid
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "CardEditSegue" {
            guard let destination = segue.destination as? CardEditViewController else { return print("failed CardEditViewController")}
            destination.id = userID
        } else if segue.identifier == "CarEditSegue" {
            guard let destination = segue.destination as? CarEditViewController else { return print("failed CarEditViewController")}
            destination.id = userID
        } else if segue.identifier == "ProfileEditSegue" {
            guard let destination = segue.destination as? ProfileEditViewController else { return print("failed ProfileEditViewController")}
            destination.id = userID
        } else if segue.identifier == "HistorySegue" {
            guard let destination = segue.destination as? HistoryTableViewController else { return print("failed HistoryTableViewController")}
            destination.id = userID
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
