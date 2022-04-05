import UIKit

class LoginViewController: UIViewController, LoginViewDelegate {
    @IBOutlet var Kek: UIView!
    @IBOutlet weak var LoginButton: UIButton!
    @IBOutlet weak var LoginInput: UITextField!
    @IBOutlet weak var PasswordInput: UITextField!
    
    private let loginPresenter = LoginPresenter()

    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    func loginError() {
        print("error")
    }
    func loginSuccess() {
        print("success")
    }
}
