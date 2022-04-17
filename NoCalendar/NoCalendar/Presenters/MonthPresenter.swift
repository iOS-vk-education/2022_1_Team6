//
//  MonthPresenter.swift
//  NoCalendar
//
//  Created by Александр Клонов on 17.04.2022.
//

import Foundation

protocol MonthViewDelegate: NSObjectProtocol {
}

class MonthPresenter {
    weak private var monthDelegate : MonthViewDelegate?
    private let monthModel = MonthModel()
    
    init() {
        print("Hello from month presenter !")
    }
}
