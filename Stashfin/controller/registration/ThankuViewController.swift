//
//  ThankuViewController.swift
//  StashFinDemo
//
//  Created by Macbook on 05/02/19.
//  Copyright © 2019 StashFin. All rights reserved.
//


import UIKit

class ThankuViewController: BaseViewController {
    
    static func getInstance(storyboard: UIStoryboard) -> ThankuViewController{
        return storyboard.instantiateViewController(withIdentifier: String(describing: self.classForCoder())) as! ThankuViewController
    }
    
    public var emptyMsgStatus=false
    @IBOutlet weak var tankuMsgLabel: CustomUILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if emptyMsgStatus{
            tankuMsgLabel.alpha=0
        }
        
    }
    
    @IBAction func nextThankyouBtn(_ sender: UIButton) {
        exit(0)
    }
    
    // MARK: - Init
    
    // MARK: - Properties
    
    // MARK: - Handlers
}
