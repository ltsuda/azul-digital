//
//  BuyTicketViewController.swift
//  Azul Digital
//
//  Created by Leonardo Tsuda on 9/5/16.
//  Copyright © 2016 Leonardo Tsuda. All rights reserved.
//

import UIKit
import Firebase

class BuyTicketViewController: UIViewController, Readable, FBServerTime {
    
    var user: User?
    var address: String?
    
    @IBOutlet weak var buyDescription: UITextView!
    @IBOutlet weak var buyButton: UIButton!
    @IBAction func buy(_ sender: AnyObject) {
        performSegue(withIdentifier: "ConfirmationSegue", sender: nil)
    }
    @IBAction func unwindToBuy(withSegue segue: UIStoryboardSegue) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        enableBuyButtonAfterTimer()
        
        if defaults.object(forKey: "buyButton") as? Bool != true {
            buyButton.isEnabled = false
        } else {
            buyButton.isEnabled = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        LoadingIndicatorView.show(Project.Localizable.Common.loading_data.localized)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true

        buyDescription.text = Project.Localizable.Common.buy_ticket_description.localized
        buyButton.setImage(UIImage(named: Project.Images.Buttons.buy_ticket.image) , for: .normal)
        buyButton.setImage(UIImage(named: Project.Images.Buttons.buy_ticket_enabled.image) , for: .highlighted)
        
        guard let currentUser = FIRAuth.auth()?.currentUser else { return }
        read("users", id: currentUser.uid, completionObject: { [weak self] (user, car) in
            guard let user = user else { return }
            DispatchQueue.main.async {
                self?.user = user
                LoadingIndicatorView.hide()
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }})
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ConfirmationSegue" {
            guard let destination = segue.destination as? ConfirmationViewController else { return }
            destination.address = address ?? Project.Localizable.Common.no_address.localized
            destination.user = user
        }
    }
    
    func enableBuyButtonAfterTimer() {
        gettime { (date, _, _) in
            let currentTime = Int(Date().timeIntervalSince(date))
            if currentTime >= 20 {
                defaults.setValue(true, forKey: "buyButton")
                defaults.synchronize()
            }
        }
    }
    
}
