//
//  InviteTypes.swift
//  NoCalendar
//
//  Created by Александр Клонов on 22.05.2022.
//

import Foundation


struct Invite {
    let title: String
    let author: String
    let id: String
}

struct serverInviteAnswer: Codable {
    let message: String
    let invites: [String]
}

struct serverAcceptAnswer: Codable {
    let message: String
    let event_id: String?
}
