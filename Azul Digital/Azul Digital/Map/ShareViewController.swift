//
//  ShareViewController.swift
//  Azul Digital
//
//  Created by Leonardo Tsuda on 08/10/16.
//  Copyright © 2016 Leonardo Tsuda. All rights reserved.
//

import UIKit

class ShareViewController: UIViewController, FBServerTime, FBPostable, Alertable {

    @IBOutlet weak var timeTitleLabel: UILabel!
    @IBOutlet weak var shareLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBAction func share(_ sender: AnyObject) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true

        post(withAddress: address) { (title, message, actionTitle) in
            if title != "" {
                self.alert(title, message: message, actionTitle: actionTitle)
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            } else {
                self.dismiss(animated: true, completion: nil)
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
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
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        timeTitleLabel.text = Project.Localizable.Common.time.localized
        shareLabel.text = Project.Localizable.Common.share.localized
        shareButton.setTitle(Project.Localizable.Common.share.localized, for: .normal)
        cancelButton.setTitle(Project.Localizable.Common.cancel.localized, for: .normal)
        shareButton.configureCorner(to: shareButton)
        cancelButton.configureCorner(to: cancelButton)
        addressLabel.text = address
        DispatchQueue.main.async {
            self.gettime(completion: { (date, _, _) in
                self.timeLabel.text = "\(formatTime(from: date).0)"
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
