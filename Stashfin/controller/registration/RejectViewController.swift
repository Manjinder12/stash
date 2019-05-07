//
//  RejectViewController.swift
//  StashFinDemo
//
//  Created by Macbook on 05/02/19.
//  Copyright © 2019 StashFin. All rights reserved.
//

import UIKit

class RejectViewController: BaseViewController {
    
    static func getInstance(storyboard: UIStoryboard) -> RejectViewController{
        return storyboard.instantiateViewController(withIdentifier: String(describing: self.classForCoder())) as! RejectViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="Home"
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Init
    
    // MARK: - Properties
    
    // MARK: - Handlers
}
