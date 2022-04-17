//
//  SignUpView.swift
//  NoCalendar
//
//  Created by Александр Клонов on 17.04.2022.
//

import UIKit

class SignUpViewController: UIViewController, SignUpViewDelegate {
    @IBOutlet var SignUpView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("alive and kicking")
    }
    
    override func shouldAutomaticallyForwardRotationMethods() -> Bool {
        return false
    }
}
