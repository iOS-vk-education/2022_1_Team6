//
//  EventPresenter.swift
//  NoCalendar
//
//  Created by Александр Клонов on 02.05.2022.
//

import Foundation

protocol EventDelegate: NSObjectProtocol {
    
}

class EventPresenter {
    weak private var eventDelegate : EventDelegate?
    private let eventModel = EventModel()
    
    init() {
        print("Hello from event presenter !")
    }
    
    func setEventDelegate(delegate: EventDelegate?) {
        self.eventDelegate = delegate;
    }
}
