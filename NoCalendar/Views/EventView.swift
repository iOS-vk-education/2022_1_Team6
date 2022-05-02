//
//  EventView.swift
//  NoCalendar
//
//  Created by Александр Клонов on 02.05.2022.
//

import UIKit


class EventViewContoller: UIViewController, EventDelegate {
    private let eventPresenter = EventPresenter()
    private let sbNames = StoryBoardsNames()
    private let vcNames = UiControllerNames()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.eventPresenter.setEventDelegate(delegate: self)
    }
    
    @IBAction func DidPressCancelButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    override func shouldAutomaticallyForwardRotationMethods() -> Bool {
        return false
    }
}
