//
//  KumulosUser.swift
//  levs
//
//  Created by Rikard Olsson on 2017-05-05.
//  Copyright © 2017 Rikard Olsson. All rights reserved.
//

import Foundation

class KumulosUser {
    var ID: UInt?
    var username: String
    var password: String?
    
    init(ID: UInt, username: String) {
        self.ID = ID
        self.username = username
    }
}
