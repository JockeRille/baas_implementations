//
//  CloudMinePost.swift
//  levs
//
//  Created by Rikard Olsson on 2017-05-05.
//  Copyright © 2017 Rikard Olsson. All rights reserved.
//

import CloudMine

class CloudMinePost : CMObject {
    
    dynamic var title: String? = nil
    dynamic var message: String? = nil
    
    dynamic var comments: [CloudMineComment]? = nil
    
    override init!() {
        super.init()
    }
    
    override init!(objectId theObjectId: String!) {
        super.init(objectId: theObjectId)
    }
    
    required init!(coder: NSCoder) {
        super.init(coder: coder)
        title  = coder.decodeObject(forKey: "title") as? String
        message = coder.decodeObject(forKey: "message") as? String
        comments = coder.decodeObject(forKey: "comments") as? [CloudMineComment]
    }
    
    override func encode(with aCoder: NSCoder!) {
        aCoder.encode(title, forKey: "title")
        aCoder.encode(message, forKey: "message")
        aCoder.encode(comments, forKey: "comments")
    }
}
