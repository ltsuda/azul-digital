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
    let userID: String
    let isPaid: Bool
    let value: Int
    let timeStamp: Int
    init(name: String, userID: String, isPaid: Bool, value: Int, timeStamp: Int){
        self.name = name
        self.userID = userID
        self.isPaid = isPaid
        self.value = value
        self.timeStamp = timeStamp
    }
}
