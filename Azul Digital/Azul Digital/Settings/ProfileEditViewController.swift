//
//  ProfileEditViewController.swift
//  Azul Digital
//
//  Created by Leonardo Tsuda on 7/25/16.
//  Copyright © 2016 Leonardo Tsuda. All rights reserved.
//

import UIKit

class ProfileEditViewController: UIViewController, Alertable, Readable, CheckTextField {
    
    @IBOutlet weak var editImageView: UIImageView!
    @IBOutlet weak var nameEditTextField: UITextField!
    @IBOutlet weak var lastNameEditTextField: UITextField!
    @IBAction func save(_ sender: AnyObject) {
        checkEmpty(textfield: [nameEditTextField.text!, lastNameEditTextField.text!]) { [weak self] (title, message, action) in
            if title != "" && message != "" && action != "" {
                self?.alert(title: title, message: message, actionTitle: action)
            } else {
                self?.currentUser?.firstName = self?.nameEditTextField.text!
                self?.currentUser?.lastName = self?.lastNameEditTextField.text!

                if self?.isImageLoaded == false {
                    self?.currentUser?.photo = self?.tempURL
                    self?.edit()
                } else {
                    self?.edit()
                }
            }
        }
    }
    
    var id = String()
    var currentUser: User?
    var isImageLoaded = false
    var tempURL: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        editImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(presentPickerViewController)))

        
    }
    g
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
                self?.currentUser = user
                self?.tempURL = user?.photo
            }
            })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ProfileEditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, Storagable, EditableProfile {
    
    func edit() {
        editProfile(user: currentUser, dbUserID: id, completion: { [weak self] (title, message, action) in
            if title != "" && message != "" && action != "" {
                self?.alert(title: title, message: message, actionTitle: action)
            } else {
                let _ = self?.navigationController?.popViewController(animated: true)
            }
        })
    }
    
    func presentPickerViewController(sender: AnyObject) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        var selectedImageFromPicker: UIImage?
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        if let selectedImage = selectedImageFromPicker {
            DispatchQueue.main.async {
                self.editImageView.image = selectedImage
                
            }
            upload(image: selectedImage, completion: { [weak self] (title, message, action) in
                if title != "" && message != "" && action != "" {
                    self?.alert(title: title, message: message, actionTitle: action)
                } else if !title.isEmpty {
                    self?.currentUser?.photo = title
                    self?.isImageLoaded = true
                }
                })
        }
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

