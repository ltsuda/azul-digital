//
//  ProfileEditViewController.swift
//  Azul Digital
//
//  Created by Leonardo Tsuda on 7/25/16.
//  Copyright © 2016 Leonardo Tsuda. All rights reserved.
//

import UIKit

class ProfileEditViewController: UIViewController, Alertable, Readable, Storagable {
    
    @IBOutlet weak var editImageView: UIImageView!
    @IBOutlet weak var nameEditTextField: UITextField!
    @IBOutlet weak var lastNameEditTextField: UITextField!
    @IBAction func save(_ sender: AnyObject) {
    }
    
    var id = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        LoadingIndicatorView.show(loadingText: "Loading data")
        
        read(child: "users", id: id, completionObject: { [weak self] (user, _) in
            
            self?.download(completion: { (object, message, action) in
                if message != "" && action != "" {
                    self?.alert(title: object as! String, message: message, actionTitle: action)
                } else {
                    DispatchQueue.main.async {
                        LoadingIndicatorView.hide()
                        self?.editImageView.image = UIImage(data: object as! Data)
                        self?.editImageView.configureBorder()
                        self?.editImageView.layoutIfNeeded()
                    }
                }
            })
            
            DispatchQueue.main.async {
                self?.nameEditTextField.text = user?.firstName
                self?.lastNameEditTextField.text = user?.lastName
            }
            })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
