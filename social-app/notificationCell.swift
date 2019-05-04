//
//  notificationCell.swift
//  social-app
//
//  Created by @unknown on 15.01.2019.
//

import UIKit

class notificationCell: UITableViewCell {

    @IBOutlet weak var notificationText: UITextView!
    @IBOutlet weak var userImage: UIImageView!

    @IBOutlet weak var sImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userImage.setRounded()
        sImage.setRounded()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
