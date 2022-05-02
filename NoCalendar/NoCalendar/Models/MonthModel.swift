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
                print("AHAAH", eventArray)
                DatabaseModule.shared.saveEvents(events: eventArray)
                self.useSavedData()
                DispatchQueue.main.async {
                    okCallback?()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    let err = error as NSError
                    print(err.code)
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
    
    func useSavedData() {
        self.activeEvents = DatabaseModule.shared.getEvents()
        self.getTodayEvents()
    }
    
    private func getTodayEvents() {
        let today = Date()
        let todayPlusDay = Calendar.current.date(byAdding: .day, value: 1, to: today)!
        self.todayEvents = DatabaseModule.shared.getEventsInSomePeriod(from: Int64(today.timeIntervalSince1970), to: Int64(todayPlusDay.timeIntervalSince1970))
        print(self.todayEvents.count)
    }
}
