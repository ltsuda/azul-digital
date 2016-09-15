//
//  Constants.swift
//  Azul Digital
//
//  Created by Leonardo Tsuda on 15/09/16.
//  Copyright © 2016 Leonardo Tsuda. All rights reserved.
//

import Foundation
import Firebase

let rootFBReference = FIRDatabase.database().reference()
let ticketKey = rootFBReference.child("ticket").childByAutoId().key

