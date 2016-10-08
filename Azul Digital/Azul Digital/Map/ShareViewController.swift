//
//  ShareViewController.swift
//  Azul Digital
//
//  Created by Leonardo Tsuda on 08/10/16.
//  Copyright © 2016 Leonardo Tsuda. All rights reserved.
//

import UIKit

class ShareViewController: UIViewController, FBServerTime, FBPostable, Alertable {

    @IBOutlet weak var addressLabel: ReceiptLabel!
    @IBOutlet weak var timeLabel: ReceiptLabel!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBAction func share(_ sender: AnyObject) {
        post(withAddress: address) { (title, message, actionTitle) in
            if title != "" {
                self.alert(title, message: message, actionTitle: actionTitle)
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    var address: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        shareButton.configureCorner(to: shareButton)
        cancelButton.configureCorner(to: cancelButton)
        addressLabel.text = address
        gettime(completion: { (date, _, _) in
            self.timeLabel.text = "\(formatTime(from: date))"
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
