//
//  SettingsPresenter.swift
//  NoCalendar
//
//  Created by Александр Клонов on 17.04.2022.
//

import Foundation
import SwiftyVK

protocol SettingsViewDelegate: NSObjectProtocol {
    func goToLoginView()
    func gotUserData(username: String, name: String?, surname: String?)
}

class SettingsPresenter {
    weak private var settingDelegate : SettingsViewDelegate?
    private let settingsModel = SettingsModel()
    
    init() {
        print("Hello from month presenter !")
    }
    
    func setSettingsViewDelegate(settingsDelegate: SettingsViewDelegate?) {
        self.settingDelegate = settingsDelegate;
    }
    
    func logout() {
        self.settingsModel.deleteUser()
        VK.sessions.default.logOut()
        self.settingDelegate?.goToLoginView()
    }
    
    func getUserData() {
        self.settingsModel.getUserData(callback: self.settingDelegate!.gotUserData)
    }
}
