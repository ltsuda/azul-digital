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
        checkEmpty([nameEditTextField.text!, lastNameEditTextField.text!]) { [weak self] (title, message, action) in
            if title != "" && message != "" && action != "" {
                self?.alert(title, message: message, actionTitle: action)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.title = Project.Localizable.Common.profile_title.localized
        
        LoadingIndicatorView.show(overlayTarget: view, loadingText: Project.Localizable.Common.loading_data.localized)
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        read("users", id: id, completionObject: { [weak self] (user, _) in
            if user?.photo != "localImage" {
                self?.download({ (object, message, action) in
                    if message != "" && action != "" {
                        self?.alert(object as! String, message: message, actionTitle: action)
                    } else {
                        DispatchQueue.main.async {
                            self?.editImageView.image = UIImage(data: object as! Data)
                            LoadingIndicatorView.hide()
                        }
                    }
                })
            } else {
                DispatchQueue.main.async {
                    self?.editImageView.image = UIImage(named: (user?.photo)!)
                    LoadingIndicatorView.hide()
                }
            }
            DispatchQueue.main.async {
                self?.nameEditTextField.text = user?.firstName
                self?.lastNameEditTextField.text = user?.lastName
                self?.currentUser = user
                self?.tempURL = user?.photo
                self?.editImageView.configureBorder()
                self?.editImageView.layoutIfNeeded()
                self?.navigationItem.rightBarButtonItem?.isEnabled = true

            }
            })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ProfileEditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, Storagable, FBProfileEditable {
    
    func edit() {
        saveProfile(withUser: currentUser) { [weak self] (title, message, action) in
            if title != "" && message != "" && action != "" {
                self?.alert(title, message: message, actionTitle: action)
            } else {
                let _ = self?.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func presentPickerViewController(_ sender: AnyObject) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.modalPresentationStyle = .overCurrentContext
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
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
            upload(selectedImage, completion: { [weak self] (title, message, action) in
                if title != "" && message != "" && action != "" {
                    self?.alert(title, message: message, actionTitle: action)
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
