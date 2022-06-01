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

struct VKUser : Codable {
    let bdate: String?
    let bdate_visibility: Int?
    let country: Country?
    let first_name: String?
    let home_town: String?
    let id: Int?
    let last_name: String?
    let phone: String?
    let relation: String?
    let screen_name: String?
    let sex: Int?
    let status: String?
}

struct Country : Codable {
    let id: Int
    let title: String
}

