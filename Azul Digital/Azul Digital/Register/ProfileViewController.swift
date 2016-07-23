//
//  ProfileViewController.swift
//  Azul Digital
//
//  Created by Leonardo Tsuda on 7/11/16.
//  Copyright © 2016 Leonardo Tsuda. All rights reserved.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController, alertable, CheckTextField {
    
    var imageURL: String?
    
    @IBAction func cancel(_ sender: AnyObject) {
        let user = FIRAuth.auth()?.currentUser
//        FIXME: implement this method delete(completion:) before delete user and if there's an error while deleting the image, sends the Alert and do not delete the user.
        
        delete(completion: { [weak self] (title, message, action) in
            if title != "" && message != "" && action != "" {
                self?.alert(title: title, message: message, actionTitle: action)
            }
        })
        
        user?.delete { error in
            
            if let error = error {
                self.alert(title: "\(error.code)", message: "\(error.localizedDescription)", actionTitle: "OK")
            } else {
                // Account and image from storage deleted.
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let initialViewController = storyboard.instantiateViewController(withIdentifier: "UINavigationControllerMain")
                self.present(initialViewController, animated: true, completion: nil)
            }
        }
        
    }
    @IBAction func next(_ sender: AnyObject) {
        
        checkEmpty(textfield: [nameTextField.text!, lastNameTextField.text!]) { [weak self] (title, message, action) in
            if title != "" && message != "" && action != "" {
                self?.alert(title: title, message: message, actionTitle: action)
            } else {
                self?.performSegue(withIdentifier: "CarSegue", sender: nil)
            }
        }
        
    }
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(presentPickerViewController)))
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        nameTextField.placeHolderText(in: PlaceHolder.fill(.firstName))
        lastNameTextField.placeHolderText(in: PlaceHolder.fill(.lastName))
        profileImageView.configureBorder()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "CarSegue" {
            guard let destination = segue.destinationViewController as? CarViewController else {
                return print("failed segue destination")
            }
            if imageURL == nil  {
                imageURL = ""
            }
            
            let userBasic = User(email: (FIRAuth.auth()?.currentUser?.email)!, first: nameTextField.text!, last: lastNameTextField.text!, photo: imageURL!, isOfficer: false)
            destination.user = userBasic
            
        } else {
            return print("failed segue CarSegue")
            
        }
        
    }
    
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, storage {
    func presentPickerViewController() {
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
                self.profileImageView.image = selectedImage
            }
            upload(image: selectedImage, completion: { [weak self] (title, message, action) in
                if title != "" && message != "" && action != "" {
                    self?.alert(title: title, message: message, actionTitle: action)
                } else if !title.isEmpty {
                    self?.imageURL = title
                }
            })
        }
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
