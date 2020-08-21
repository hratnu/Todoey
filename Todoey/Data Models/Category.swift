//
//  Category.swift
//  Todoey
//
//  Created by Harshil Ratnu on 7/31/20.
//  Copyright © 2020 HRatnu. All rights reserved.
//

import Foundation



import Foundation
import RealmSwift

// Define your models like regular Swift classes
class Category : Object {
    @objc dynamic var name: String = ""
    @objc dynamic var bgColor: String = "#FFFFFF"
    var items = List<Item>()
}

