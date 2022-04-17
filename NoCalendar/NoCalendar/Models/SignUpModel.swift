//
//  SignUpModel.swift
//  NoCalendar
//
//  Created by Александр Клонов on 17.04.2022.
//

import Foundation

class SignUpModel {
    private let codes = statusCodes()
    func validateRegInputs(login: String, email: String, password:String, passwordRep:String) -> RegErrors {
        if !isValidEmail(email) {
            return RegErrors.invalidEmail
        }
        if login.count < 5 {
            return RegErrors.shortUsername
        }
        
        if password.count < 5 {
            return RegErrors.shortPassword
        }
        
        if password != passwordRep {
            return RegErrors.passwordMismatch
        }
        
        return RegErrors.noError
    }
    
    func reg(login: String, email: String, password:String, okCallback: (() -> Void)? = nil, failCallBack: ((RegErrors) -> Void)? = nil) {
        NetworkModule.shared.register(login: login, email: email, password: password, completion: { [] result in
            switch result {
            case .success(let user):
                print(user) //  TODO save data on device
                DispatchQueue.main.async {
                    okCallback?()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    let err = error as NSError
                    print(err.code)
                    switch err.code {
                    case self.codes.badRequest:
                        failCallBack?(RegErrors.userExist)
                    default:
                        failCallBack?(RegErrors.invalidEmail)
                    }
                }
            }
        })
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}
