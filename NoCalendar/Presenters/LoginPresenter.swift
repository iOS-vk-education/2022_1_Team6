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
    
    func oauth(_ info : Any) {
        var name = ""
        var surname = ""
        var username = ""
        var email = ""
        for (key, value) in info as! [String: Any] {
            print(key, value)
            if (key == "screen_name") {
                username = value as! String
            }
            if (key == "last_name") {
                surname = value as! String
            }
            if (key == "first_name") {
                name = value as! String
            }
        }
        if (username == "") {
            username = surname+name
        }
        email = surname+name+"@mail.ru"
        print(name, surname, username, email)
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
        let isPresent = self.loginModel.isTokenPresent()
        print(isPresent)
        if isPresent {
            loginViewDelegate?.logged()
        }
    }
}
