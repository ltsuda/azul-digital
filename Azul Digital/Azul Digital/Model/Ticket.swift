//
//  Ticket.swift
//  Azul Digital
//
//  Created by Leonardo Tsuda on 7/16/16.
//  Copyright © 2016 Leonardo Tsuda. All rights reserved.
//

import Foundation
import Firebase

struct Ticket {
    let name: String
    let address: String
    let isPaid: Bool
    let value: Double
    let timeStamp: Double
    var plate: String?
    init?(name: String, address: String, isPaid: Bool, value: Double, timeStamp: Double) {
        self.name = name
        self.address = address
        self.isPaid = isPaid
        self.value = value
        self.timeStamp = timeStamp
    }
}


extension Ticket {
    
    init?(snapshot: FIRDataSnapshot) {
        guard let snapshotValue = snapshot.value as? [String: AnyObject] else { return nil }
        guard let name = snapshotValue["name"] as? String, let address = snapshotValue["address"] as? String, let isPaid = snapshotValue["isPaid"] as? Bool, let value = snapshotValue["value"] as? Double, let timeStampSince = snapshotValue["timeStampSince1970"] as? Double, let plate = snapshot.ref.parent?.parent?.key else { return nil }
        self.name = name
        self.address = address
        self.isPaid = isPaid
        self.value = value
        self.timeStamp = timeStampSince
        self.plate = plate
    }
    
}
