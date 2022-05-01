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
    
    func getHeaderInfo() -> (String, Int) {
        let activeEventsCount = self.activeEvents.count
        let user = DatabaseModule.shared.getUser()
        if let name = user?.name, let surname = user?.surname {
            if (name.count > 0 && surname.count > 0) {
                return (name + " " + surname, activeEventsCount)
            } else if let login = user?.login {
                return (login, activeEventsCount)
            }
        }
        return ("Юзернейм", activeEventsCount)
    }
    
    func getEvents(okCallback: (() -> Void)? = nil, failCallBack: ((EventErrors) -> Void)? = nil) {
        print("KKEKEKEKEKE")
        NetworkModule.shared.getAllEvents(completion: { [] result in
            switch result {
            case .success(let eventArray):
                print("AZAZAAZA")
                print(eventArray, "\n\n", eventArray.count)
                DatabaseModule.shared.saveEvents(events: eventArray)
                self.useSavedData()
                DispatchQueue.main.async {
                    okCallback?()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    let err = error as NSError
                    switch err.code {
//                    case self.codes.unauthorized:
//                        failCallBack?(EventErrors.notAuthorised)
                    default:
                        failCallBack?(EventErrors.noConnection)
                    }
                }
            }
        })
    }
    
    func useSavedData() {
        self.activeEvents = DatabaseModule.shared.getEvents()
    }
}
