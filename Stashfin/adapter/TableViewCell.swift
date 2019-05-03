//
//  TableViewCell.swift
//  StashFinDemo
//
//  Created by Macbook on 04/02/19.
//  Copyright © 2019 StashFin. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    var message:String?
    var cellImage:UIImage?
    
    var mesageview: UITextView = {
        let textView=UITextView()
        textView.translatesAutoresizingMaskIntoConstraints=false
        return textView
    }()
    
    var cellImageview:UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints=false
        return imageView
    }()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(mesageview)
        self.addSubview(cellImageview)
        
        cellImageview.leftAnchor.constraint(equalTo: self.leftAnchor).isActive=true
        cellImageview.topAnchor.constraint(equalTo: self.topAnchor).isActive=true
        cellImageview.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive=true
        cellImageview.widthAnchor.constraint(equalToConstant: 100).isActive=true
        cellImageview.heightAnchor.constraint(equalToConstant: 100).isActive=true
        
        mesageview.leftAnchor.constraint(equalTo: self.cellImageview.rightAnchor).isActive=true
        mesageview.rightAnchor.constraint(equalTo: self.rightAnchor).isActive=true
        mesageview.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive=true
        mesageview.topAnchor.constraint(equalTo: self.topAnchor).isActive=true
        
        mesageview.isScrollEnabled = false
    }
    
    override func layoutSubviews() {
       if let message = message {
            mesageview.text=message
        }
       if let cellImage = cellImage {
            cellImageview.image = cellImage
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
