//
//  PayBackViewController.swift
//  StashFinDemo
//
//  Created by Macbook on 08/04/19.
//  Copyright © 2019 StashFin. All rights reserved.
//

import UIKit

class PayBackViewController: BaseViewController {

    static func getInstance(storyboard: UIStoryboard) -> PayBackViewController{
        return storyboard.instantiateViewController(withIdentifier: String(describing: self.classForCoder())) as! PayBackViewController
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
