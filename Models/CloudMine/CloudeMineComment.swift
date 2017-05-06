//
//  CloudeMineComment.swift
//  levs
//
//  Created by Rikard Olsson on 2017-05-06.
//  Copyright © 2017 Rikard Olsson. All rights reserved.
//

import CloudMine

class CloudMineComment : CMObject {
    
    dynamic var message: String? = nil
    
    override init!() {
        super.init()
    }
    
    override init!(objectId theObjectId: String!) {
        super.init(objectId: theObjectId)
    }
    
    required init!(coder: NSCoder) {
        super.init(coder: coder)
        message = coder.decodeObject(forKey: "message") as? String
    }
    
    override func encode(with aCoder: NSCoder!) {
        aCoder.encode(message, forKey: "message")
    }
}
