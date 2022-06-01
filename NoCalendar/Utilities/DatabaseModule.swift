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
    func getActiveEvents() -> Array<EventEmbeded>
    func getNotAcceptedEvents() -> Array<EventEmbeded>
    func saveEvents(events: [Event])
    func getEventsInSomePeriod(from: Int64, to: Int64) -> [EventEmbeded]
    func getEventById(Id: String) -> EventEmbeded
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
    
    func getEvents() -> [EventEmbeded] {
        let realm = try! Realm()
        let events = realm.objects(EventEmbeded.self)
        var res = [EventEmbeded]()
        for event in events {
            res.append(event)
        }
        return res
    }
    
    func getActiveEvents() -> [EventEmbeded] {
        let username = self.getUser()?.login
        let realm = try! Realm()
        let events = realm.objects(EventEmbeded.self)
        var res = [EventEmbeded]()
        for event in events {
            if (event.active_members.contains(username!)) {
                res.append(event)
            }
        }
        return res
    }
    
    func getNotAcceptedEvents() -> [EventEmbeded] {
        let username = self.getUser()?.login
        let realm = try! Realm()
        let events = realm.objects(EventEmbeded.self)
        var res = [EventEmbeded]()
        for event in events {
            if (!event.active_members.contains(username!)) {
                res.append(event)
            }
        }
        return res
    }
    
    func getEventById(Id: String) -> EventEmbeded {
        let realm = try! Realm()
        let events = realm.objects(EventEmbeded.self)
        let res = events.where {
            $0.id == Id
        }
        return (res.first)!
    }
    
    func saveEvents(events: [Event]) {
        let realm = try! Realm()
        try! realm.write {
            let oldEvents = realm.objects(EventEmbeded.self)
            realm.delete(oldEvents)
            var eventsArray = [EventEmbeded]()
            for event in events {
                let actual = EventEmbeded()
                actual.author = event.author
                actual.desc = event.description
                actual.members = event.members
                actual.id = event.id
                actual.timestamp = event.timestamp
                actual.title = event.title
                actual.active_members = event.active_members
                actual.is_regular = event.is_regular
                actual.delta = event.delta
                print(actual)
                eventsArray.append(actual)
            }
            realm.add(eventsArray)
        }
    }
    
    func getEventsInSomePeriod(from: Int64, to: Int64) -> [EventEmbeded] {
        let realm = try! Realm()
        let events = realm.objects(EventEmbeded.self)
        let todayEvents = events.where {
            $0.timestamp <= to && $0.timestamp >= from
        }
        var res = [EventEmbeded]()
        for event in todayEvents {
            res.append(event)
        }
        return res
    }
    
    func getToken() -> String {
        return UserDefaults.standard.string(forKey: networkKeyString) ?? ""
    }
}
