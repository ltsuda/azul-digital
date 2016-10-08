//
//  Post.swift
//  Azul Digital
//
//  Created by Leonardo Tsuda on 08/10/16.
//  Copyright © 2016 Leonardo Tsuda. All rights reserved.
//

import Foundation
import Firebase

struct Post {
    let address: String
    let time: Double
    
    init?(address: String, time: Double) {
        self.address = address
        self.time = time
    }
    
}

extension Post {
    init?(snapshot: FIRDataSnapshot) {
        guard let snapshotValue = snapshot.value as? [String: AnyObject] else { return nil }
        guard let address = snapshotValue["address"] as? String, let time = snapshotValue["time"] as? Double else { return nil }
        self.address = address
        self.time = time
    }
}
