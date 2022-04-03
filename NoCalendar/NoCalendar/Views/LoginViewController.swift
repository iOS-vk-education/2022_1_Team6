//
//  ViewController.swift
//  NoCalendar
//
//  Created by Александр Клонов on 03.04.2022.
//

import UIKit

class LoginViewController: UIViewController {

    private let LoginPresenter = LoginPresenter()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppUtility.lockOrientation(.portrait)
    }
}

