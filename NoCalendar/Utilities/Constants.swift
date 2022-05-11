//
//  Constants.swift
//  NoCalendar
//
//  Created by Александр Клонов on 17.04.2022.
//

import Foundation

enum loginErrors {
    case noError
    case shortUsername
    case shortPassword
    case noSuchUser
    case passwordMismatch
    case noConnection
    case VKError
}

enum RegErrors {
    case noError
    case shortUsername
    case shortPassword
    case invalidEmail
    case passwordMismatch
    case userExist
    case noConnection
    case VKError
}

enum EventErrors {
    case noError
    case notAuthorised
    case noConnection
}

enum newEventErrors {
    case noError
    case noTitle
    case noDate
    case noDateAndTitle
    case badRequest
    case noRights
    case noConnection
}

struct StoryBoardsNames {
    let login = "Main"
    let signup = "SignUp"
    let month = "Month"
    let settings = "Settings"
    let day = "SingleDay"
    let event = "Event"
}

struct UiControllerNames {
    let login = "Login"
    let signup = "Signup"
    let month = "Month"
    let settings = "Settings"
    let day = "SingleDay"
    let event = "Event"
}

struct statusCodes {
    let ok = 200
    let badRequest = 400
    let noRights = 403
    let unauthorized = 401
    let notFound = 404
    let alreadyRegister = 409
}

let networkKeyString = "networkToken"

