//
//  DatabaseProtocol.swift
//  Azul Digital
//
//  Created by Leonardo Tsuda on 7/25/16.
//  Copyright © 2016 Leonardo Tsuda. All rights reserved.
//

import Foundation
import Firebase

protocol SaveUser {
    var userRef: FIRDatabaseReference { get }
    func saveData(_ user: User?, completion: @escaping (String, String, String) -> ())
}

extension SaveUser {
    
    var userRef: FIRDatabaseReference {
        return FIRDatabase.database().reference().child("users")
    }
    
    func saveData(_ user: User?, completion: @escaping (String, String, String) -> ()) {
        guard  let user = user else {
            return completion("Usuário inexistente", "Dados do usuário não existem", "Tentar novamente")
        }
        let userData: [String : Any] = [
            "email" : user.email!,
            "firstName" : user.firstName!,
            "lastName" : user.lastName!,
            "photoURL" : user.photo!,
            "card" : user.card!,
            "funds" : user.funds!,
            "carPlate" : user.carPlate!,
            "isOfficer" : false
        ]
        userRef.child(user.userID!).setValue(userData) { (error, _) in
            if error != nil {
                if let code = (error as? NSError)?.code {
                    completion("Código: \(code)", "\(error?.localizedDescription)", "Tentar novamente")
                }
            } else {
                completion("", "", "")
            }
        }
    }
    
}

protocol SaveCar {
    var carRef: FIRDatabaseReference { get }
    func save(_ car: Car?, completion: @escaping (String, String, String) -> ())
}

extension SaveCar {
    
    var carRef: FIRDatabaseReference {
        return FIRDatabase.database().reference().child("cars")
    }
    func save(_ car: Car?, completion: @escaping (String, String, String) -> ()) {
        guard  let car = car else {
            return completion("Usuário inexistente", "Dados do usuário não existem", "Tentar novamente")
        }
        let carData: [String : Any] = [
            "brand" : car.brand!,
            "model" : car.model!,
            "color" : car.color!,
            "userID" : car.userID!
        ]
        carRef.child("\(car.plate!)").setValue(carData) { (error, _) in
            if error != nil {
                if let code = (error as? NSError)?.code {
                    completion("Código: \(code)", "\(error?.localizedDescription)", "Tentar novamente")
                }
            } else {
                completion("", "", "")
            }
        }
    }
}

protocol Readable {
    var readableRef: FIRDatabaseReference { get }
    func read(_ child: String, id: String, completionObject: @escaping ((User?, Car?)) -> ())
}

extension Readable {
    
    var readableRef: FIRDatabaseReference {
        return FIRDatabase.database().reference()
    }
    
    func read(_ child: String, id: String, completionObject: @escaping ((User?, Car?)) -> ()) {
        var objects = (User(), Car())
        
        readableRef.child(child).child(id).observeSingleEvent(of: .value, with: { snapshot in
            
            if child == "users" {
                
                if let first = snapshot.childSnapshot(forPath: "firstName").value as? String,
                    let last = snapshot.childSnapshot(forPath: "lastName").value as? String,
                    let card = snapshot.childSnapshot(forPath: "card").value as? String,
                    let photo = snapshot.childSnapshot(forPath: "photoURL").value as? String,
                    let carPlate = snapshot.childSnapshot(forPath: "carPlate").value as? String {
                    var user = User(userID: "", email: "", first: first, last: last, photo: photo, isOfficer: false)
                    user.carPlate = carPlate
                    user.card = card
                    objects.0 = user
                    objects.1.plate = carPlate
                }
                
            } else if child == "cars" {
                if let brand = snapshot.childSnapshot(forPath: "brand").value as? String,
                    let model = snapshot.childSnapshot(forPath: "model").value as? String,
                    let color = snapshot.childSnapshot(forPath: "color").value as? String,
                    let userID = snapshot.childSnapshot(forPath: "userID").value as? String {
                    objects.1.brand = brand
                    objects.1.model = model
                    objects.1.color = color
                    objects.1.plate = snapshot.key
                    objects.1.userID = userID
                }
                
            }
            completionObject((objects.0, objects.1))
        })
    }
}

protocol EditableProfile {
    var editProfileRef: FIRDatabaseReference { get }
    func editProfile(_ user: User?, dbUserID: String, completion: @escaping (String, String, String) -> ())
}

extension EditableProfile {
    
    var editProfileRef: FIRDatabaseReference {
        return FIRDatabase.database().reference().child("users")
    }
    
    func editProfile(_ user: User?, dbUserID: String, completion: @escaping (String, String, String) -> ()) {
        guard  let user = user else {
            return completion("Usuário inexistente", "Dados do usuário não existem", "Tentar novamente")
        }
        let userData = [
            "firstName" : user.firstName!,
            "lastName" : user.lastName!,
            "photoURL" : user.photo!
        ]
        editProfileRef.child(dbUserID).updateChildValues(userData) { (error, _) in
            if error != nil {
                if let code = (error as? NSError)?.code {
                    completion("Código: \(code)", "\(error?.localizedDescription)", "Tentar novamente")
                }
            } else {
                completion("", "", "")
            }
        }
    }
}

protocol EditableCard {
    var editCardRef: FIRDatabaseReference { get }
    func editCard(_ user: User?, dbUserID: String, completion: @escaping (String, String, String) -> ())
}

extension EditableCard {
    
    var editCardRef: FIRDatabaseReference {
        return FIRDatabase.database().reference().child("users")
    }
    
    func editCard(_ user: User?, dbUserID: String, completion: @escaping (String, String, String) -> ()) {
        guard  let user = user else {
            return completion("Usuário inexistente", "Dados do usuário não existem", "Tentar novamente")
        }
        let userData = [
            "card" : user.card!
        ]
        editCardRef.child(dbUserID).updateChildValues(userData) { (error, _) in
            if error != nil {
                if let code = (error as? NSError)?.code {
                    completion("Código: \(code)", "\(error?.localizedDescription)", "Tentar novamente")
                }
            } else {
                completion("", "", "")
            }
        }
    }
}

protocol EditableCar {
    var editCarRef: FIRDatabaseReference { get }
    func editCar(_ dbUserID: String, plate: String?, completion: @escaping (String, String, String) -> ())
}

extension EditableCar {
    
    var editCarRef: FIRDatabaseReference {
        return FIRDatabase.database().reference().child("users")
    }
    
    func editCar(_ dbUserID: String, plate: String?, completion: @escaping (String, String, String) -> ()) {
        guard  let carPlate = plate else {
            return completion("Usuário inexistente", "Dados do usuário não existem", "Tentar novamente")
        }
        let userData = [
            "carPlate" : carPlate
        ]
        editCarRef.child(dbUserID).updateChildValues(userData) { (error, _) in
            if error != nil {
                if let code = (error as? NSError)?.code {
                    completion("Código: \(code)", "\(error?.localizedDescription)", "Tentar novamente")
                }
            } else {
                completion("", "", "")
            }
        }
    }
}
