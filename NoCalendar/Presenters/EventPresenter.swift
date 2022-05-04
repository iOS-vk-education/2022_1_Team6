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
    func notifyOfError(error: newEventErrors)
    func fillInputsWithEvent(event: EventEmbeded, _ username: String)
}

class EventPresenter {
    weak private var eventDelegate: EventDelegate?
    private let eventModel = EventModel()
    private var editId = ""
    
    init() {
        print("Hello from event presenter !")
    }
    
    func setEventDelegate(delegate: EventDelegate?) {
        self.eventDelegate = delegate;
    }
    
    func postEvent(_ date: Date, _ title: String, _ time: String, _ delta: String, _ description: String, _ members: [String], _ editMode: String) {
        self.editId = editMode
        self.eventModel.validateEvent(date, title, time, delta, description, members,  okCallback: self.eventValid, failCallBack: self.eventDelegate?.invalidEvent)
    }
    
    func eventValid() {
        print(self.editId, "VALID")
        self.eventDelegate?.resetInvalidInputs()
        self.eventModel.post(self.editId, okCallback: self.eventDelegate?.eventPosted, failCallBack: self.eventDelegate?.notifyOfError)
    }
    
    func fillInputs(eventId: String) {
        let Event = self.eventModel.getEventById(eventId)
        self.eventDelegate?.fillInputsWithEvent(event: Event.0, Event.1)
    }
    
    func invalid() {
        print("i am invalid")
    }
}
