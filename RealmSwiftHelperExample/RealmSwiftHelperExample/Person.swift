//
//  Person.swift
//  RealmSwiftHelperExample
//
//  Created by ryan on 2018/10/29.
//  Copyright © 2018 bechoed. All rights reserved.
//

import Foundation
import RealmSwift

class Person: Object {
    
    @objc dynamic var id: String = ""
    @objc dynamic var name = ""
    @objc dynamic var age: Int = 0
    @objc dynamic var height = 1.75
    @objc dynamic var grade = "一年级"
    @objc dynamic var school = "龙泉小学"
 
    @objc override class func primaryKey() -> String? {
        return "id"
    }
}
