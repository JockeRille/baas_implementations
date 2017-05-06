//
//  KumulosPost.swift
//  levs
//
//  Created by Rikard Olsson on 2017-05-05.
//  Copyright © 2017 Rikard Olsson. All rights reserved.
//

import Foundation

class KumulosPost {
    var ID: UInt?
    var userID: UInt?
    var title: String
    var message: String
    
    var comments: [KumulosComment]?
    
    init(ID: UInt, userID: UInt, title: String, message: String) {
        self.ID = ID
        self.userID = userID
        self.title = title
        self.message = message
    }
}
