//
//  Elv8LoanApprovedViewController.swift
//  Stashfin
//
//  Created by Macbook on 31/05/19.
//  Copyright © 2019 Stashfin. All rights reserved.
//

import UIKit

class Elv8LoanApprovedViewController: UIViewController {

    static func getInstance(storyboard: UIStoryboard) -> Elv8LoanApprovedViewController{
        return storyboard.instantiateViewController(withIdentifier: String(describing: self.classForCoder())) as! Elv8LoanApprovedViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

}
