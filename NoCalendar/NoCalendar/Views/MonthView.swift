//
//  MonthView.swift
//  NoCalendar
//
//  Created by Александр Клонов on 17.04.2022.
//

import UIKit
import FSCalendar

class MonthViewController: UIViewController, MonthViewDelegate, FSCalendarDataSource, FSCalendarDelegate {
    @IBOutlet var MonthView: UIView!
    @IBOutlet weak var Calendar: FSCalendar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func shouldAutomaticallyForwardRotationMethods() -> Bool {
        return false
    }
}
