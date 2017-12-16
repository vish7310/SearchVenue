//
//  VenuesListModel.swift
//  Testing
//
//  Created by Ravenous on 16/12/17.
//  Copyright © 2017 Ravenous. All rights reserved.
//

import UIKit

class VenuesListModel: NSObject {
    
    var id = ""
    var name = ""
    var hereNow = NSDictionary()
    var location = NSDictionary()
    var contact = NSDictionary()
    
    override init(){
        super.init()
    }
    
    init(dicData:NSDictionary) {
        
        self.id = String(describing: dicData.object(forKey: "id")as AnyObject)
        self.name = String(describing: dicData.object(forKey: "name")as AnyObject)
        self.hereNow = (dicData.object(forKey: "hereNow")as AnyObject) as! NSDictionary
        self.location = (dicData.object(forKey: "location")as AnyObject) as! NSDictionary
        self.contact = (dicData.object(forKey: "contact")as AnyObject) as! NSDictionary
    }
}
