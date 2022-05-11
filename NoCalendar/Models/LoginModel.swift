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
                DatabaseModule.shared.saveUser(user: user)
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
                        failCallBack?(loginErrors.noConnection)
                    }
                }
            }
        })
    }
    
    func regWithOauth(_ name: String, _ surname: String, _ username: String, _ email: String, _ password: String , okCallback: (() -> Void)? = nil, failCallBack: ((loginErrors) -> Void)? = nil) {
        NetworkModule.shared.register(login: username, email: email, password: password, name: name, surname: surname, completion: { [] result in
            switch result {
            case .success(let user):
                DatabaseModule.shared.saveUser(user: user)
                DispatchQueue.main.async {
                    print("REGGED")
                    okCallback?()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    let err = error as NSError
                    switch err.code {
                    case self.codes.alreadyRegister:
                        print("TRYING TO AUTH")
                        self.auth(login: username, password: password, okCallback: okCallback, failCallBack: nil)
                    default:
                        failCallBack?(loginErrors.VKError)
                    }
                }
            }
        })
    }
    
    func isTokenPresent() -> Bool {
        let token = UserDefaults.standard.string(forKey: networkKeyString)
        if token != nil {
            return true
        } else {
            return false
        }
    }
}
