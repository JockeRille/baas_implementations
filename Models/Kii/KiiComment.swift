//
//  Comment.swift
//  levs
//
//  Created by Rikard Olsson on 2017-05-04.
//  Copyright © 2017 Rikard Olsson. All rights reserved.
//

import Foundation

class KiiComment {
    var id: String?
    var post_id: String?
    var message: String
    var uri: String?
    
    init(message: String) {
        self.message = message
    }
    
    init(post_id: String, message: String) {
        self.post_id = post_id
        self.message = message
    }
    
    init(id: String, post_id: String, message: String, uri: String) {
        self.id = id
        self.post_id = post_id
        self.message = message
        self.uri = uri
    }
}
