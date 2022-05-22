//
//  SignUpView.swift
//  NoCalendar
//
//  Created by Александр Клонов on 17.04.2022.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate, SignUpViewDelegate {
    @IBOutlet var SignUpView: UIView!
    @IBOutlet weak var ErrorLabel: UILabel!
    @IBOutlet weak var RegBtn: UIButton!
    @IBOutlet weak var EmailInput: UITextField!
    @IBOutlet weak var LoginInput: UITextField!
    @IBOutlet weak var PasswordInput: UITextField!
    @IBOutlet weak var PasswordRepInput: UITextField!
    
    private let signupPresenter = SignUpPresenter()
    private let sbNames = StoryBoardsNames()
    private let vcNames = UiControllerNames()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ErrorLabel.isHidden = true
        signupPresenter.setsignupViewDelegate(signupDelegate: self)
        self.EmailInput.delegate = self
        self.EmailInput.tag = 0
        self.LoginInput.delegate = self
        self.LoginInput.tag = 1
        self.PasswordInput.delegate = self
        self.PasswordInput.tag = 2
        self.PasswordRepInput.delegate = self
        self.PasswordRepInput.tag = 3
        
        //Looks for single or multiple taps.
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))

        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false

        view.addGestureRecognizer(tap)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
          nextField.becomeFirstResponder()
       } else {
          textField.resignFirstResponder()
          self.DidPressRegBtn(self)
       }
       return false
    }
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func shouldAutomaticallyForwardRotationMethods() -> Bool {
        return false
    }
    
    @IBAction func DidPressRegBtn(_ sender: Any) {
        let email = EmailInput.text
        let login = LoginInput.text
        let password = PasswordInput.text
        let passwordRep = PasswordRepInput.text
        if let l = login, let p = password, let e = email, let pr = passwordRep {
            signupPresenter.regPressed(login: l, email: e, password: p, passwordRepeat: pr)
        }
    }
    
    func regValidate(errorCode: RegErrors) {
        switch errorCode {
        case .shortUsername:
            ErrorLabel.text = "Невалидный логин"
            ErrorLabel.isHidden = false
        case .shortPassword:
            ErrorLabel.text = "Невалидный пароль"
            ErrorLabel.isHidden = false
        case .passwordMismatch:
            ErrorLabel.text = "Пароли не совпадают"
            ErrorLabel.isHidden = false
        case .invalidEmail:
            ErrorLabel.text = "Невалидный email"
            ErrorLabel.isHidden = false
        case .userExist:
            ErrorLabel.text = "Такой пользователь существует"
            ErrorLabel.isHidden = false
        case .noConnection:
            ErrorLabel.text = "Нет соединения с интернетом"
            ErrorLabel.isHidden = false
        default:
            ErrorLabel.isHidden = true
        }
    }
    
    func regSuccess() {
        ErrorLabel.isHidden = true
        print("...registering")
        self.goToMonthView()
    }
    
    private func goToMonthView() {
        let storyBoard : UIStoryboard = UIStoryboard(name: sbNames.month, bundle:nil)
        let resultViewController = storyBoard.instantiateViewController(withIdentifier: vcNames.month)
        resultViewController.modalPresentationStyle = .fullScreen
        self.present(resultViewController, animated:true, completion:nil)
    }
}
