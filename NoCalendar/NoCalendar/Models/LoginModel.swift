import Foundation

class LoginModel {
    func validateLoginInputs(login: String, password:String) -> Bool {
        if login.count < 5 || password.count < 5 {
            return false
        }
        return true
    }
}
