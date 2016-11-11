//
//  ConfirmationViewController.swift
//  Azul Digital
//
//  Created by Leonardo Tsuda on 9/5/16.
//  Copyright © 2016 Leonardo Tsuda. All rights reserved.
//

import UIKit
import Firebase

class ConfirmationViewController: UIViewController, Alertable, FBServerTime {
    
    @IBOutlet weak var askLabel: UILabel!
    @IBOutlet weak var addressLabel: ReceiptLabel!
    @IBOutlet weak var valueDescriptionLabel: ReceiptLabel!
    @IBOutlet weak var timeDescriptionLabel: ReceiptLabel!
    @IBOutlet weak var valueLabel: ReceiptLabel!
    @IBOutlet weak var timeLabel: ReceiptLabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var buyButton: UIButton!
    @IBAction func buy(_ sender: AnyObject) {
        guard  let user = user, let funds = user.cash else {
            return alert(Project.Localizable.Common.user_inexistent.localized, message: Project.Localizable.Common.user_inexistent_description.localized, actionTitle: Project.Localizable.Common.try_again.localized)
        }
        
        if funds < valueToPay {
            alertWithHanlder(Project.Localizable.Common.empty_cash.localized, message: Project.Localizable.Common.empty_cash_description.localized, actionTitle: Project.Localizable.Common.ok.localized) { [weak self] in
                self?.userFunds = 100.0 - (self?.valueToPay)!
                self?.saveValues(user: user)
            }
            
        } else {
            userFunds = funds - valueToPay
            saveValues(user: user)
        }
    }
    
    var address: String?
    var user: User?
    var userFunds = Double()
    let valueToPay = 3.50
    var ticketReference: FIRDatabaseReference?
    let delegate = UIApplication.shared.delegate as? AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        cancelButton.configureCorner(to: cancelButton)
        buyButton.configureCorner(to: buyButton)
        
        DispatchQueue.main.async {
            self.cancelButton.setTitle(Project.Localizable.Common.cancel.localized, for: .normal)
            self.buyButton.setTitle(Project.Localizable.Common.buy.localized, for: .normal)
            self.askLabel.text = Project.Localizable.Common.confirmation.localized
            self.addressLabel.text = self.address
            self.valueDescriptionLabel.text = Project.Localizable.Common.value.localized
            self.timeDescriptionLabel.text = Project.Localizable.Common.time.localized
            self.valueLabel.text = "R$\(self.getValue().0)"
            self.gettime(completion: { (date, _, _) in
                self.timeLabel.text = "\(formatTime(from: date).0)"
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ConfirmationViewController {
    
    func getValue() -> (String, Double) {
        let format = NumberFormatter()
        format.minimumFractionDigits = 2
        format.maximumFractionDigits = 2
        format.locale = Locale.current
        guard let valueString = format.string(for: valueToPay) else { return ("0.0", 0.0)}
        guard let valueDouble = format.number(from: valueString)?.doubleValue else { return ("0.00", 0.0)}
        return (valueString, valueDouble)
    }
    
    func saveValues(user: User) {
        
        let ticketKey = rootFBReference.child("ticket").childByAutoId().key
        
        guard  let plate = user.carPlate else { return }
        guard let street = address else { return }
        guard let userID = FIRAuth.auth()?.currentUser?.uid else { return }
        
        let updateData: [String : Any] = [
            "timeStamps/\(userID)" : FIRServerValue.timestamp(),
            "users/\(userID)/cash" : userFunds,
            "cars/\(plate)/ticket/\(ticketKey)" : [
                "name" : "\(user.firstName!) \(user.lastName!)",
                "address" : street,
                "isPaid" : true,
                "value" : getValue().1,
                "timeStampSince1970" : FIRServerValue.timestamp()]
        ]
        
        rootFBReference.updateChildValues(updateData) { (error, _) in
            if error != nil {
                if let code = (error as? NSError)?.code {
                    self.alert("\(Project.Localizable.Common.code.localized): \(code)", message: "\(error?.localizedDescription)", actionTitle: Project.Localizable.Common.try_again.localized)
                }
            } else {
                defaults.set(false, forKey: "buyButton")
                defaults.synchronize()
                self.gettime(completion: { (date, _, _) in
                    self.delegate?.scheduleNotification(at: date)
                })
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}
