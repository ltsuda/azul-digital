//
//  ConfirmationViewController.swift
//  Azul Digital
//
//  Created by Leonardo Tsuda on 9/5/16.
//  Copyright © 2016 Leonardo Tsuda. All rights reserved.
//

import UIKit

class ConfirmationViewController: UIViewController {
    
    @IBOutlet weak var askLabel: UILabel!
    @IBOutlet weak var addressLabel: ReceiptLabel!
    @IBOutlet weak var valueDescriptionLabel: ReceiptLabel!
    @IBOutlet weak var timeDescriptionLabel: ReceiptLabel!
    @IBOutlet weak var valueLabel: ReceiptLabel!
    @IBOutlet weak var timeLabel: ReceiptLabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var buyButton: UIButton!
    @IBAction func buy(_ sender: AnyObject) {
    }
    var address: String?
    var user: User?
    var car: Car?
    let valueToPay = 3.50
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        cancelButton.configureCorner(to: cancelButton)
        buyButton.configureCorner(to: buyButton)
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "pt-BR")
        dateFormatter.dateFormat = "HH:mm"
        let time = dateFormatter.string(from: date)
        
        let format = NumberFormatter()
        format.minimumFractionDigits = 2
        format.maximumFractionDigits = 2
        format.locale = Locale.current
        guard let price = format.string(for: self.valueToPay) else { return }
        
        DispatchQueue.main.async {
           
            self.cancelButton.titleLabel?.text = NSLocalizedString("cancel-button", comment: "cancel-confirmation")
            self.buyButton.titleLabel?.text = NSLocalizedString("buy-button", comment: "buy-confirmation")
            self.askLabel.text = NSLocalizedString("ask-label", comment: "ask-confirmation")
            self.addressLabel.text = self.address
            self.valueDescriptionLabel.text = NSLocalizedString("value-description", comment: "value-confirmation")
            self.timeDescriptionLabel.text = NSLocalizedString("time-description", comment: "time-confirmation")
            self.valueLabel.text = "R$\(price)"
            self.timeLabel.text = time
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
