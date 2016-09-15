//
//  BuyTicketViewController.swift
//  Azul Digital
//
//  Created by Leonardo Tsuda on 9/5/16.
//  Copyright © 2016 Leonardo Tsuda. All rights reserved.
//

import UIKit
import Firebase

class BuyTicketViewController: UIViewController, Readable {
    
    var user: User?
    var address: String?
    
    @IBOutlet weak var buyDescription: UITextView!
    @IBOutlet weak var buyButton: UIButton!
    @IBAction func buy(_ sender: AnyObject) {
        performSegue(withIdentifier: "ConfirmationSegue", sender: nil)
    }
    @IBAction func unwindToPresent(withSegue segue: UIStoryboardSegue) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        LoadingIndicatorView.show("Loading data")
        buyDescription.text = NSLocalizedString("buy-description", comment: "buy-ticket-description")
        buyButton.setImage(UIImage(named: NSLocalizedString("Buy-Ticket", comment: "buy-view")) , for: .normal)
        buyButton.setImage(UIImage(named: NSLocalizedString("Buy-Ticket-enabled", comment: "buy-view")) , for: .highlighted)
        
        guard let currentUser = FIRAuth.auth()?.currentUser else { return }
        
        read("users", id: currentUser.uid, completionObject: { [weak self] (user, car) in
            guard let user = user else { return }
            DispatchQueue.main.async {
                self?.user = user
                LoadingIndicatorView.hide()
            }})
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ConfirmationSegue" {
            guard let destination = segue.destination as? ConfirmationViewController else { return }
            destination.address = address ?? "No address"
            destination.user = user
        }
    }
}
