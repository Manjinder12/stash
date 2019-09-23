//
//  Elv8BankDetailsViewController.swift
//  Stashfin
//
//  Created by Macbook on 31/05/19.
//  Copyright © 2019 Stashfin. All rights reserved.
//

import UIKit

class Elv8BankDetailsViewController: BaseLoginViewController {
    
    static func getInstance(storyboard: UIStoryboard) -> Elv8BankDetailsViewController{
        return storyboard.instantiateViewController(withIdentifier: String(describing: self.classForCoder())) as! Elv8BankDetailsViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func nextBtn(_ sender: UIButton) {
        self.changeViewController(controllerName: Constants.Controllers.EL_REFERENCE)
    }
    
}
