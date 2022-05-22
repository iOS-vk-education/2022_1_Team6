//
//  InvitesView.swift
//  NoCalendar
//
//  Created by Александр Клонов on 22.05.2022.
//

import UIKit

class InvitesViewContoller: UIViewController, InvitesViewDelegate {
    private let invitesPresenter = InvitesPresenter()
    private let sbNames = StoryBoardsNames()
    private let vcNames = UiControllerNames()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.invitesPresenter.setInvitesDelegate(delegate: self)
    }
    
    override func shouldAutomaticallyForwardRotationMethods() -> Bool {
        return false
    }
}
