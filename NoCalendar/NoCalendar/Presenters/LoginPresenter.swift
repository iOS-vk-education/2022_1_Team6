
import Foundation

protocol LoginViewDelegate: NSObjectProtocol {
    func displayTrafficLight()
}

class LoginPresenter {
    weak private var LoginViewDelegate : TrafficLightViewDelegate?
    
    init() {
        print("Hello from presenter !")
    }
}
