//
//  EventPresenter.swift
//  NoCalendar
//
//  Created by Александр Клонов on 02.05.2022.
//

import Foundation

protocol EventDelegate: NSObjectProtocol {
    func invalidEvent(error: newEventErrors)
    func resetInvalidInputs()
    func eventPosted()
}

class EventPresenter {
    weak private var eventDelegate: EventDelegate?
    private let eventModel = EventModel()
    
    init() {
        print("Hello from event presenter !")
    }
    
    func setEventDelegate(delegate: EventDelegate?) {
        self.eventDelegate = delegate;
    }
    
    func postEvent(_ date: Date, _ title: String, _ time: String, _ delta: String, _ description: String, _ members: [String]) {
        self.eventModel.validateEvent(date, title, time, delta, description, members,  okCallback: self.eventValid, failCallBack: self.eventDelegate?.invalidEvent)
    }
    
    func eventValid() {
        self.eventDelegate?.resetInvalidInputs()
        self.eventModel.post(okCallback: self.eventDelegate?.eventPosted, failCallBack: self.invalid)
    }
    
    func invalid() {
        print("i am invalid")
    }
}
