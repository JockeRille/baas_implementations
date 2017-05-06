//
//  KinveyComment.swift
//  levs
//
//  Created by Rikard Olsson on 2017-05-04.
//  Copyright © 2017 Rikard Olsson. All rights reserved.
//

import Kinvey

class KinveyComment : Entity {
    
    dynamic var message: String?
    dynamic var postId: String?
    
    override class func collectionName() -> String {
        return "comments"
    }

    override func propertyMapping(_ map: Map) {
        
        super.propertyMapping(map)
        
        message <- ("message", map["message"])
        postId <- ("postId", map["postId"])
    }
    
}
