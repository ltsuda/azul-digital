//
//  DatabaseProtocol.swift
//  Azul Digital
//
//  Created by Leonardo Tsuda on 7/25/16.
//  Copyright © 2016 Leonardo Tsuda. All rights reserved.
//

import Foundation
import Firebase

protocol FBServerTime {
    func savetime()
    func gettime(completion: @escaping (Date, String, String) -> ())
}

extension FBServerTime {
    func savetime() {
        guard let uid = FIRAuth.auth()?.currentUser?.uid else { return }
        let timePath = "timeStamps/\(uid)"
        rootFBReference.child(timePath).setValue(FIRServerValue.timestamp())
        
    }
    
    func gettime(completion: @escaping (Date, String, String) -> ()) {
        
        rootFBReference.child("timeStamps/serverTime").observeSingleEvent(of: .value, with: { snapshot in
            
            let dateFormatter = DateFormatter()
            
            if let time = snapshot.value as? TimeInterval {
                let date = Date(timeIntervalSince1970: time / 1000)
                dateFormatter.locale = Locale(identifier: "pt-BR")
                let dateString = dateFormatter.string(from: date)
                let newDate = dateFormatter.date(from: dateString)
                completion(newDate!, "", "")
            }
            
        }) { error in
            print(error)
        }
    }
}

protocol FBPostable {
    func post(withAddress: String?, completion: @escaping (String, String, String) -> ())
}

extension FBPostable {
    func post(withAddress address: String?, completion: @escaping (String, String, String) -> ()) {
        guard let address = address else {
            return completion("Dados inexistente", "Endereço não existe", "Tentar novamente")
        }
        let userData: [String : Any] = [
            "address" : address,
            "time" : FIRServerValue.timestamp()
        ]
        rootFBReference.child("posts").childByAutoId().updateChildValues(userData) { (error, _) in
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
    func read(fromCar plate: String, completionObject: @escaping ([Ticket]?, NSError?) -> ())
}

extension FBTicketReadable {
    func read(fromCar plate: String, completionObject: @escaping ([Ticket]?, NSError?) -> ()) {
        
        rootFBReference.child("cars").child(plate).child("ticket").queryOrdered(byChild: "timeStampSince1970").observe(.value, with: { snapshot in
            
            var tickets: [Ticket] = []
            
            for ticket in snapshot.children {
                guard let newTicket = Ticket(snapshot: ticket as! FIRDataSnapshot) else { return }
                tickets.append(newTicket)
            }
            
            completionObject(tickets, nil)
            
        }) { error in
            let error = error as NSError
            completionObject(nil, error)
        }
        
    }
}
protocol FBPostsReadable {
    func read(completionObject: @escaping ([Post]?, NSError?) -> ())
}

extension FBPostsReadable {
    func read(completionObject: @escaping ([Post]?, NSError?) -> ()) {
        
        rootFBReference.child("posts").queryOrdered(byChild: "time").queryLimited(toLast: 25).observe(.value, with: { snapshot in
            
            var posts: [Post] = []
            
            for post in snapshot.children {
                guard let newPost = Post(snapshot: post as! FIRDataSnapshot) else { return }
                posts.append(newPost)
            }
            completionObject(posts, nil)
            
        }) { error in
            let error = error as NSError
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
