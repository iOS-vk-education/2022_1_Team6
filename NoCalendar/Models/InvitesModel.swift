//
//  InvitesModel.swift
//  NoCalendar
//
//  Created by Александр Клонов on 22.05.2022.
//

import Foundation

class InvitesModel {
    private let codes = statusCodes()
    
    func getInvites(okCallback: (([Invite]) -> Void)?) {
        NetworkModule.shared.getInvites(completion: { [] result in
            switch result {
            case .success(let idArray):
                DispatchQueue.main.async {
                    print("INVITES", idArray	)
                    self.getEvents(invitesId: idArray, okCallback: okCallback)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    let err = error as NSError
                    print(err.code, "AAAAAAAAA")
                }
            }
        })
    }
    
    func getEvents(invitesId: [String], okCallback: (([Invite]) -> Void)?) {
        var eventsInvitedTo:[Invite] = []
        for id in invitesId {
            print(id)
            NetworkModule.shared.getEvent(id: id, completion: { [] result in
                switch result {
                case .success(let event):
                    let newInvite = Invite(title: event.title, author: event.author, id: event.id)
                    DispatchQueue.main.async {
                        eventsInvitedTo.append(newInvite)
                        okCallback?(eventsInvitedTo)
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        let err = error as NSError
                        print(err.code, "AAAAAAAAA")
                    }
                }
            })
        }
    }
    
    func acceptInvite(eventId: String, tablePos: IndexPath, okCallback: ((IndexPath) -> Void)?) {
        NetworkModule.shared.acceptInvite(id: eventId, completion: { [] result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    okCallback?(tablePos)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    let err = error as NSError
                    print(err.code, "AAAAAAAAA")
                }
            }
        })
    }
    
    func deleteInvite(eventId: String, tablePos: IndexPath, okCallback: ((IndexPath) -> Void)?) {
        NetworkModule.shared.deleteInvite(id: eventId, completion: { [] result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    okCallback?(tablePos)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    let err = error as NSError
                    print(err.code, "AAAAAAAAA")
                }
            }
        })
    }
}
