//
//  SettingsPresenter.swift
//  NoCalendar
//
//  Created by Александр Клонов on 17.04.2022.
//

import Foundation

protocol SettingsViewDelegate: NSObjectProtocol {
}

class SettingsPresenter {
    weak private var settingDelegate : SettingsViewDelegate?
    private let settingsModel = SettingsModel()
    
    init() {
        print("Hello from month presenter !")
    }
}
