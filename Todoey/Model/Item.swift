//
//  Item.swift
//  Todoey
//
//  Created by paritosh on 12/04/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift
class Item : Object {
    @objc dynamic var title : String = ""
  @objc dynamic  var done: Bool = false
    @objc dynamic  var seconds: Float = 0.0
 
var parentCategory = LinkingObjects(fromType: Category.self, property: "items")

}
