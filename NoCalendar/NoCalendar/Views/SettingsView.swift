//
//  SettingsView.swift
//  NoCalendar
//
//  Created by Александр Клонов on 17.04.2022.
//

import UIKit

class SettingViewController: UIViewController, SettingsViewDelegate {
    @IBOutlet var settingsView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("alive and kicking x3")
    }
    
    override func shouldAutomaticallyForwardRotationMethods() -> Bool {
        return false
    }
}
