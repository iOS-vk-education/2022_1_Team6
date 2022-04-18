//
//  UserModel.swift
//  NoCalendar
//
//  Created by Александр Клонов on 17.04.2022.
//

import Foundation
import RealmSwift


struct User : Codable {
    let login: String
    let email: String
    let name: String?
    let surname: String?
    let password: String?
}


class UserEmbeded : Object {
    @Persisted var login = ""
    @Persisted var email = ""
    @Persisted var name: String?
    @Persisted var surname: String?
}
