//
//  HistoryTableViewCell.swift
//  Azul Digital
//
//  Created by Leonardo Tsuda on 02/10/16.
//  Copyright © 2016 Leonardo Tsuda. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var plateLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configureCell(ticket: Ticket) {
        timeLabel.text = formatTime(time: ticket.timeStamp / 1000)
        addressLabel.text = ticket.address
        plateLabel.text = ticket.plate
    }
    
}

extension HistoryTableViewCell {
    func formatTime(time: Double) -> String {
        let date = Date(timeIntervalSince1970: time)
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "pt-BR")
        dateFormatter.dateFormat = "dd/MM/YYYY HH:mm"
        return dateFormatter.string(from: date)
    }
}
