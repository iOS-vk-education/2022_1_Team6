//
//  InvitesView.swift
//  NoCalendar
//
//  Created by Александр Клонов on 22.05.2022.
//

import UIKit

class InvitesViewContoller: UIViewController, InvitesViewDelegate, UITableViewDelegate, UITableViewDataSource {
    private let invitesPresenter = InvitesPresenter()
    private let sbNames = StoryBoardsNames()
    private let vcNames = UiControllerNames()
    var data: [Invite] = []
    let cellReuseIdentifier = "inviteCell"
    
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.invitesPresenter.setInvitesDelegate(delegate: self)
        self.invitesPresenter.getInvites()
        
        self.table.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        table.delegate = self
        table.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = (self.table.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell?)!
        cell.textLabel?.text = self.data[indexPath.row].title + self.data[indexPath.row].author
        return cell
    }

    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {

        // action one
        let editAction = UITableViewRowAction(style: .default, title: "Принять", handler: { (action, indexPath) in
            print("Edit tapped")
        })
        editAction.backgroundColor = UIColor.blue

        // action two
        let deleteAction = UITableViewRowAction(style: .default, title: "Удалить", handler: { (action, indexPath) in
            print("Delete tapped")
        })
        deleteAction.backgroundColor = UIColor.red

        return [deleteAction, editAction]
    }
    
    func addData(invites: [Invite]) {
        self.data = invites
    }
    
    override func shouldAutomaticallyForwardRotationMethods() -> Bool {
        return false
    }
}
