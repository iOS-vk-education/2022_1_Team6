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
        if let name = user?.name, let surname = user?.surname {
            if (name.count > 0 && surname.count > 0) {
                return (name + " " + surname, activeEventsCount)
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
                print("AAAAA")
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
        let todayPlusDay = Calendar.current.date(byAdding: .day, value: 1, to: today)!
        self.todayEvents = DatabaseModule.shared.getEventsInSomePeriod(from: Int64(today.timeIntervalSince1970), to: Int64(todayPlusDay.timeIntervalSince1970))
    }
}
