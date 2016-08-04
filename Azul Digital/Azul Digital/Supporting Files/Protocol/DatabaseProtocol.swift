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
    var databaseRef: FIRDatabaseReference { get }
    func saveData(user: User?, completion: (String, String, String) -> ())
}

extension SaveUser {
    
    var databaseRef: FIRDatabaseReference {
        return FIRDatabase.database().reference().child("users")
    }
    
    func saveData(user: User?, completion: (String, String, String) -> ()) {
        guard  let user = user else {
            return completion("Usuário inexistente", "Dados do usuário não existem", "Tentar novamente")
        }
        let userData: [String : AnyObject] = [
            "email" : user.email!,
            "firstName" : user.firstName!,
            "lastName" : user.lastName!,
            "photoURL" : user.photo!,
            "card" : user.card!,
            "carPlate" : user.carPlate!,
            "isOfficer" : false
        ]
        databaseRef.child(user.userID!).setValue(userData) { (error, _) in
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
    func save(car: Car?, completion: (String, String, String) -> ())
}

extension SaveCar {
    
    var carRef: FIRDatabaseReference {
        return FIRDatabase.database().reference().child("cars")
    }
    func save(car: Car?, completion: (String, String, String) -> ()) {
        guard  let car = car else {
            return completion("Usuário inexistente", "Dados do usuário não existem", "Tentar novamente")
        }
        let carData: [String : AnyObject] = [
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
    var databaseCarRef: FIRDatabaseReference { get }
    func read(child: String, id: String, completionObject: ((User?, Car?)) -> ())
}

extension Readable {
    
    var databaseCarRef: FIRDatabaseReference {
        return FIRDatabase.database().reference()
    }
    
    func read(child: String, id: String, completionObject: ((User?, Car?)) -> ()) {
        var objects = (User(), Car())
        
        databaseCarRef.child(child).child(id).observeSingleEvent(of: .value, with: { snapshot in
            
            if child == "users" {
                if let first = snapshot.value?["firstName"] as? String,
                    let last = snapshot.value?["lastName"] as? String,
                    let card = snapshot.value?["card"] as? String,
                    let photo = snapshot.value?["photoURL"] as? String,
                    let carPlate = snapshot.value?["carPlate"] as? String {
                    var user = User(userID: "", email: "", first: first, last: last, photo: photo, isOfficer: false)
                    user.carPlate = carPlate
                    user.card = card
                    objects.0 = user
                    objects.1.plate = carPlate
                }
                
            } else if child == "cars" {
                if let brand = snapshot.value?["brand"] as? String,
                    let model = snapshot.value?["model"] as? String,
                    let color = snapshot.value?["color"] as? String,
                    let userID = snapshot.value?["userID"] as? String {
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

protocol EditableCard {
    var databaseRef: FIRDatabaseReference { get }
    func editCard(user: User?, dbUserID: String, completion: (String, String, String) -> ())
}

extension EditableCard {
    
    var databaseRef: FIRDatabaseReference {
        return FIRDatabase.database().reference().child("users")
    }
    
    func editCard(user: User?, dbUserID: String, completion: (String, String, String) -> ()) {
        guard  let user = user else {
            return completion("Usuário inexistente", "Dados do usuário não existem", "Tentar novamente")
        }
        let userData = [
            "card" : user.card!
        ]
        databaseRef.child(dbUserID).updateChildValues(userData) { (error, _) in
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
    func editCar(dbUserID: String, plate: String?, completion: (String, String, String) -> ())
}

extension EditableCar {
    
    var editCarRef: FIRDatabaseReference {
        return FIRDatabase.database().reference().child("users")
    }
    
    func editCar(dbUserID: String, plate: String?, completion: (String, String, String) -> ()) {
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
