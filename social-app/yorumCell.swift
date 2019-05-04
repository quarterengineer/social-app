//
//  yorumCell.swift
//  social-app
//
//  Created by @unknown on 18.12.2018.
//

import UIKit

class yorumCell: UITableViewCell {

    @IBOutlet weak var yorumText: UITextView!
    @IBOutlet weak var profileImage: UIImageView!
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
