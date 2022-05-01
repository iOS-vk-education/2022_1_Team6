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
    func getToken() -> String
    func getEvents() -> Array<EventEmbeded>
    func saveEvents(events: Array<Event>)
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
    
    func getEvents() -> Array<EventEmbeded> {
        let realm = try! Realm()
        let events = realm.objects(EventEmbeded.self)
        return Array(events)
    }
    
    func saveEvents(events: Array<Event>) {
        let realm = try! Realm()
        try! realm.write {
            var eventsArray = [EventEmbeded]()
            for event in events {
                let newEvent = EventEmbeded()
                newEvent.author = event.author
                newEvent.desc = event.description
                newEvent.members = event.members
                newEvent.id = event.id
                newEvent.timestamp = event.timestamp
                newEvent.title = event.title
                eventsArray.append(newEvent)
            }
            realm.add(eventsArray)
        }
    }
    
    func getToken() -> String {
        return UserDefaults.standard.string(forKey: networkKeyString) ?? ""
    }
}
