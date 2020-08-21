//
//  Data.swift
//  Todoey
//
//  Created by Harshil Ratnu on 7/29/20.
//  Copyright © 2020 HRatnu. All rights reserved.
//

import Foundation
import RealmSwift

// Define your models like regular Swift classes
class Data : Object {
    @objc dynamic var name = ""
    @objc dynamic var age = 0
}
