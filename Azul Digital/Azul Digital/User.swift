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
    var card: Int?
    var isOfficer: Bool?
    var firstName: String?
    var lastName: String?
    var carPlate: String?
    var photo: String?
    
    init(email: String, first: String, last: String, photo: String, isOfficer: Bool) {
        self.email = email
        self.firstName = first
        self.lastName = last
        self.photo = photo
        self.isOfficer = isOfficer
    }
    
    init(card: Int) {
        self.card = card
    }
    
    init(carPlate: String) {
        self.carPlate = carPlate
    }
    
}
