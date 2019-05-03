//
//  RootViewController.swift
//  Stashfin
//
//  Created by Macbook on 01/05/19.
//  Copyright © 2019 Stashfin. All rights reserved.
//

import UIKit

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
    
    func showLoginScreen() {
        
//        let new = UINavigationController(rootViewController: LoginViewController())                               // 1
        let new = LoginViewController.getInstance(storyboard: UIStoryboard(name: "RegistrationNew", bundle: nil))
        addChild(new)                    // 2
        new.view.frame = view.bounds                   // 3
        view.addSubview(new.view)                      // 4
        new.didMove(toParent: self)      // 5
        current.willMove(toParent: nil)  // 6
        current.view.removeFromSuperview()            // 7
        current.removeFromParent()       // 8
        current = new                                  // 9
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
