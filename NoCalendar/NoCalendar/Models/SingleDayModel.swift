//
//  SingleDayModel.swift
//  NoCalendar
//
//  Created by Александр Клонов on 01.05.2022.
//

import Foundation

class SingleDayModel {
    func getTodayEvents(day: Date) -> [EventEmbeded] {
        let startToday = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: day)!
        let endToday = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: day)!
        return DatabaseModule.shared.getEventsInSomePeriod(from: Int64(startToday.timeIntervalSince1970), to: Int64(endToday.timeIntervalSince1970))
    }
}
