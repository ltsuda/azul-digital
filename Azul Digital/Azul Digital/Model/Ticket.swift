//
//  Ticket.swift
//  Azul Digital
//
//  Created by Leonardo Tsuda on 7/16/16.
//  Copyright © 2016 Leonardo Tsuda. All rights reserved.
//

import Foundation

struct Ticket {
    let name: String
    let address: String
    let isPaid: Bool
    let value: Double
    let timeStamp: Double
    init?(name: String, address: String, isPaid: Bool, value: Double, timeStamp: Double) {
        self.name = name
        self.address = address
        self.isPaid = isPaid
        self.value = value
        self.timeStamp = timeStamp
    }
}
