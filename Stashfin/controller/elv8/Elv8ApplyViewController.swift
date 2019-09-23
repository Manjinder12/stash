//
//  Elv8DashBoardViewController.swift
//  Stashfin
//
//  Created by Macbook on 25/05/19.
//  Copyright © 2019 Stashfin. All rights reserved.
//

import UIKit

class Elv8ApplyViewController: BaseLoginViewController {
    
    static func getInstance(storyboard: UIStoryboard) -> Elv8ApplyViewController{
        return storyboard.instantiateViewController(withIdentifier: String(describing: self.classForCoder())) as! Elv8ApplyViewController
    }
    
    @IBOutlet weak var cardImg: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cardImg.layer.cornerRadius=10
        // Do any additional setup after loading the view.
    }
    
    @IBAction func buttonApply(_ sender: UIButton) {
        if SessionManger.getInstance.getCustomerId().isEmpty {
            self.changeViewController(controllerName:Constants.Controllers.REGISTER)
        }else{
            self.getLoginDataApi()
        }
    }
}
