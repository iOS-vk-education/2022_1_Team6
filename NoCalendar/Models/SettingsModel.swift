//
//  SettingsModel.swift
//  NoCalendar
//
//  Created by Александр Клонов on 17.04.2022.
//

import Foundation

class SettingsModel {
    func deleteUser() {
        UserDefaults.standard.removeObject(forKey: networkKeyString)
        DatabaseModule.shared.deleteUser()
    }
    
    func getUserData(callback: (String, String?, String?)->()) {
        if let user = DatabaseModule.shared.getUser() {
            callback(user.login, user.name, user.surname)
        }
    }
}
