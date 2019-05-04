//
//  messageCell.swift
//  social-app
//
//  Created by @unknown on 8.01.2019.
//

import UIKit

class messageCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var messageText: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        profileImage.setRounded()
        // Configure the view for the selected state
    }
    

}
