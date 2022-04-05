//
//  LoginPresenter.swift
//  NoCalendar
//
//  Created by Александр Клонов on 05.04.2022.
//

import Foundation

protocol LoginViewDelegate: NSObjectProtocol {
    func loginSuccess()
    func loginError()
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
    
    func loginPressed(login:String, password:String) {
        if (loginModel.validateLoginInputs(login: login, password: password)) {
            loginViewDelegate?.loginSuccess()
        } else {
            loginViewDelegate?.loginError()
        }
    }
}
