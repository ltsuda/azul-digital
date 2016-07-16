//
//  Car.swift
//  Azul Digital
//
//  Created by Leonardo Tsuda on 7/16/16.
//  Copyright © 2016 Leonardo Tsuda. All rights reserved.
//

import Foundation

struct Car {
    let plate: String
    let brand: String
    let color: String
    let model: String
    var ticket: [Ticket]?

    init(plate: String, brand: String, color: String, model: String, ticket: [Ticket]) {
        self.plate = plate
        self.brand = brand
        self.color = color
        self.model = model
        self.ticket = nil
    }



}


