//
//  CardEditViewController.swift
//  Azul Digital
//
//  Created by Leonardo Tsuda on 7/25/16.
//  Copyright © 2016 Leonardo Tsuda. All rights reserved.
//

import UIKit
import Firebase

class CardEditViewController: UIViewController, Readable, CheckTextField, Alertable, ValidateCard {
    
    @IBOutlet weak var saveLabel: UIBarButtonItem!
    @IBOutlet weak var cardEditTextField: UITextField!
    @IBOutlet weak var cashEditTextField: UITextField!
    @IBOutlet weak var textView: UITextView!
    @IBAction func save(_ sender: AnyObject) {
        checkEmpty([cardEditTextField.text!]) { [weak self] (title, message, action) in
            if title != "" && message != "" && action != "" {
                self?.alert(title, message: message, actionTitle: action)
            } else {
                let validate = self?.validateCard((self?.cardEditTextField.text!)!)
                if validate == true {
                    self?.currentUser?.card = self?.cardEditTextField.text!
                    //                    FIXME: Fix decimal separator to every Localization because Firebase returns "." as separator. If I keep .replacing method this way and iPhone's location is US/UK, this method will fail and crashes.
                    self?.currentUser?.cash = roundTwoDecimal((self?.cashEditTextField.text!)!.replacingOccurrences(of: ".", with: ","))
                    self?.editCard()
                } else {
                    self?.alert(Project.Localizable.Common.wrong_format.localized, message: Project.Localizable.Common.wrong_format_description.localized, actionTitle: Project.Localizable.Common.try_again.localized)
                }
            }
        }
    }
    
    var id = String()
    var currentUser: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.navigationBar.barTintColor = UIColor(red: 223/255, green: 167/255, blue: 15/255, alpha: 1)
        title = Project.Localizable.Common.card.localized
        textView.text = Project.Localizable.Common.card_description.localized
        saveLabel.title = Project.Localizable.Common.save.localized
        LoadingIndicatorView.show(overlayTarget: view, loadingText: Project.Localizable.Common.loading_data.localized)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        read("users", id: id, completionObject: { [weak self] (user, _) in
            DispatchQueue.main.async {
                self?.cardEditTextField.text = user?.card
                self?.cashEditTextField.text = "\((user?.cash)!)"
                self?.currentUser = user
                LoadingIndicatorView.hide()
                self?.navigationItem.rightBarButtonItem?.isEnabled = true
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
            })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension CardEditViewController: FBCardEditable {
    func editCard() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        saveCard(withUser: currentUser, withID: id) { [weak self] (title, message, action) in
            if title != "" && message != "" && action != "" {
                self?.alert(title, message: message, actionTitle: action)
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            } else {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                let _ = self?.navigationController?.popViewController(animated: true)
            }
        }
    }
}
