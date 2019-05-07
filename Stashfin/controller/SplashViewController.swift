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
        
        DispatchQueue.main.async {
//          self.changeViewController(controllerName: Constants.Controllers.APPROVED)
            
            if !SessionManger.getInstance.getAuthToken().isEmpty{
//                self.showProgress()
                    ApiClient.getLoginData(){
                        result, status in
//                    self.hideProgress()
                    switch status{
                    case .success:
                        Log(result)
                        if let json = try? JSON(data: result!){
                            if json["landing_page"].string != nil{
//                                self.dismiss(animated: true, completion: nil)
                                self.parseResonse(result: result)
                            }else{
                                self.showLandingPage()
                            }
                        }else{
                            self.showLandingPage()
                        }

                    case .errors(let errors):
                        Log(errors)
                        self.showLandingPage()
                    }
                }
            }else{
                self.showLandingPage()
            }
        }
    }
}
