//
//  SingleDayView.swift
//  NoCalendar
//
//  Created by Александр Клонов on 01.05.2022.
//

import UIKit

class SingleDayViewController: UIViewController, SingleDayDelegate, UITableViewDataSource {
    private let singleDayPresenter = SingleDayPresenter()
    private let sbNames = StoryBoardsNames()
    private let vcNames = UiControllerNames()
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var table: UITableView!
    private var data = [singleDayTimeAndEvent]()
    
    private var date = Date()
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.singleDayPresenter.setSingleDayDelegate(delegate: self)
        self.dateFormatter.dateFormat = "d MMMM y, EEEE"
        self.table.dataSource = self
        self.table.allowsSelection = true
        self.updateLayout(with: self.view.frame.size)
        self.initData()
    }
    
    override func viewWillAppear(_ animated: Bool){
        self.setDateLabel(newDate: self.date)
        self.singleDayPresenter.getThisDayEvents(day: self.date)
    }
    
    override func shouldAutomaticallyForwardRotationMethods() -> Bool {
        return false
    }
    
    func setDate(newDate: Date) {
        self.date = newDate
    }
    
    func setEvents(events: [EventEmbeded]) {
        for event in events {
            let eventDate = Date(timeIntervalSince1970: TimeInterval(event.timestamp))
            let hour = Calendar.current.component(.hour, from: eventDate)
            if let index = self.data.firstIndex(where: {
                $0.time == "\(hour):00" || $0.time == "0\(hour):00"
                
            }) {
                self.data[index].eventName = event.title
                self.data[index].eventId = event.id
            }
        }
        print(self.data)
        self.table.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       switch tableView {
       case self.table:
           return self.data.count
        default:
          return 0
       }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.table.dequeueReusableCell(withIdentifier: "TableViewCell")
        let timeLabel = cell?.contentView.viewWithTag(1) as! UILabel
        timeLabel.text = self.data[indexPath.row].time
        let eventLabelBtn = cell?.contentView.viewWithTag(2) as! EventButton
        eventLabelBtn.setTitle(self.data[indexPath.row].eventName, for: .normal)
        eventLabelBtn.titleLabel?.font = .boldSystemFont(ofSize: 20)
        eventLabelBtn.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        eventLabelBtn.id = self.data[indexPath.row].eventId
        return cell!
    }
    
    @objc func buttonAction(sender: EventButton!) {
        if sender.id != "" {
            goToEventEditContoller(eventId: sender.id)
        }
    }
    
    @IBAction func DidPressAddButton(_ sender: Any) {
        self.goToEventContoller()
    }
    
    private func updateLayout(with size: CGSize) {
       self.table.frame = CGRect.init(origin: .zero, size: size)
    }
    
    private func initData() {
        for i in 0...23 {
            var time = ""
            if i < 10 {
                time = "0\(i):00"
            } else {
                time = "\(i):00"
            }
            let elem = singleDayTimeAndEvent(time: time, eventName: "", eventId: "")
            self.data.append(elem)
        }
    }
    
    private func setDateLabel(newDate: Date) {
        dateLabel.text = "\(self.dateFormatter.string(from: self.date))"
    }
    
    private func goToEventContoller() {
        let storyBoard : UIStoryboard = UIStoryboard(name: sbNames.event, bundle:nil)
        let resultViewController = storyBoard.instantiateViewController(withIdentifier: vcNames.event) as! EventViewContoller
        resultViewController.setDayDate(date: self.date)
        self.present(resultViewController, animated: true, completion:nil)
    }
    
    private func goToEventEditContoller(eventId: String) {
        print(eventId)
        let storyBoard : UIStoryboard = UIStoryboard(name: sbNames.event, bundle:nil)
        let resultViewController = storyBoard.instantiateViewController(withIdentifier: vcNames.event) as! EventViewContoller
        resultViewController.setDayDate(date: self.date)
        resultViewController.setEditMode(eventId: eventId)
        self.present(resultViewController, animated: true, completion:nil)
    }
}

class EventButton : UIButton {
    var id = String()
}
