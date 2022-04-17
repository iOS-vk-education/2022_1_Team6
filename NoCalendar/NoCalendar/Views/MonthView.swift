//
//  MonthView.swift
//  NoCalendar
//
//  Created by Александр Клонов on 17.04.2022.
//

import UIKit

class MonthViewController: UIViewController, MonthViewDelegate {
    @IBOutlet var MonthView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("alive and kicking x2")
    }
    
    override func shouldAutomaticallyForwardRotationMethods() -> Bool {
        return false
    }
}
