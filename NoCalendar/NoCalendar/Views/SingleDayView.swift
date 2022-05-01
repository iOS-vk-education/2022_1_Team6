//
//  SingleDayView.swift
//  NoCalendar
//
//  Created by Александр Клонов on 01.05.2022.
//

import UIKit

class SingleDayViewController: UIViewController, SingleDayDelegate {
    private let singleDayPresenter = SingleDayPresenter()
    private let sbNames = StoryBoardsNames()
    private let vcNames = UiControllerNames()
    @IBOutlet weak var dateLabel: UILabel!
    
    private var date = Date()
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.singleDayPresenter.setSingleDayDelegate(delegate: self)
        self.dateFormatter.dateFormat = "d MMMM y, EEEE"
    }
    
    override func viewWillAppear(_ animated: Bool){
        self.setDateLabel(newDate: self.date)
    }
    
    override func shouldAutomaticallyForwardRotationMethods() -> Bool {
        return false
    }
    
    func setDate(newDate: Date) {
        self.date = newDate
    }
    
    @IBAction func DidPressAddButton(_ sender: Any) {
        self.goToEventContoller()
    }
    
    private func setDateLabel(newDate: Date) {
        dateLabel.text = "\(self.dateFormatter.string(from: self.date))"
    }
    
    private func goToEventContoller() {
        let storyBoard : UIStoryboard = UIStoryboard(name: sbNames.event, bundle:nil)
        let resultViewController = storyBoard.instantiateViewController(withIdentifier: vcNames.event)
        self.present(resultViewController, animated: true, completion:nil)
    }
}
