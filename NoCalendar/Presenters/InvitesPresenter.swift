//
//  InvitesPresenter.swift
//  NoCalendar
//
//  Created by Александр Клонов on 22.05.2022.
//

import Foundation


protocol InvitesViewDelegate: NSObjectProtocol {
    func addData(invites: [Invite])
    func deleteCell(_ at: IndexPath)
}

class InvitesPresenter {
    weak private var invitesDelegate : InvitesViewDelegate?
    private let invitesModel = InvitesModel()
    
    func setInvitesDelegate(delegate: InvitesViewDelegate?) {
        self.invitesDelegate = delegate;
    }
    
    func getInvites() {
        self.invitesModel.getInvites(okCallback: self.invitesDelegate?.addData)
    }
    
    func acceptInvite(_ inviteId: String, at: IndexPath) {
        self.invitesModel.acceptInvite(eventId: inviteId, tablePos: at, okCallback: self.invitesDelegate?.deleteCell)
    }
    
    func deleteInvite(_ inviteId: String, at: IndexPath) {
        self.invitesModel.deleteInvite(eventId: inviteId, tablePos: at, okCallback: self.invitesDelegate?.deleteCell)
    }
}
