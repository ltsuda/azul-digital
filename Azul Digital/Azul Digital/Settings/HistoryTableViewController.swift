//
//  HistoryTableViewController.swift
//  Azul Digital
//
//  Created by Leonardo Tsuda on 16/09/16.
//  Copyright © 2016 Leonardo Tsuda. All rights reserved.
//

import UIKit

class HistoryTableViewController: UITableViewController, Readable {
    
    var id = String()
    var car: Car?
    var tickets: [Ticket]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        title = Project.Localizable.Common.history.localized
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.navigationBar.barTintColor = UIColor(red: 120/255, green: 15/255, blue: 223/255, alpha: 1)
        LoadingIndicatorView.show(Project.Localizable.Common.loading_data.localized)
        getTickets()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tickets?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath) as? HistoryTableViewCell else { return UITableViewCell() }
        guard let ticket = tickets?.reversed()[indexPath.row] else { return UITableViewCell() }
        cell.configureCell(ticket: ticket)
        
        return cell
    }
    
}

extension HistoryTableViewController: FBTicketReadable, Alertable {
    
    func getTickets() {
        read("users", id: id, completionObject: { [weak self] (_, car) in
            guard let plate = car?.plate else { return }
            self?.read(fromCar: plate, completionObject: { (tickets, error) in
                if error != nil {
                    DispatchQueue.main.async {
                        LoadingIndicatorView.hide()
                        self?.alert("\(error?.code)", message: "\(error?.localizedDescription)", actionTitle: Project.Localizable.Common.try_again.localized)
                    }
                } else if tickets != nil {
                    self?.tickets = tickets
                    DispatchQueue.main.async {
                        LoadingIndicatorView.hide()
                        self?.animateTable()
                    }
                }
            })
            })
    }
    
    func animateTable() {
        tableView.reloadData()
        let cells = tableView.visibleCells
        
        let tableViewHeight = tableView.bounds.size.height
        
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: 0, y: tableViewHeight)
        }
        
        var delayCounter = 0
        for cell in cells {
            UIView.animate(withDuration: 1.0, delay: Double(delayCounter) * 0.05, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                cell.transform = CGAffineTransform.identity
                }, completion: nil)
            delayCounter += 1
        }
    }
}
