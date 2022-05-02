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

class ServerEventEmbeded: Object {
    @Persisted var meta: EventEmbeded?
    @Persisted var actual: EventEmbeded?
}

struct serverEventsResponse : Codable {
    let message: String
    let events: [serverEvent]
}

struct serverEvent: Codable {
    let meta: Event
    let actual: Event
}
