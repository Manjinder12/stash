//
//  KeyValueTableViewCell.swift
//  Stashfin
//
//  Created by Macbook on 02/05/19.
//  Copyright © 2019 Stashfin. All rights reserved.
//

import UIKit

class KeyValueTableViewCell: UITableViewCell {

    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var keyLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
