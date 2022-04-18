//
//  LoginPresenter.swift
//  NoCalendar
//
//  Created by Александр Клонов on 05.04.2022.
//

import Foundation

protocol LoginViewDelegate: NSObjectProtocol {
    func loginSuccess()
    func loginValidate(errorCode: loginErrors)
    func logged()
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
        let validationRes = loginModel.validateLoginInputs(login: login, password: password)
        if validationRes == loginErrors.noError {
            self.loginModel.auth(login: login, password: password, okCallback: self.loginViewDelegate?.loginSuccess, failCallBack: self.loginViewDelegate?.loginValidate)
        } else {
            loginViewDelegate?.loginValidate(errorCode: validationRes)
        }
    }
    
    func checkToken() {
        print("kek")
        if self.loginModel.isTokenPresent() {
            loginViewDelegate?.logged()
        }
    }
}
