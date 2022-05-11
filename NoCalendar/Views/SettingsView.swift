//
//  SettingsView.swift
//  NoCalendar
//
//  Created by Александр Клонов on 17.04.2022.
//

import UIKit

class SettingViewController: UIViewController, SettingsViewDelegate {
    @IBOutlet var settingsView: UIView!
    @IBOutlet weak var UsernameInput: UITextField!
    @IBOutlet weak var NameInput: UITextField!
    @IBOutlet weak var SurnameInput: UITextField!

    
    private let settingsPresenter = SettingsPresenter()
    private let sbNames = StoryBoardsNames()
    private let vcNames = UiControllerNames()
    
    @IBAction func DidPressLogoutBtn(_ sender: Any) {
        self.settingsPresenter.logout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.settingsPresenter.setSettingsViewDelegate(settingsDelegate: self)
        self.settingsPresenter.getUserData()
    }
    
    
    override func shouldAutomaticallyForwardRotationMethods() -> Bool {
        return false
    }
    
    
    func goToLoginView() {
        let storyBoard : UIStoryboard = UIStoryboard(name: sbNames.login, bundle:nil)
        let resultViewController = storyBoard.instantiateViewController(withIdentifier: vcNames.login)
        resultViewController.modalPresentationStyle = .fullScreen
        self.present(resultViewController, animated: true, completion:nil)
    }
    
    func gotUserData(username: String, name: String?, surname: String?) {
        UsernameInput.text = username
        NameInput.text = name
        SurnameInput.text = surname
    }
}
