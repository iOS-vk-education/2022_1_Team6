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
    let author: String
    let activeMembers: [String]
    let isRegular: Bool
    let Delta: Int64?
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
    @Persisted var author = ""
}

struct serverEventsResponse : Codable {
    let message: String
    let events: [Event]
}
