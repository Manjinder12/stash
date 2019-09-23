//
//  SplashViewController.swift
//  StashFinDemo
//
//  Created by Macbook on 07/04/19.
//  Copyright © 2019 StashFin. All rights reserved.
//

import UIKit
import SwiftyJSON

class SplashViewController: BaseLoginViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assignbackground()
        SessionManger.getInstance.setSalesValue(value: "")
        SessionManger.getInstance.setReferralValue(value: "")
    }
    
    func assignbackground(){
        let background = #imageLiteral(resourceName: "splash_new")
        
        var imageView : UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode =  UIView.ContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = view.center
        view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        makeServiceCall()
    }
    
    private func makeServiceCall() {
        
        guard  Utilities.isConnectedToNetwork() else {
            self.showToast("No internet connection found!")
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
                self.changeViewController(controllerName: Constants.Controllers.LOGIN)
            }
            return 
        }
        
        SessionManger.getInstance.setTester(status: false);
//        SessionManger.getInstance.setMpinActive(status: true);
        
        DispatchQueue.main.async {
//                        self.changeViewController(controllerName: Constants.Controllers.BANK_STATEMENT_SALARY)
            
            if Utilities.isMpinActive(){ AppDelegate.shared.rootViewController.showLoginScreen(mpinStatus:true)
//                self.dismiss(animated: true, completion: nil)

            }else{
                self.getLoginDataApi()
            }
        }
    }
}
