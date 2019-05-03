//
//  CheckBox.swift
//  StashFinDemo
//
//  Created by Macbook on 22/01/19.
//  Copyright © 2019 StashFin. All rights reserved.
//

import Foundation
import UIKit

class CheckBox: UIButton{
    let checkedImage=UIImage(named: "check_box")! as UIImage
    let unCheckedimage=UIImage(named: "checkoff")! as UIImage
    
    var isChecked:Bool=false{
        didSet{
            if isChecked==true{
                self.setImage(checkedImage, for: UIControl.State.normal)
            }else{
                self.setImage(unCheckedimage, for: UIControl.State.normal)
            }
        }
    }
    
    override func awakeFromNib() {
        self.addTarget(self, action:#selector(buttonClicked(sender:)), for: UIControl.Event.touchUpInside)
        self.isChecked = false
    }
    
    @objc func buttonClicked(sender:UIButton) {
        if sender==self{
            isChecked = !isChecked
        }
    }
    
}
