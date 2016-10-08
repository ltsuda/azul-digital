//
//  PostCellTableViewCell.swift
//  Azul Digital
//
//  Created by Leonardo Tsuda on 08/10/16.
//  Copyright © 2016 Leonardo Tsuda. All rights reserved.
//

import UIKit

class PostCellTableViewCell: UITableViewCell {

    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(post: Post) {
        addressLabel.text = post.address
        timeLabel.text = formatTime(time: post.time / 1000)
    }

}

extension PostCellTableViewCell {
    func formatTime(time: Double) -> String {
        let date = Date(timeIntervalSince1970: time)
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "pt-BR")
        dateFormatter.dateFormat = "dd/MM/YYYY HH:mm"
        return dateFormatter.string(from: date)
    }
}
