//
//  Data.swift
//  TestApp
//
//  Created by Sudeepa Pal on 02/05/24.
//

import Foundation
import RealmSwift

class Person: Object {
    @objc dynamic var accountName: String = ""
    @objc dynamic var emailID: String = ""
    @objc dynamic var passWord: String = ""
}
