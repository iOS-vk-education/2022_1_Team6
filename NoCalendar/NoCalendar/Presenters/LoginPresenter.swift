//
//  LoginPresenter.swift
//  NoCalendar
//
//  Created by Александр Клонов on 05.04.2022.
//

import Foundation

protocol LoginViewDelegate: NSObjectProtocol {
    func changeButton()
}

class LoginPresenter {
    weak private var loginViewDelegate : LoginViewDelegate?
    private let loginModel = LoginModel()
    
    init() {
        print("Hello from presenter !")
    }
    
    func setloginViewDelegate(loginDelegate: LoginViewDelegate?) {
        self.loginViewDelegate = loginDelegate;
    }
    
    func loginPressed() {
        print("lol")
        loginViewDelegate?.changeButton()
    }
}
