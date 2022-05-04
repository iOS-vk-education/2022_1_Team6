//
//  SingleDayPresenter.swift
//  NoCalendar
//
//  Created by Александр Клонов on 01.05.2022.
//

import Foundation


protocol SingleDayDelegate: NSObjectProtocol {
    func setEvents(events: [EventEmbeded])
}

class SingleDayPresenter {
    weak private var singleDayDelegate : SingleDayDelegate?
    private let singleDayModel = SingleDayModel()
    
    init() {
        print("Hello from day presenter !")
    }
    
    func setSingleDayDelegate(delegate: SingleDayDelegate?) {
        self.singleDayDelegate = delegate;
    }
    
    func getThisDayEvents(day: Date) {
        let todayEvents = self.singleDayModel.getTodayEvents(day: day)
        self.singleDayDelegate?.setEvents(events: todayEvents)
    }
}
