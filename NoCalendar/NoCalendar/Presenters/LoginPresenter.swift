
import Foundation

class LoginPresenter {
    weak private var LoginViewDelegate : TrafficLightViewDelegate?
    
    init() {
        print("Hello from presenter !")
    }
}
