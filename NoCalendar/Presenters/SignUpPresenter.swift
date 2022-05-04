//
//  SignUpPresenter.swift
//  NoCalendar
//
//  Created by Александр Клонов on 17.04.2022.
//

import Foundation

protocol SignUpViewDelegate: NSObjectProtocol {
    func regValidate(errorCode: RegErrors)
    func regSuccess()
}

class SignUpPresenter {
    weak private var signUpViewDelegate : SignUpViewDelegate?
    private let signUpModel = SignUpModel()
    
    init() {
        print("Hello from presenter signup presenter !")
    }
    
    func setsignupViewDelegate(signupDelegate: SignUpViewDelegate?) {
        self.signUpViewDelegate = signupDelegate;
    }
    
    func regPressed(login: String, email: String, password: String, passwordRepeat: String) {
        let validationRes = signUpModel.validateRegInputs(login: login, email: email, password: password, passwordRep: passwordRepeat)
        if validationRes == RegErrors.noError {
            self.signUpModel.reg(login: login, email: email, password: password, okCallback: self.signUpViewDelegate?.regSuccess, failCallBack: self.signUpViewDelegate?.regValidate)
        } else {
            signUpViewDelegate?.regValidate(errorCode: validationRes)
        }
    }
}
