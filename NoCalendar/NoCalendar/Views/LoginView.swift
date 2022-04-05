import UIKit

class LoginViewController: UIViewController, LoginViewDelegate {
    @IBOutlet var Kek: UIView!
    @IBOutlet weak var LoginButton: UIButton!
    
    private let loginPresenter = LoginPresenter()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginPresenter.setloginViewDelegate(loginDelegate: self)
    }
    
    override func shouldAutomaticallyForwardRotationMethods() -> Bool {
        return false
    }
    
    
    @IBAction func DidPressLoginButton(_ sender: Any) {
        loginPresenter.loginPressed()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppUtility.lockOrientation(.portrait)
    }
    
    func changeButton() {
        LoginButton.setTitle("kek", for: .normal)
    }
}
