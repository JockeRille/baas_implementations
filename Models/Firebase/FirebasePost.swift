//
//  FirebasePost.swift
//  levs
//
//  Created by Rikard Olsson on 2017-05-05.
//  Copyright © 2017 Rikard Olsson. All rights reserved.
//

import Foundation

class FirebasePost {
    var uid: String
    var title: String
    var message: String
    
    var comments: [FirebaseComment]?
    
    init(uid: String, title: String, message: String) {
        self.uid = uid
        self.title = title
        self.message = message
    }
}
