//
//  ProfileCell.swift
//  StashFin
//
//  Created by sachin khard on 09/09/18.
//  Copyright © 2018 StashFin. All rights reserved.
//

import UIKit

class ProfileCell: UITableViewCell {
    
    @IBOutlet weak var button: UIButton?
    @IBOutlet weak var arrowImageView: UIImageView?
    @IBOutlet weak var bgView: UIView?
    @IBOutlet weak var detailLabel: TTTAttributedLabel?

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
}
