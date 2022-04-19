//
//  SettingsView.swift
//  NoCalendar
//
//  Created by Александр Клонов on 17.04.2022.
//

import UIKit

class SettingViewController: UIViewController, SettingsViewDelegate {
    @IBOutlet var settingsView: UIView!

    
    @IBAction func DidPressLogoutBtn(_ sender: Any) {
        let a = UserDefaults.standard.value(forKey: networkKeyString)
        print(a)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        print("alive and kicking x3")
    }
    
    override func shouldAutomaticallyForwardRotationMethods() -> Bool {
        return false
    }
}
