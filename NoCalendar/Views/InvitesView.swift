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
        cell.backgroundColor = .orange
        cell.textLabel?.text = "Событие: " + self.data[indexPath.row].title +  " автор: " + self.data[indexPath.row].author
        cell.textLabel?.font.withSize(20)
        cell.textLabel?.textColor = .white
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {

        let editAction = UITableViewRowAction(style: .default, title: "Принять", handler: { (action, indexPath) in
            self.invitesPresenter.acceptInvite(self.data[indexPath.row].id, at: indexPath)
        })
        editAction.backgroundColor = UIColor.systemTeal

        let deleteAction = UITableViewRowAction(style: .default, title: "Отклонить", handler: { (action, indexPath) in
            self.invitesPresenter.deleteInvite(self.data[indexPath.row].id, at: indexPath)
        })
        deleteAction.backgroundColor = UIColor.purple

        return [deleteAction, editAction]
    }
    
    func addData(invites: [Invite]) {
        self.data = invites
        self.table.reloadData()
    }
    
    func deleteCell(_ at: IndexPath) {
        data.remove(at: at.row)
        table.deleteRows(at: [at], with: .fade)
    }
    
    override func shouldAutomaticallyForwardRotationMethods() -> Bool {
        return false
    }
}
