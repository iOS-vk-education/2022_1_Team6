import UIKit

class LoginViewController: UIViewController, LoginViewDelegate {
    @IBOutlet var LoginView: UIView!
    @IBOutlet weak var LoginButton: UIButton!
    @IBOutlet weak var LoginInput: UITextField!
    @IBOutlet weak var PasswordInput: UITextField!
    
    @IBOutlet weak var ValidationHint: UILabel!
    private let loginPresenter = LoginPresenter()

    override func viewDidLoad() {
        super.viewDidLoad()
        ValidationHint.isHidden = true
        loginPresenter.setloginViewDelegate(loginDelegate: self)
    }
    
    override func shouldAutomaticallyForwardRotationMethods() -> Bool {
        return false
    }
    
    @IBAction func DidPressLoginButton(_ sender: Any) {
        let login = LoginInput.text
        let password = PasswordInput.text
        if let log = login, let pass = password {
            loginPresenter.loginPressed(login: log, password: pass)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppUtility.lockOrientation(.portrait)
    }
    
    func loginValidate(errorCode: loginErrors) {
        switch errorCode {
        case .noError:
            self.loginSuccess()
        case .shortName:
            ValidationHint.text = "Невалидный email"
            ValidationHint.isHidden = false
        case .shortPassword:
            ValidationHint.text = "Невалидный пароль"
            ValidationHint.isHidden = false
        case .noSuchUser:
            ValidationHint.text = "Такого пользователя не существует"
            ValidationHint.isHidden = false
        case .passwordMismatch:
            ValidationHint.text = "Неверный пароль"
            ValidationHint.isHidden = false
        }

    }

    func loginSuccess() {
        ValidationHint.isHidden = true
        print("...loging")
    }
}
