//
//  kisiselMessageCell.swift
//  social-app
//
//  Created by @unknown on 9.01.2019.
//

import UIKit

class kisiselMessageCell: UITableViewCell {

    @IBOutlet weak var profilImage: UIImageView!
    @IBOutlet weak var messageText: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        profilImage.setRounded()
        // Configure the view for the selected state
    }

}
