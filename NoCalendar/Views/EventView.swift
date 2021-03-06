//
//  EventView.swift
//  NoCalendar
//
//  Created by Александр Клонов on 02.05.2022.
//

import UIKit


class EventViewContoller: UIViewController, EventDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var dateInput: UITextField!
    @IBOutlet weak var titleInput: UITextField!
    @IBOutlet weak var desricptionField: UITextView!
    @IBOutlet weak var deltaInput: UITextField!
    @IBOutlet weak var memberTable: UITableView!
    @IBOutlet weak var newMemberInput: UITextField!
    @IBOutlet weak var AddButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var AuthorLabel: UILabel!
    @IBOutlet weak var AddNewMemberField: UIView!
    
    private let eventPresenter = EventPresenter()
    private let sbNames = StoryBoardsNames()
    private let vcNames = UiControllerNames()
    
    private let deltaData = ["Никогда", "Каждый день", "Каждую неделю", "Каждые 2 недели", "Каждый месяц"]
    private let reverseDeltaData: [Int64: String] = [
        0: "Никогда",
        3600: "Каждый час",
        86400: "Каждый день",
        604800: "Каждую неделю",
        2 * 604800: "Каждые 2 недели",
        86400 * 30: "Каждый месяц" 
    ]
    private var dayDate = Date()
    private var memberList = [String]()
    private var isEdit = false
    private var eventEditId = ""
    let cellReuseIdentifier = "cell"

    
    override func viewDidLoad() {
        super.viewDidLoad()
        AuthorLabel.isHidden = true
        self.eventPresenter.setEventDelegate(delegate: self)
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .time
        datePicker.addTarget(self, action: #selector(dateChanged(datePicker: )), for: UIControl.Event.valueChanged)
        
        datePicker.preferredDatePickerStyle = .wheels
        dateInput.inputView = datePicker
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
       view.addGestureRecognizer(tap)
        
        let deltaPicker = UIPickerView()
        deltaPicker.dataSource = self
        deltaPicker.delegate = self
        deltaInput.inputView = deltaPicker
        
        self.memberTable.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        memberTable.delegate = self
        memberTable.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isEdit {
            self.AddButton.setTitle("Изменить", for: .normal)
            self.fillInputs()
        } else {
            self.deleteButton.isHidden = true
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memberList.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = (self.memberTable.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell?)!
        cell.textLabel?.text = self.memberList[indexPath.row]
        return cell
    }

    // this method handles row deletion
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            memberList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    
    @objc func dateChanged(datePicker: UIDatePicker) {
        dateInput.text = formateDate(date: datePicker.date)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
          return deltaData[row]
      }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        deltaInput.text = deltaData[row]
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func formateDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
    
    @IBAction func DidPressCancelButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    override func shouldAutomaticallyForwardRotationMethods() -> Bool {
        return false
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        self.deltaData.count
    }
    
    func setDayDate(date: Date) {
        self.dayDate = date
    }
    
    func eventPosted() {
        self.goToDayContoller()
    }
    
    @IBAction func startEditInTitle(_ sender: Any) {
        self.titleInput.text = ""
        self.titleInput.backgroundColor = .systemBackground
    }
    
    @IBAction func startEditInDate(_ sender: Any) {
        self.dateInput.backgroundColor = .systemBackground
    }

    @IBAction func didPressDelete(_ sender: Any) {
        self.eventPresenter.deleteEvent(eventId: self.eventEditId)
    }
    
    @IBAction func didPressAddMember(_ sender: Any) {
        if let newMember = self.newMemberInput.text {
            if newMember.count > 0 {
                memberList.append(newMember)
                memberTable.reloadData()
                self.newMemberInput.text = ""
            }
        }
    }
    func invalidEvent(error: newEventErrors) {
        switch error {
        case .noTitle:
            self.titleInput.text = "Необходимо выбрать название события"
            self.titleInput.backgroundColor = .orange
        case .noDate:
            self.dateInput.text = "Необходимо выбрать время события"
            self.dateInput.backgroundColor = .orange
        default:
            self.titleInput.backgroundColor = .systemBackground
            self.dateInput.backgroundColor = .systemBackground
        }
    }
    
    func resetInvalidInputs() {
        self.titleInput.backgroundColor = .systemBackground
        self.dateInput.backgroundColor = .systemBackground
    }
    
    func notifyOfError(error: newEventErrors) {
        var alert: UIAlertController
        if error == .noRights {
            alert = UIAlertController(title: "Ошибка удаления события", message: "Недостаточно прав для совершения данного действия", preferredStyle: .alert)
        } else {
            alert = UIAlertController(title: "Ошибка создания события", message: "Cервер вернул ошибку \(error)", preferredStyle: .alert)
        }
        alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func setEditMode(eventId: String) {
        self.isEdit = true
        self.eventEditId = eventId
    }
    
    func fillInputsWithEvent(event: EventEmbeded, _ username: String) {
        self.titleInput.text = event.title
        self.dateInput.text = self.formateDate(date: Date(timeIntervalSince1970: TimeInterval(event.timestamp)))
        self.desricptionField.text = event.desc
        self.deltaInput.text = self.reverseDeltaData[event.delta]
        if (event.author != username) {
            self.deleteButton.isHidden = true
            self.AddButton.isHidden = true
            self.AuthorLabel.isHidden = false
            self.AuthorLabel.text = "Автор: " + event.author
            self.AddNewMemberField.isHidden = true
        }
        self.memberList = Array(event.active_members).filter {$0 != username}
        self.memberTable.reloadData()
    }
    
    private func fillInputs() {
        self.eventPresenter.fillInputs(eventId: self.eventEditId)
    }
    
    @IBAction func didPressAddButton(_ sender: Any) {
        self.eventPresenter.postEvent(self.dayDate, self.titleInput.text ?? "", self.dateInput.text ?? "", self.deltaInput.text ?? "", self.desricptionField.text ?? "", self.memberList, self.eventEditId)
    }
    
    private func goToDayContoller() {
        let storyBoard : UIStoryboard = UIStoryboard(name: sbNames.day, bundle:nil)
        let resultViewController = storyBoard.instantiateViewController(withIdentifier: vcNames.day) as! SingleDayViewController
        resultViewController.modalPresentationStyle = .fullScreen
        resultViewController.setDate(newDate: self.dayDate)
        self.present(resultViewController, animated: true, completion:nil)
    }
}
