//
//  EventView.swift
//  NoCalendar
//
//  Created by Александр Клонов on 02.05.2022.
//

import UIKit


class EventViewContoller: UIViewController, EventDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var dateInput: UITextField!
    @IBOutlet weak var titleInput: UITextField!
    @IBOutlet weak var desricptionField: UITextView!
    @IBOutlet weak var deltaInput: UITextField!
    
    private let eventPresenter = EventPresenter()
    private let sbNames = StoryBoardsNames()
    private let vcNames = UiControllerNames()
    
    private let deltaData = ["Никогда", "Каждый час", "Каждый день", "Каждую неделю", "Каждый месяц"]
    private var dayDate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    @IBAction func didPressAddButton(_ sender: Any) {
        print(self.dayDate)
        let members: [String] = []
        self.eventPresenter.postEvent(self.dayDate, self.titleInput.text ?? "", self.dateInput.text ?? "", self.deltaInput.text ?? "", self.desricptionField.text ?? "", members)
    }
    
    private func goToDayContoller() {
        let storyBoard : UIStoryboard = UIStoryboard(name: sbNames.day, bundle:nil)
        let resultViewController = storyBoard.instantiateViewController(withIdentifier: vcNames.day) as! SingleDayViewController
        resultViewController.modalPresentationStyle = .fullScreen
        resultViewController.setDate(newDate: self.dayDate)
        self.present(resultViewController, animated: true, completion:nil)
    }
}
