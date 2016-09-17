//
//  DatabaseProtocol.swift
//  Azul Digital
//
//  Created by Leonardo Tsuda on 7/25/16.
//  Copyright © 2016 Leonardo Tsuda. All rights reserved.
//

import Foundation
import Firebase

protocol FBUpdatable {
    func saveData(withUser user: User?, withCar car: Car?, completion: @escaping (String, String, String) -> ())
}

extension FBUpdatable {
    func saveData(withUser user: User?, withCar car: Car?, completion: @escaping (String, String, String) -> ()) {
        guard  var user = user, let car = car else {
            return completion("Dados inexistente", "Dados do usuário não existem", "Tentar novamente")
        }
        
        if user.carPlate != car.plate {
            user.carPlate = car.plate
        }
        
        let userPath = "users/\(user.userID!)"
        let carPath = "cars/\(car.plate!)"
        
        let userData: [String : Any] = [
            "\(userPath)" : [
                "email" : user.email!,
                "firstName" : user.firstName!,
                "lastName" : user.lastName!,
                "photoURL" : user.photo!,
                "card" : user.card!,
                "cash" : user.cash!,
                "carPlate" : user.carPlate!,
                "isOfficer" : false
            ],
            "\(carPath)" : [
                "brand" : car.brand!,
                "model" : car.model!,
                "color" : car.color!,
                "userID" : car.userID!
            ]
        ]
        rootFBReference.updateChildValues(userData) { (error, _) in
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
    func read(_ child: String, id: String, completionObject: @escaping ((User?, Car?)) -> ())
}

extension Readable {
    func read(_ child: String, id: String, completionObject: @escaping ((User?, Car?)) -> ()) {
        var objects = (User(), Car())
        
        rootFBReference.child(child).child(id).observeSingleEvent(of: .value, with: { snapshot in
            
            if child == "users" {
                
                if let first = snapshot.childSnapshot(forPath: "firstName").value as? String,
                    let last = snapshot.childSnapshot(forPath: "lastName").value as? String,
                    let card = snapshot.childSnapshot(forPath: "card").value as? String,
                    let photo = snapshot.childSnapshot(forPath: "photoURL").value as? String,
                    let carPlate = snapshot.childSnapshot(forPath: "carPlate").value as? String,
                    let email = snapshot.childSnapshot(forPath: "email").value as? String,
                    let cash = snapshot.childSnapshot(forPath: "cash").value as? Double {
                    var user = User(userID: id, email: email, first: first, last: last, photo: photo, isOfficer: false)
                    user.carPlate = carPlate
                    user.card = card
                    user.cash = cash
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

protocol FBTicketReadable {
    func read(fromCar plate: String, completionObject: @escaping (Ticket?, Error?) -> ())
}

extension FBTicketReadable {
    func read(fromCar plate: String, completionObject: @escaping (Ticket?, Error?) -> ()) {
        
        rootFBReference.child("cars").child(plate).observe(.value, with: { snapshot in
            let tickets = snapshot.childSnapshot(forPath: "ticket")
            for ticket in tickets.children.allObjects as! [FIRDataSnapshot] {
                guard let address = ticket.childSnapshot(forPath: "address").value as? String,
                let isPaid = ticket.childSnapshot(forPath: "isPaid").value as? Bool,
                let name = ticket.childSnapshot(forPath: "name").value as? String,
                let value = ticket.childSnapshot(forPath: "value").value as? Double,
                    let timeSince1970 = ticket.childSnapshot(forPath: "timeStampSince1970").value as? Double else { return }
                guard let newTicket = Ticket(name: name, address: address, isPaid: isPaid, value: value, timeStamp: timeSince1970) else { return }
                completionObject(newTicket, nil)
            }
        }) { error in
            print(error.localizedDescription)
            completionObject(nil, error)
        }
        
    }
}

protocol FBProfileEditable {
    func saveProfile(withUser user: User?, completion: @escaping (String, String, String) -> ())
}

extension FBProfileEditable {
    func saveProfile(withUser user: User?, completion: @escaping (String, String, String) -> ()) {
        guard  let user = user, let id = user.userID else {
            return completion("Usuário inexistente", "Dados do usuário não existem", "Tentar novamente")
        }
        let userData = [
            "email" : user.email!,
            "firstName" : user.firstName!,
            "lastName" : user.lastName!,
            "photoURL" : user.photo!,
            "card" : user.card!,
            "cash" : user.cash!,
            "carPlate" : user.carPlate!,
            "isOfficer" : false
            ] as [String : Any]
        rootFBReference.child("users").child(id).updateChildValues(userData) { (error, _) in
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

protocol FBCardEditable {
    func saveCard(withUser user: User?, withID id: String, completion: @escaping (String, String, String) -> ())
}

extension FBCardEditable {
    func saveCard(withUser user: User?, withID id: String, completion: @escaping (String, String, String) -> ()) {
        guard  let user = user else {
            return completion("Usuário inexistente", "Dados do usuário não existem", "Tentar novamente")
        }
        let userData = [
            "card" : user.card!,
            "cash" : user.cash!
            ] as [String : Any]
        rootFBReference.child("users").child(id).updateChildValues(userData) { (error, _) in
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
