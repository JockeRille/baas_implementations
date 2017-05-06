//
//  FirebaseComment.swift
//  levs
//
//  Created by Rikard Olsson on 2017-05-05.
//  Copyright © 2017 Rikard Olsson. All rights reserved.
//

import Foundation

class FirebaseComment {
    var uid: String
    var message: String
    
    var post: FirebasePost
    
    init(uid: String, post: FirebasePost, message: String) {
        self.uid = uid
        self.post = post
        self.message = message
    }
}
