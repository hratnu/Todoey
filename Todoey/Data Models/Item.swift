//
//  Item.swift
//  Todoey
//
//  Created by Harshil Ratnu on 7/31/20.
//  Copyright © 2020 HRatnu. All rights reserved.
//


import Foundation
import RealmSwift

// Define your models like regular Swift classes
class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var date: Date?
    //hte inveerse relationship
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
