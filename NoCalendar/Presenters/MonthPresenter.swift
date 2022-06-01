//
//  MonthPresenter.swift
//  NoCalendar
//
//  Created by Александр Клонов on 17.04.2022.
//

import Foundation

protocol MonthViewDelegate: NSObjectProtocol {
    func setHeader(username: String, active: Int)
    func notAuthorised()
    func setActiveEvents(activeEventsDates: [Date])
    func setNoAcceptedEvents(events: [Date])
}

class MonthPresenter {
    weak private var monthDelegate : MonthViewDelegate?
    private let monthModel = MonthModel()
    
    init() {
        print("Hello from month presenter !")
    }
    
    func setMonthViewDelegate(monthView: MonthViewDelegate?) {
        self.monthDelegate = monthView;
    }
    
    
    func getEvents(okCallback: (() -> Void)? = nil, failCallBack: ((loginErrors) -> Void)? = nil) {
        self.monthModel.getEvents(okCallback: self.getInfo, failCallBack: self.handleErrors)
    }
    
    func getInfo() {
        self.getHeader()
        self.getActiveEvents()
        self.getNotAcceptedEvents()
    }
    
    func getActiveEvents() {
        let activeEventsDate = self.monthModel.getActiveEvents()
        monthDelegate?.setActiveEvents(activeEventsDates: activeEventsDate)
    }
    
    func getNotAcceptedEvents() {
        let events = self.monthModel.getNotAcceptedEvents()
        monthDelegate?.setNoAcceptedEvents(events: events)
    }
    
    func getHeader() {
        let headerInfo = self.monthModel.getHeaderInfo()
        monthDelegate?.setHeader(username: headerInfo.0, active: headerInfo.1)
    }
    
    func handleErrors(eventErros: EventErrors) {
        switch eventErros {
        case EventErrors.notAuthorised:
            monthDelegate?.notAuthorised()
        default:
            monthModel.useSavedData(okCallback: self.getInfo)
        }
    }
}
