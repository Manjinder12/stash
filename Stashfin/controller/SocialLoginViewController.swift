//
//  SocialLoginViewController.swift
//  StashFinDemo
//
//  Created by Macbook on 22/01/19.
//  Copyright © 2019 StashFin. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class SocialLoginViewController:BaseLoginViewController{
    
    static func getInstance(storyboard: UIStoryboard) -> SocialLoginViewController{
        return storyboard.instantiateViewController(withIdentifier: String(describing: self.classForCoder())) as! SocialLoginViewController
    }
    
    @IBOutlet weak var referralCodeView: UIView!
    @IBOutlet weak var backgroundImg: UIImageView!
    @IBOutlet weak var refferalCodeCheckBox: CheckBox!
    @IBOutlet weak var referralUiView: UIView!
    @IBOutlet weak var feildAgentUiView: UIView!
    @IBOutlet weak var salesAgentFeild: UITextField!
    @IBOutlet weak var referralTextFeild: UITextField!
    
    @IBAction func referralCloseBtn(_ sender: UIButton) {
        self.referralUiView.isHidden=true
    }
    
    @IBAction func referralSubmitBtn(_ sender: UIButton) {
        self.referralUiView.isHidden=true
        //        validate_agent_code
        self.showProgress()
        let params=["mode":"referral_check","referral_code":referralTextFeild.text.isNilOrValue]
        ApiClient.getJSONResponses(route: APIRouter.androidApi(param: params)){
            result, status in
            self.hideProgress()
            switch status{
            case .success:
                Log(result)
                 SessionManger.getInstance.setReferralValue(value: self.referralTextFeild.text.isNilOrValue)
                self.changeViewController(controllerName: Constants.Controllers.REGISTRATION_LOGIN)
            case .errors(let errors):
                Log(errors)
                self.showToast("oops! I don't think that is a valid code")
            }
        }
    }
    
    @IBAction func referralCodeCheckBoxBtn(_ sender: UIButton) {
           self.referralUiView.isHidden=false
    }
    @IBAction func salesAgentClosebtn(_ sender: UIButton) {
        self.feildAgentUiView.isHidden=true
    }
    
    @IBAction func salesAgentSubmitBtn(_ sender: UIButton) {
        
        self.feildAgentUiView.isHidden=true
        self.showProgress()
        let params=["mode":"validate_agent_code","agent_code":salesAgentFeild.text.isNilOrValue]
        ApiClient.getJSONResponses(route: APIRouter.v2Api(param: params)){
            result, status in
            self.hideProgress()
            switch status{
            case .success:
                Log(result)
                SessionManger.getInstance.setSalesValue(value: self.salesAgentFeild.text.isNilOrValue)
                self.changeViewController(controllerName: Constants.Controllers.REGISTRATION_LOGIN)
            case .errors(let errors):
                Log(errors)
                self.showToast("oops! Seems like agent id is incorrect")
            }
        }
    }
    override func viewDidLoad() {
        print("view did load splash")
        Log( String.init(describing: self.classForCoder))
        SessionManger.getInstance.setSalesValue(value: "")
        SessionManger.getInstance.setReferralValue(value: "")
        //       view.sendSubviewToBack(backgroundImg)
        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        self.referralCodeView.addGestureRecognizer(lpgr)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleSinglePress))
        self.referralCodeView.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleSinglePress(gestureReconizer: UITapGestureRecognizer) {
        print("Normal tap")
         self.referralUiView.isHidden=false
        
    }
    
    //MARK: - UILongPressGestureRecognizer Action -
    @objc func handleLongPress(gestureReconizer: UILongPressGestureRecognizer) {
        if gestureReconizer.state != UIGestureRecognizer.State.ended {
            // When longPress is start or running
            Log("pressing...")
        }
        else {
            //When lognpress is finish
            self.feildAgentUiView.isHidden=false
            
        }
    }
    
}
