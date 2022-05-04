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
    func saveEvents(events: [serverEvent])
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
        let events = realm.objects(ServerEventEmbeded.self)
        var res = [EventEmbeded]()
        for event in events {
            if let actual = event.actual {
                res.append(actual)
            }
        }
        return res
    }
    
    func getEventById(Id: String) -> EventEmbeded {
        let realm = try! Realm()
        let events = realm.objects(ServerEventEmbeded.self)
        let res = events.where {
            $0.actual.id == Id
        }
        return (res.first?.actual)!
    }
    
    func saveEvents(events: [serverEvent]) {
        let realm = try! Realm()
        try! realm.write {
            let oldEvents = realm.objects(ServerEventEmbeded.self)
            realm.delete(oldEvents)
            var eventsArray = [ServerEventEmbeded]()
            for event in events {
                let actual = EventEmbeded()
                actual.author = event.actual.author
                actual.desc = event.actual.description
                actual.members = event.actual.members
                actual.id = event.actual.id
                actual.timestamp = event.actual.timestamp
                actual.title = event.actual.title
                actual.active_members = event.actual.active_members
                actual.is_regular = event.actual.is_regular
                actual.delta = event.actual.delta
                
                let meta = EventEmbeded()
                meta.author = event.meta.author
                meta.desc = event.meta.description
                meta.members = event.meta.members
                meta.id = event.meta.id
                meta.timestamp = event.meta.timestamp
                meta.title = event.meta.title
                meta.active_members = event.meta.active_members
                meta.is_regular = event.meta.is_regular
                meta.delta = event.meta.delta
                let newEvent = ServerEventEmbeded()
                newEvent.actual = actual
                newEvent.meta = meta
                eventsArray.append(newEvent)
            }
            realm.add(eventsArray)
        }
    }
    
    func getEventsInSomePeriod(from: Int64, to: Int64) -> [EventEmbeded] {
        let realm = try! Realm()
        let events = realm.objects(ServerEventEmbeded.self)
        let todayEvents = events.where {
            $0.actual.timestamp <= to && $0.actual.timestamp >= from
        }
        var res = [EventEmbeded]()
        for event in todayEvents {
            if let actual = event.actual {
                res.append(actual)
            }
        }
        return res
    }
    
    func getToken() -> String {
        return UserDefaults.standard.string(forKey: networkKeyString) ?? ""
    }
}
