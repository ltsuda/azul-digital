//
//  User.swift
//  Azul Digital
//
//  Created by Leonardo Tsuda on 7/16/16.
//  Copyright © 2016 Leonardo Tsuda. All rights reserved.
//

import Foundation

struct User {
    var email: String?
    var card: String?
    var isOfficer: Bool?
    var userID: String?
    var firstName: String?
    var lastName: String?
    var carPlate: String?
    var photo: String?
    
    init(userID: String, email: String, first: String, last: String, photo: String, isOfficer: Bool) {
        self.userID = userID
        self.email = email
        self.firstName = first
        self.lastName = last
        self.photo = photo
        self.isOfficer = isOfficer
    }
    init(card: String) {
        self.card = card
    }
    
    init(carPlate: String) {
        self.carPlate = carPlate
    }
    
}
