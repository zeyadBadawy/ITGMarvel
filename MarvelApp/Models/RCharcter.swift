//
//  RCharcter.swift
//  MarvelApp
//
//  Created by zeyad on 1/27/21.
//  Copyright © 2021 zeyad. All rights reserved.
//

import Foundation
import RealmSwift

//MARK:- Realm Model To Cache For Offline Mode

class RCharcter:Object {
    
    @objc dynamic var name:String?
    @objc dynamic var imageURl:String?
    
    convenience init(charcter:MCharcter) {
        self.init()
        let thumbnailPath = charcter.thumbnail?.path ?? ""
        let extensiton = charcter.thumbnail?.thumbnailExtension?.rawValue ?? ""
        let urlString =  "\(thumbnailPath).\(extensiton)"
        self.name = charcter.name
        self.imageURl = urlString
    }
    
}
