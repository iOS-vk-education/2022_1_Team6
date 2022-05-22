//
//  MonthModel.swift
//  NoCalendar
//
//  Created by Александр Клонов on 17.04.2022.
//

import Foundation

class MonthModel {
    private let codes = statusCodes()
    private var activeEvents = [EventEmbeded]()
    private var todayEvents = [EventEmbeded]()
    
    func getHeaderInfo() -> (String, Int) {
        let activeEventsCount = self.todayEvents.count
        let user = DatabaseModule.shared.getUser()
        if let name = user?.name {
            if (name.count > 0) {
                return (name, activeEventsCount)
            } else if let login = user?.login {
                return (login, activeEventsCount)
            }
        }
        return ("Юзернейм", 0)
    }
    
    func getEvents(okCallback: (() -> Void)? = nil, failCallBack: ((EventErrors) -> Void)? = nil) {
        NetworkModule.shared.getAllEvents(completion: { [] result in
            switch result {
            case .success(let eventArray):
                DatabaseModule.shared.saveEvents(events: eventArray)
                self.useSavedData()
                DispatchQueue.main.async {
                    okCallback?()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    let err = error as NSError
                    print(err.code, "AAAAAAAAA")
                    switch err.code {
                    case self.codes.unauthorized:
                        failCallBack?(EventErrors.notAuthorised)
                    default:
                        failCallBack?(EventErrors.noConnection)
                    }
                }
            }
        })
    }
    
    func useSavedData(okCallback: (() -> Void)? = nil) {
        self.activeEvents = DatabaseModule.shared.getEvents()
        self.getTodayEvents()
        okCallback?()
    }
    
    func getActiveEvents() -> [Date] {
        let today = Date()
        let todayMinusYear = Calendar.current.date(byAdding: .year, value: -1, to: today)!
        let todayPlusYear = Calendar.current.date(byAdding: .year, value: 1, to: today)!
        let events = DatabaseModule.shared.getEventsInSomePeriod(from: Int64(todayMinusYear.timeIntervalSince1970), to: Int64(todayPlusYear.timeIntervalSince1970))
        var res = [Date]()
        for event in events {
            res.append(Date(timeIntervalSince1970: TimeInterval(event.timestamp)))
        }
        return res
    }
    
    private func getTodayEvents() {
        let today = Date()
        let todayComponents = Calendar.current.dateComponents([.day, .year, .month], from: today)
        let todayBegin = Calendar.current.date(from: todayComponents)
        let todaysEnd = Calendar.current.date(bySetting: .hour, value: 23, of: today)!
        let todayPlusDay = Calendar.current.date(bySetting: .minute, value: 59, of: todaysEnd)!
        self.todayEvents = DatabaseModule.shared.getEventsInSomePeriod(from: Int64(todayBegin!.timeIntervalSince1970), to: Int64(todayPlusDay.timeIntervalSince1970))
        print(todayEvents, "TODAY")
    }
}
