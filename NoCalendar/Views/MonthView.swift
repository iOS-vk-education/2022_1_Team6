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
    private var activeDates = [String]()
    private let formatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.monthPresenter.setMonthViewDelegate(monthView: self)
        self.monthPresenter.getEvents()
        self.calendar.delegate = self
        self.calendar.scrollDirection = .vertical
        self.calendar.appearance.headerDateFormat = "MMMM yyyy"
        self.calendar.locale = NSLocale.init(localeIdentifier: "ru_RU") as Locale
        self.formatter.dateFormat = "yyyy-MM-dd"
    }
    
    override func shouldAutomaticallyForwardRotationMethods() -> Bool {
        return false
    }
    
    
    func setHeader(username: String, active: Int) {
        self.header.text = """
            С возвращением, \(username),
            Сегодня у вас \(active) дел.
            """
    }
    
    func setActiveEvents(activeEventsDates: [Date]) {
        for elem in activeEventsDates {
            let dateString = self.formatter.string(from: elem)
            self.activeDates.append(dateString)
        }
        self.calendar.reloadData()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.goToDayContoller(date: date)
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let dateString = self.formatter.string(from: date)
        if self.activeDates.contains(dateString) {
            return 1
        }
        return 0
    }
    
    func notAuthorised() {
        self.goToLogin()
    }
    
    @IBAction func OnTodayButtonPressed(_ sender: Any) {
        self.goToDayContoller(date: Date())
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
