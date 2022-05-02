//
//  SingleDayPresenter.swift
//  NoCalendar
//
//  Created by Александр Клонов on 01.05.2022.
//

import Foundation


protocol SingleDayDelegate: NSObjectProtocol {
    
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
    
    func getThisDayEvents() {
        
    }
}
