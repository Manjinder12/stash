//
//  PageSwitcher.swift
//  Stashfin
//
//  Created by Macbook on 01/05/19.
//  Copyright © 2019 Stashfin. All rights reserved.
//

import UIKit
import SwiftyJSON

class PageSwitcher {
    
    static func updateRootViewController() {
        
        let status = SessionManger.getInstance.getUserLogin()
        var rootViewController : UIViewController?
        
        #if DEBUG
        print(status)
        #endif
        
        if (status == true) {
            rootViewController = UIStoryboard(name: "RegistrationNew", bundle: nil).instantiateViewController(withIdentifier: "SplashViewController") as! SplashViewController
            
        } else {
            rootViewController = UIStoryboard(name: "RegistrationNew", bundle: nil).instantiateViewController(withIdentifier: "SocialLoginViewController") as! SocialLoginViewController
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = rootViewController
        
    }
    
}
