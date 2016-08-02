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
//        FIXME: Could have a bug here, if isImageLoaded = true but there's an error deleting the image, the user may be deleted and if we try to call deleteImage() again, it'll fail and never logout.
        if isImageLoaded == false {
            deleteUser()
        } else {
            deleteImage()
            deleteUser()
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
    var isImageLoaded = false
    
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
            guard let destination = segue.destination as? CarViewController else {
                return print("failed segue destination")
            }
            if imageURL == nil  {
                imageURL = ""
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
                self.alert(title: "\(error._code)", message: "\(error.localizedDescription)", actionTitle: "OK")
                self.isImageLoaded = false
            } else {
                // Account and image from storage deleted.
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let initialViewController = storyboard.instantiateViewController(withIdentifier: "UINavigationControllerMain")
                self.present(initialViewController, animated: true, completion: nil)
            }
        }
    }
    func deleteImage() {
        delete(completion: { [weak self] (title, message, action) in
            if title != "" && message != "" && action != "" {
                self?.alert(title: title, message: message, actionTitle: action)
            }
            })
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
