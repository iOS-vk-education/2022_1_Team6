import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate, LoginViewDelegate {
    @IBOutlet var LoginView: UIView!
    @IBOutlet weak var LoginButton: UIButton!
    @IBOutlet weak var LoginInput: UITextField!
    @IBOutlet weak var PasswordInput: UITextField!
    
    @IBOutlet weak var ValidationHint: UILabel!
    private let loginPresenter = LoginPresenter()
    private let sbNames = StoryBoardsNames()
    private let vcNames = UiControllerNames()

    override func viewDidLoad() {
        super.viewDidLoad()
        ValidationHint.isHidden = true
        loginPresenter.setloginViewDelegate(loginDelegate: self)
        self.LoginInput.delegate = self
        self.LoginInput.tag = 0
        self.PasswordInput.delegate = self
        self.PasswordInput.tag = 1
        
        //Looks for single or multiple taps.
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))

        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false

        view.addGestureRecognizer(tap)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       // Try to find next responder
       if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
          nextField.becomeFirstResponder()
       } else {
          // Not found, so remove keyboard.
          textField.resignFirstResponder()
          self.DidPressLoginButton(self)
       }
       // Do not add a line break
       return false
    }
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppUtility.lockOrientation(.portrait)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loginPresenter.checkToken()
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
    
    func loginValidate(errorCode: loginErrors) {
        switch errorCode {
        case .shortUsername:
            ValidationHint.text = "Невалидный логин"
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
        case .noConnection:
            ValidationHint.text = "Нет соединения с интернетом"
            ValidationHint.isHidden = false
        default:
            ValidationHint.text = "Сетевая ошибка"
            ValidationHint.isHidden = false
        }
    }

    func loginSuccess() {
        ValidationHint.isHidden = true
        print("...loging")
        self.goToMonthView(isLogged: false)
    }
    
    func logged() {
        print("...logged")
        self.goToMonthView(isLogged: true)
    }
    
    private func goToMonthView(isLogged: Bool) {
        let storyBoard : UIStoryboard = UIStoryboard(name: sbNames.month, bundle:nil)
        let resultViewController = storyBoard.instantiateViewController(withIdentifier: vcNames.month)
        resultViewController.modalPresentationStyle = .fullScreen
        self.present(resultViewController, animated: !isLogged, completion:nil)
    }
}
