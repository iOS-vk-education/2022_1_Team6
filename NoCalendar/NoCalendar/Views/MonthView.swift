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
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var header: UILabel!
    private let monthPresenter = MonthPresenter()
    private let sbNames = StoryBoardsNames()
    private let vcNames = UiControllerNames()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.monthPresenter.setMonthViewDelegate(monthView: self)
        self.monthPresenter.getEvents()
        self.calendar.delegate = self
        calendar.scrollDirection = .vertical
        calendar.appearance.headerDateFormat = "MMMM yyyy"
        calendar.locale = NSLocale.init(localeIdentifier: "ru_RU") as Locale    }
    
    override func shouldAutomaticallyForwardRotationMethods() -> Bool {
        return false
    }
    
    
    func setHeader(username: String, active: Int) {
        self.header.text = """
            С возвращением, \(username),
            Сегодня у вас \(active) дел.
            """
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print(date)
        self.goToDayContoller(date: date)
    }
    
    func notAuthorised() {
        self.goToLogin()
    }
    
    private func goToLogin() {
        let storyBoard : UIStoryboard = UIStoryboard(name: sbNames.login, bundle:nil)
        let resultViewController = storyBoard.instantiateViewController(withIdentifier: vcNames.login)
        resultViewController.modalPresentationStyle = .fullScreen
        self.present(resultViewController, animated: false, completion:nil)
    }
    
    private func goToDayContoller(date: Date) {
        let storyBoard : UIStoryboard = UIStoryboard(name: sbNames.day, bundle:nil)
        let resultViewController = storyBoard.instantiateViewController(withIdentifier: vcNames.day) as! SingleDayViewController
        resultViewController.modalPresentationStyle = .fullScreen
        resultViewController.setDate(newDate: date)
        self.present(resultViewController, animated: true, completion:nil)
    }
    
}
