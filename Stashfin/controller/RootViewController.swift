//
//  RootViewController.swift
//  Stashfin
//
//  Created by Macbook on 01/05/19.
//  Copyright © 2019 Stashfin. All rights reserved.
//

import UIKit
import SDWebImage

extension AppDelegate{
    static var shared:AppDelegate{
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    var rootViewController:RootViewController{
        return window?.rootViewController as! RootViewController
    }
}

class RootViewController: UIViewController{
    private var current:UIViewController
    
    init() {
        self.current=SplashViewController()
        super.init(nibName:nil,bundle:nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        addChild(current)
        current.view.frame = view.bounds
        view.addSubview(current.view)
        current.didMove(toParent: self)
    }
    
    func showLoginScreen(mpinStatus:Bool,mode:String="") {
        
        if Utilities.isMpinActive() && mpinStatus{
            var appearance = ALAppearance()
            appearance.title = "StashFin"
            //        appearance.isSensorsEnabled = true
            AppLocker.present(with: .validate, and: appearance)
            
        }else if (mode == "create"){
            var appearance = ALAppearance()
            appearance.title = "StashFin"
            //        appearance.isSensorsEnabled = true
            AppLocker.present(with: .create, and: appearance)
            
        }else{
            let new = LoginViewController.getInstance(storyboard: UIStoryboard(name: "RegistrationNew", bundle: nil))
            addChild(new)
            new.view.frame = view.bounds
            view.addSubview(new.view)
            new.didMove(toParent: self)
            current.willMove(toParent: nil)
            current.view.removeFromSuperview()
            current.removeFromParent()
            current = new
        }
    }
    
    
    

    func switchToMainScreen() {
//        let mainViewController = MainContainerViewController()
//        let new = UINavigationController(rootViewController: mainViewController)
        let statusViewController = MainContainerViewController.getInstance(storyboard: UIStoryboard(name: "Main", bundle: nil))
        let navigationController = UINavigationController(rootViewController: statusViewController)
        animateFadeTransition(to: navigationController)
    }
    
    private func animateFadeTransition(to new: UIViewController, completion: (() -> Void)? = nil) {
        current.willMove(toParent: nil)
        addChild(new)
        
        transition(from: current, to: new, duration: 0.3, options: [.transitionCrossDissolve, .curveEaseOut], animations: {
        }) { completed in
            self.current.removeFromParent()
            new.didMove(toParent: self)
            self.current = new
            completion?()  //1
        }
    }
    
    func switchToLogout() {
        let logoutScreen = LoginViewController.getInstance(storyboard: UIStoryboard(name: "RegistrationNew", bundle: nil))

        animateDismissTransition(to: logoutScreen)
    }
    
    private func animateDismissTransition(to new: UIViewController, completion: (() -> Void)? = nil) {
        _ = CGRect(x: -view.bounds.width, y: 0, width: view.bounds.width, height: view.bounds.height)
        current.willMove(toParent: nil)
        addChild(new)
        transition(from: current, to: new, duration: 0.3, options: [], animations: {
            new.view.frame = self.view.bounds
        }) { completed in
            self.current.removeFromParent()
            new.didMove(toParent: self)
            self.current = new
            completion?()
        }
    }
    
    
    
}
