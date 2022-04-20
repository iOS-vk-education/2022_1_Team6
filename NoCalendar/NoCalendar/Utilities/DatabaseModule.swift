//
//  DatabaseModule.swift
//  NoCalendar
//
//  Created by Александр Клонов on 18.04.2022.
//

import Foundation
import RealmSwift

protocol DatabaseDelegate {
    func saveUser(user: User)
    func deleteUser()
    func getUser() -> UserEmbeded?
}

final class DatabaseModule : DatabaseDelegate {
    private init() {}
    static let shared: DatabaseDelegate = DatabaseModule()
    
    func saveUser(user: User) {
        let realm = try! Realm()
        try! realm.write {
            let newUser = UserEmbeded()
            newUser.email = user.email
            newUser.login = user.login
            newUser.name = user.name
            newUser.surname = user.surname
            realm.add(newUser)
        }
    }
    
    func deleteUser() {
        let realm = try! Realm()
        try! realm.write {
            let user = realm.objects(UserEmbeded.self)
            realm.delete(user)
        }
    }
    
    func getUser() -> UserEmbeded? {
        let realm = try! Realm()
        let user = realm.objects(UserEmbeded.self)
        let unpackedUser = user.first
        return unpackedUser
    }
}
