//
//  SignUpPresenter.swift
//  NoCalendar
//
//  Created by Александр Клонов on 17.04.2022.
//

import Foundation

protocol SignUpViewDelegate: NSObjectProtocol {
}

class SignUpPresenter {
    weak private var signUpViewDelegae : SignUpViewDelegate?
    private let signUpModel = SignUpModel()
    
    init() {
        print("Hello from presenter signup presenter !")
    }
}
