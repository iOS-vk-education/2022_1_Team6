import Foundation

class LoginModel {
    private let codes = statusCodes()
    func validateLoginInputs(login: String, password:String) -> loginErrors {
        if login.count < 5 {
            return loginErrors.shortUsername
        }
        
        if password.count < 5 {
            return loginErrors.shortPassword
        }
        
        return loginErrors.noError
    }
    
    func auth(login: String, password:String, okCallback: (() -> Void)? = nil, failCallBack: ((loginErrors) -> Void)? = nil) {
        NetworkModule.shared.authorise(login: login, password: password, completion: { [] result in
            switch result {
            case .success(let user):
//                DatabaseModule.shared.saveUser(user: user)
                DispatchQueue.main.async {
                    okCallback?()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    let err = error as NSError
                    switch err.code {
                    case self.codes.notFound:
                        failCallBack?(loginErrors.noSuchUser)
                    case self.codes.badRequest:
                        failCallBack?(loginErrors.passwordMismatch)
                    default:
                        failCallBack?(loginErrors.noSuchUser)
                    }
                }
            }
        })
    }
    
    func isTokenPresent() -> Bool {
        print("check")
        if UserDefaults.standard.value(forKey: networkKeyString) != nil {
            return true
        } else {
            return false
        }
    }
}
