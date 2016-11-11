//
//  ProfileViewController.swift
//  Azul Digital
//
//  Created by Leonardo Tsuda on 7/11/16.
//  Copyright © 2016 Leonardo Tsuda. All rights reserved.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController, Alertable, CheckTextField {
    
    var imageURL: String?
    
    @IBAction func cancel(_ sender: AnyObject) {
        deleteUser()
    }
    @IBAction func next(_ sender: AnyObject) {
        checkEmpty([nameTextField.text!, lastNameTextField.text!]) { [weak self] (title, message, action) in
            if title != "" && message != "" && action != "" {
                self?.alert(title, message: message, actionTitle: action)
            } else {
                self?.performSegue(withIdentifier: "CarSegue", sender: nil)
            }
        }
        
    }
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    var isImageLoaded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(presentPickerViewController)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
//        nameTextField.placeholder = Project.Localizable.Common.first_name.localized
//        lastNameTextField.placeholder = NSLocalizedString("lastname-profile", comment: "lastname-profile")
        DispatchQueue.main.async {
            self.profileImageView.image = UIImage(named: "localImage")
            self.profileImageView.configureBorder()
            self.profileImageView.layoutIfNeeded()
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        nameTextField.placeHolderText(in: PlaceHolder.User.FirstName)
        lastNameTextField.placeHolderText(in: PlaceHolder.User.LastName)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "CarSegue" {
            guard let destination = segue.destination as? CarViewController else {
                return print("failed segue destination")
            }
            if imageURL == nil  {
                imageURL = "localImage"
            }
            let userBasic = User(userID: (FIRAuth.auth()?.currentUser?.uid)!, email: (FIRAuth.auth()?.currentUser?.email)!, first: nameTextField.text!, last: lastNameTextField.text!, photo: imageURL!, isOfficer: false)
            destination.user = userBasic
            
        } else {
            return print("failed segue CarSegue")
            
        }
    }
    
    func deleteUser() {
        let user = FIRAuth.auth()?.currentUser
        user?.delete { error in
            if let error = error {
                self.alert("\(error._code)", message: "\(error.localizedDescription)", actionTitle: Project.Localizable.Common.ok.localized)
                self.isImageLoaded = false
            } else {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let initialViewController = storyboard.instantiateViewController(withIdentifier: "UINavigationControllerMain")
                self.present(initialViewController, animated: true, completion: nil)
            }
        }
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, Storagable {
    func presentPickerViewController() {
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
                self.profileImageView.image = selectedImage            }
            upload(selectedImage, completion: { [weak self] (title, message, action) in
                if title != "" && message != "" && action != "" {
                    self?.alert(title, message: message, actionTitle: action)
                } else if !title.isEmpty {
                    self?.imageURL = title
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
