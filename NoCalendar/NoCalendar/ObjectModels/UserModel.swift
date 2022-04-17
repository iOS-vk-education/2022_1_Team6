//
//  UserModel.swift
//  NoCalendar
//
//  Created by Александр Клонов on 17.04.2022.
//

import Foundation

struct User : Codable {
    let name: String?
    let surname: String?
    let login: String
    let password: String?
    let email: String?
}
