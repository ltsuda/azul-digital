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
            return alert("Usuário inexistente", message: "Dados do usuário não existem", actionTitle: "Tentar novamente")
        }
        
        if funds < valueToPay {
            alertWithHanlder("Saldo insuficiente", message: "Deseja recarregar?", actionTitle: "OK") { [weak self] in
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
            self.cancelButton.titleLabel?.text = NSLocalizedString("cancel-button", comment: "cancel-confirmation")
            self.buyButton.titleLabel?.text = NSLocalizedString("buy-button", comment: "buy-confirmation")
            self.askLabel.text = NSLocalizedString("ask-label", comment: "ask-confirmation")
            self.addressLabel.text = self.address
            self.valueDescriptionLabel.text = NSLocalizedString("value-description", comment: "value-confirmation")
            self.timeDescriptionLabel.text = NSLocalizedString("time-description", comment: "time-confirmation")
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
                    self.alert("Código: \(code)", message: "\(error?.localizedDescription)", actionTitle: "Tentar novamente")
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
