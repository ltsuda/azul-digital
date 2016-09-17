//
//  HistoryTableViewController.swift
//  Azul Digital
//
//  Created by Leonardo Tsuda on 16/09/16.
//  Copyright © 2016 Leonardo Tsuda. All rights reserved.
//

import UIKit

class HistoryTableViewController: UITableViewController, Readable, FBTicketReadable {
    
    
    
    var id = String()
    var car: Car?
    var array: [Ticket]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print(id)
//        LoadingIndicatorView.show("Loading data")
//        read("users", id: id, completionObject: { [weak self] (user, car) in
//            guard let plate = car?.plate else { return }
//            self?.read(fromCar: plate, completionObject: { (ticket, error) in
//                if error != nil {
//                    print(error?.localizedDescription)
//                } else if ticket != nil {
//                   
//                }
//            })
//            })
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return array?.count ?? 10
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath)
        
        // Configure the cell...
        cell.textLabel?.text = "Hora cell \(indexPath.row)"
        cell.detailTextLabel?.text = "Address cell \(indexPath.row)"
        
        return cell
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
}
