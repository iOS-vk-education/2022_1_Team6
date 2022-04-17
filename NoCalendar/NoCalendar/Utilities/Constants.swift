//
//  Constants.swift
//  NoCalendar
//
//  Created by Александр Клонов on 17.04.2022.
//

import Foundation

enum loginErrors {
    case noError
    case shortName
    case shortPassword
    case noSuchUser
    case passwordMismatch
}


struct StoryBoardsNames {
    let login = "Main"
    let signup = "SignUp"
    let month = "Month"
    let settings = "Settings"
    let day = "Day"
    let event = "Event"
}

struct UiControllerNames {
    let login = "Login"
    let signup = "Signup"
    let month = "Month"
    let settings = "Settings"
    let day = "Day"
    let event = "Event"
}

struct statusCodes {
    let ok = 200
    let badRequest = 400
    let notFound = 404
}

