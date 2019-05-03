//
//  ActivateCardViewController.swift
//  StashFinDemo
//
//  Created by Macbook on 16/04/19.
//  Copyright © 2019 StashFin. All rights reserved.
//

import UIKit

class ActivateCardIntroViewController: BaseViewController {
    
    
    static func getInstance(storyboard: UIStoryboard) -> ActivateCardIntroViewController{
        return storyboard.instantiateViewController(withIdentifier: String(describing: self.classForCoder())) as! ActivateCardIntroViewController
    }
    
 
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    private func activateCard(type:String){
        
        var params = ["mode":""]
        switch type {
        case "virtual":
            params[""] = ""
        case "physical":
            params[""] = ""
        default:
            Log("no type")
        }
        
        ApiClient.getJSONResponses(route: APIRouter.stasheasyApi(param: params)){
            result, status in
            switch status{
            case .success:
                Log(result!)
            case .errors(let errors):
                self.showToast(errors)
            }
        }
    }
    
    
  
    
    
    //    private func checkCardStatus(){
    //        let params=["mode":"cardOverview"]
    //        ApiClient.getJSONResponses(route: APIRouter.stasheasyApi(param: params)){
    //            result, status in
    //            switch status{
    //            case .success:
    //                Log(result!)
    //
    //            case .errors(let errors):
    //                self.showToast(errors)
    //
    //            }
    //        }
    //    }
    
}
