//
//  Elv8CheckEligibiltyViewController.swift
//  Stashfin
//
//  Created by Macbook on 31/05/19.
//  Copyright © 2019 Stashfin. All rights reserved.
//

import UIKit

class Elv8CheckEligibiltyViewController: BaseLoginViewController {
   
    static func getInstance(storyboard: UIStoryboard) -> Elv8CheckEligibiltyViewController{
        return storyboard.instantiateViewController(withIdentifier: String(describing: self.classForCoder())) as! Elv8CheckEligibiltyViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
