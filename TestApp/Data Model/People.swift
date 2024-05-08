//
//  People.swift
//  TestApp
//
//  Created by Sudeepa Pal on 03/05/24.
//

import Foundation
import RealmSwift


class People: Object {
    @objc dynamic var accountName: String = ""
    @objc dynamic var emailID: String = ""
    @objc dynamic var passWord: String = ""
}
