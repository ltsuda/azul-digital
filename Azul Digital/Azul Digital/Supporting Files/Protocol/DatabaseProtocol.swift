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
                completion("Código: \(error?.code)", "\(error?.localizedDescription)", "Tentar novamente")
            } else {
                completion("", "", "")
            }
        }
    }
    
}

protocol SaveCar {
    var databaseCarRef: FIRDatabaseReference { get }
    func save(car: Car?, completion: (String, String, String) -> ())
}

extension SaveCar {
    
    var databaseCarRef: FIRDatabaseReference {
        return FIRDatabase.database().reference().child("cars")
    }    
    func save(car: Car?, completion: (String, String, String) -> ()) {
        guard  let car = car else {
            return completion("Usuário inexistente", "Dados do usuário não existem", "Tentar novamente")
        }
        let carData: [String : AnyObject] = [
            "brand" : car.brand!,
            "model" : car.model!,
            "color" : car.color!
        ]
        databaseCarRef.child("\(car.plate!)").setValue(carData) { (error, _) in
            if error != nil {
                completion("Código: \(error?.code)", "\(error?.localizedDescription)", "Tentar novamente")
            } else {
                completion("", "", "")
            }
        }
    }
    
}
