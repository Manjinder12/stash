//
//  SocialLoginViewController.swift
//  StashFinDemo
//
//  Created by Macbook on 22/01/19.
//  Copyright © 2019 StashFin. All rights reserved.
//

import Foundation
import UIKit

class SocialLoginViewController:BaseLoginViewController{
    
    static func getInstance(storyboard: UIStoryboard) -> SocialLoginViewController{
        return storyboard.instantiateViewController(withIdentifier: String(describing: self.classForCoder())) as! SocialLoginViewController
    }
    
    @IBOutlet weak var backgroundImg: UIImageView!
    @IBAction func gmailButtonLogin(_ sender: UIButton) {
        print("gmail btn")
    }
    
    @IBAction func emailButtonLogin(_ sender: UIButton) {
        print("email btn")
//        self.changeViewController(controllerName: Constants.Controllers.REGISTRATION_LOGIN)
    }
    
    @IBAction func signInBtn(_ sender: UIButton) {
        print("sign btn")
//        self.changeViewController(controllerName: Constants.Controllers.LOGIN)
    }
    
    @IBOutlet weak var refferalCodeCheckBox: CheckBox!
    
    override func viewDidLoad() {
        print("view did load splash")
        Log( String.init(describing: self.classForCoder))
       view.sendSubviewToBack(backgroundImg)
    }
   
    
}
