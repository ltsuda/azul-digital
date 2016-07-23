//
//  Car.swift
//  Azul Digital
//
//  Created by Leonardo Tsuda on 7/16/16.
//  Copyright © 2016 Leonardo Tsuda. All rights reserved.
//

import Foundation

struct Car {
    var plate: String?
    var brand: String?
    var color: String?
    var model: String?
    var ticket: Ticket?

    init(plate: String, brand: String, color: String, model: String) {
        self.plate = plate
        self.brand = brand
        self.color = color
        self.model = model
    }

    init(ticket: Ticket) {
        self.ticket = ticket
    }


}


