//
//  PostModel.swift
//  NoCalendar
//
//  Created by Александр Клонов on 17.04.2022.
//

import Foundation
import RealmSwift

struct Event : Codable {
    let id: String
    let title: String
    let description: String
    let timestamp: Int64
    let members: List<String>
    let active_members: List<String>
    let author: String
    let is_regular: Bool
    let delta: Int64
}


struct EventPost : Codable {
    let title: String
    let description: String
    let timestamp: Int64
    let members: [String]
    let isRegular: Bool
    let Delta: Int64?
}

struct EventPostEdit : Codable {
    let id: String
    let title: String
    let description: String
    let timestamp: Int64
    let members: [String]
    let isRegular: Bool
    let Delta: Int64?
}

struct EventAnswer: Codable {
    let message: String
    let event_id: String?
}

class EventEmbeded : Object {
    @Persisted var id = ""
    @Persisted var title = ""
    @Persisted var desc = ""
    @Persisted var timestamp: Int64 = 0
    @Persisted var members: List<String>
    @Persisted var active_members: List<String>
    @Persisted var author = ""
    @Persisted var is_regular = false
    @Persisted var delta: Int64 = 0
}

struct serverEventsResponse : Codable {
    let message: String
    let events: [Event]
}

struct serverAnswer: Codable {
    let message: String
}

struct singleDayTimeAndEvent {
    var time: String
    var eventName: String
    var eventId: String
}
