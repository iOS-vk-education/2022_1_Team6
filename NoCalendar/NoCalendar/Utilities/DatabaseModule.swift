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
    
    func saveEvents(events: [serverEvent]) {
        let realm = try! Realm()
        Swift.print("NINCE", events)
        try! realm.write {
            var eventsArray = [ServerEventEmbeded]()
            for event in events {
                let newEvent = ServerEventEmbeded()
                newEvent.actual?.author = event.actual.author
                newEvent.actual?.desc = event.actual.description
                newEvent.actual?.members = event.actual.members
                newEvent.actual?.id = event.actual.id
                newEvent.actual?.timestamp = event.actual.timestamp
                newEvent.actual?.title = event.actual.title
                newEvent.actual?.active_members = event.actual.active_members
                newEvent.actual?.is_regular = event.actual.is_regular
                newEvent.actual?.delta = event.actual.delta

                newEvent.meta?.author = event.meta.author
                newEvent.meta?.desc = event.meta.description
                newEvent.meta?.members = event.meta.members
                newEvent.meta?.id = event.meta.id
                newEvent.meta?.timestamp = event.meta.timestamp
                newEvent.meta?.title = event.meta.title
                newEvent.meta?.active_members = event.meta.active_members
                newEvent.meta?.is_regular = event.meta.is_regular
                newEvent.meta?.delta = event.meta.delta
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
