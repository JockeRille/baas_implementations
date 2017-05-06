//
//  KumulosComment.swift
//  levs
//
//  Created by Rikard Olsson on 2017-05-05.
//  Copyright © 2017 Rikard Olsson. All rights reserved.
//

import Foundation

class KumulosComment {
    var ID: UInt?
    var postID: UInt?
    var userID: UInt?
    var message: String
    
    init(ID: UInt, postID: UInt, userID: UInt, message: String) {
        self.ID = ID
        self.postID = postID
        self.userID = userID
        self.message = message
    }
}
