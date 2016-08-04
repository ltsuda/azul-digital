//
//  StorageProtocol.swift
//  Azul Digital
//
//  Created by Leonardo Tsuda on 7/22/16.
//  Copyright © 2016 Leonardo Tsuda. All rights reserved.
//

import Foundation
import Firebase

protocol Storagable {
    var storageRef: FIRStorageReference { get }
    var imageName: String { get }
    func upload(image: UIImage, completion: (String, String, String) -> ())
    func delete(completion: (String, String, String) -> ())
    func download(completion: (AnyObject, String, String) -> ())
}

extension Storagable {
    var imageName: String {
        guard let userID = FIRAuth.auth()?.currentUser?.uid else {
            return "\(arc4random_stir())"
        }
        return userID
    }
    var storageRef: FIRStorageReference {
        return FIRStorage.storage().reference().child("profile_img").child("\(imageName).jpg")
    }
    func upload(image: UIImage, completion: (String, String, String) -> ()) {
        if let imageToUpload = UIImageJPEGRepresentation(image, 0.1) {
            storageRef.put(imageToUpload, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    if let code = FIRStorageErrorCode(rawValue: (error?._code)!) {
                        switch code {
                        case .retryLimitExceeded:
                            completion("Tempo excedido: \(code.rawValue)", "O tempo para salvar a imagem excedeu", "Tentar novamente")
                        default:
                            completion("Código: \(code.rawValue)", "\(error?.localizedDescription)", "OK")
                        }
                    }
                } else {
                    if let imageURL = metadata?.downloadURL()?.absoluteString {
                        completion(imageURL, "", "")
                    }
                }
            })
        }
    }
    
    func delete(completion: (String, String, String) -> ()) {
        storageRef.delete(completion: { error in
            if error != nil {
                if let code = FIRStorageErrorCode(rawValue: (error?._code)!) {
                    switch code {
                    case .retryLimitExceeded:
                        completion("Tempo excedido: \(code.rawValue)", "O tempo para deletar a imagem excedeu", "Tentar novamente")
                    default:
                        completion("Código: \(code.rawValue)", "\(error?.localizedDescription)", "OK")
                    }
                }
            }
        })
    }
    
    func download(completion: (AnyObject, String, String) -> ()) {
        storageRef.data(withMaxSize: 500 * 1024, completion: { (data, error) in
            if error != nil {
                completion("Código: -1", "\(error?.localizedDescription)", "Tentar novamente")
            } else {
                guard let image = data else { return }
                completion(image, "", "")
            }
        })
    }
    
    
}
