//
//  ApplicationStatusViewController.swift
//  StashFinDemo
//
//  Created by Macbook on 06/04/19.
//  Copyright © 2019 StashFin. All rights reserved.
//

import UIKit

class ApplicationStatusViewController: BaseViewController {

    static func getInstance(storyboard: UIStoryboard) -> ApplicationStatusViewController{
        return storyboard.instantiateViewController(withIdentifier: String(describing: self.classForCoder())) as! ApplicationStatusViewController
    }

    
    @IBOutlet weak var startTick: UIImageView!
    @IBOutlet weak var approvedTick: UIImageView!
    @IBOutlet weak var docPickupTick: UIImageView!
    @IBOutlet weak var doneTick: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showStatus()
    }
    
    private func showStatus(){
       let status = SessionManger.getInstance.getLoanStatus()
        
        switch status {
        case Constants.ApplicationStatus.APPROVED:
            approvedTick.isHidden = false
            startTick.isHidden = false
        case Constants.ApplicationStatus.DOCPICKDONE:
            doneTick.isHidden = false
            docPickupTick.isHidden = false
            approvedTick.isHidden = false
            startTick.isHidden = false
        case Constants.ApplicationStatus.DOCPICK:
            docPickupTick.isHidden = false
            approvedTick.isHidden = false
            startTick.isHidden = false
        case Constants.ApplicationStatus.START:
            startTick.isHidden = false


        default:
            break
        }
    }

}
