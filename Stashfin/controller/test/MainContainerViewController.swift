//
//  MainContainerViewController.swift
//  StashFinDemo
//
//  Created by Macbook on 08/04/19.
//  Copyright © 2019 StashFin. All rights reserved.
//

import UIKit
import SideMenu
import SwiftyJSON

class MainContainerViewController: BaseViewController {
    
    static func getInstance(storyboard: UIStoryboard) -> MainContainerViewController{
        return storyboard.instantiateViewController(withIdentifier: String(describing: self.classForCoder())) as! MainContainerViewController
    }

    var pageType=""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSideMenu()
        switch pageType {
        case "thanku":
            self.changeViewController(controllerName: Constants.Controllers.THANK_YOU_PAGE)
        case "reject":
            self.changeViewController(controllerName: Constants.Controllers.REJECT_PAGE)
        default:
            showDashboard()
        }
    }
 
    
    private func showDashboard(){
//        if getElv8Status(){
//            self.showToast("Elv8")
//        }else{
//            self.showToast("User normal")
            //                SessionManger.getInstance.saveApplicationStatus(status: Constants.ApplicationStatus.REJECTED)
//        }
        
        DispatchQueue.main.async {
            self.showHomePage()
        }
    }
    
    private func getElv8Status() -> Bool{
        return false
    }
    
    private func setSideMenu(){
        
        let menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as! UISideMenuNavigationController
        SideMenuManager.default.menuLeftNavigationController = menuLeftNavigationController

       
        SideMenuManager.default.menuFadeStatusBar = false
        SideMenuManager.default.menuWidth = view.bounds.width*0.7

//        SideMenuManager.default.menuPushStyle = .replace
        SideMenuManager.default.menuPresentMode = .viewSlideInOut
        SideMenuManager.default.menuAnimationFadeStrength = 0.6
        
        SideMenuManager.default.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        
//        present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
//        dismiss(animated: true, completion: nil)

    }
}
