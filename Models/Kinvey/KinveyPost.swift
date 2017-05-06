//
//  KinveyPost.swift
//  levs
//
//  Created by Rikard Olsson on 2017-05-04.
//  Copyright © 2017 Rikard Olsson. All rights reserved.
//

import Kinvey

class KinveyPost : Entity {
    
    dynamic var title: String?
    dynamic var message: String?
    
    var comments: [KinveyComment]?
    
    override class func collectionName() -> String {
        return "posts"
    }
    
    override func propertyMapping(_ map: Map) {
        
        super.propertyMapping(map)
        
        title <- ("title", map["title"])
        message <- ("message", map["message"])
    }
    
}
