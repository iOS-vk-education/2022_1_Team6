import Foundation

class LoginModel {
    func validateLoginInputs(login: String, password:String) -> loginErrors {
        if login.count < 5 {
            return loginErrors.shortName
        }
        
        if password.count < 5 {
            return loginErrors.shortPassword
        }
        
        return loginErrors.noError
    }
}
