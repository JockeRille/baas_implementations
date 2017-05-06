//
//  Post.swift
//  levs
//
//  Created by Rikard Olsson on 2017-05-04.
//  Copyright © 2017 Rikard Olsson. All rights reserved.
//

import Foundation

class KiiPost {
    var id: String?
    var title: String
    var message: String
    var uri: String?
    
    var comments: [KiiComment]?
    
    init(title: String, message: String) {
        self.title = title
        self.message = message
    }
    
    init(id: String, title: String, message: String, uri: String) {
        self.id = id
        self.title = title
        self.message = message
        self.uri = uri
    }
}
