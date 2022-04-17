//
//  PostModel.swift
//  NoCalendar
//
//  Created by Александр Клонов on 17.04.2022.
//

import Foundation

struct Event : Codable {
    let id: Int
    let title: String
    let description: String
    let timestamp: Int64
    let members: [String]
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
