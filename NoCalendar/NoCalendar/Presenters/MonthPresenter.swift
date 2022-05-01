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
    
    func getHeader() {
        let headerInfo = self.monthModel.getHeaderInfo()
        print(headerInfo)
        monthDelegate?.setHeader(username: headerInfo.0, active: headerInfo.1)
    }
    
    func getEvents(okCallback: (() -> Void)? = nil, failCallBack: ((loginErrors) -> Void)? = nil) {
        self.monthModel.getEvents(okCallback: self.getHeader, failCallBack: self.handleErrors)
    }
    
    func handleErrors(eventErros: EventErrors) {
        switch eventErros {
        case EventErrors.notAuthorised:
            monthDelegate?.notAuthorised()
        default:
            monthModel.useSavedData()
            self.getHeader()
        }
    }
}
