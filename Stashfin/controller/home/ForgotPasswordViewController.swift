//
//  ForgotPasswordViewController.swift
//  StashFinDemo
//
//  Created by Macbook on 24/04/19.
//  Copyright © 2019 StashFin. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: BaseLoginViewController {
    
    @IBOutlet weak var mobileNumberField: UITextField!
    @IBOutlet weak var otpField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var changePasswordBtn: UIButton!
    @IBOutlet weak var otpViews: UIView!
    @IBOutlet weak var passwordViews: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        mobileNumberField.addTarget(self, action: #selector(checkValidNumber(field:)), for: .editingChanged)
       
    }
    
    @objc func checkValidNumber(field: UITextField){
        let MAX_LENGHT = 10
        if let text = field.text, text.count >= MAX_LENGHT {
            field.text = String(text.dropLast(text.count - MAX_LENGHT))
            return
        }
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        self.changeViewController(controllerName: Constants.Controllers.LOGIN)
    }
    
    
    @IBAction func sendOtpBtn(_ sender: UIButton) {
        if mobileNumberField.isEditBoxNotEmpty() {
            
            let params = ["mode":"generateForgotPasswordOTP","phone_no":mobileNumberField.text.isNilOrValue]
            self.showProgress()
            ApiClient.getJSONResponses(route: APIRouter.stasheasyApi(param: params)){
                result, status in
                self.hideProgress()
                switch status{
                case .success:
                    sender.isHidden = true
                    self.otpViews.isHidden=false
                    self.passwordViews.isHidden = false
                    self.changePasswordBtn.isHidden = false
                    self.mobileNumberField.isUserInteractionEnabled = false
                    self.showToast("OTP sent")
                case .errors(let errors):
                    self.showToast(errors)
                }
            }
        }
    }
    
    @IBAction func changePasswordBtn(_ sender: UIButton) {
        if mobileNumberField.isEditBoxNotEmpty() && otpField.isEditBoxNotEmpty() && passwordField.isEditBoxNotEmpty(){
            self.showProgress()
            let params = ["mode":"resetPassword","phone_no":mobileNumberField.text.isNilOrValue,"password":passwordField.text.isNilOrValue,"otp":otpField.text.isNilOrValue]
            ApiClient.getJSONResponses(route: APIRouter.stasheasyApi(param: params)){
                result, status in
                self.hideProgress()
                switch status{
                case .success:
                    self.changeViewController(controllerName: Constants.Controllers.LOGIN)
                    
                case .errors(let errors):
                    self.showToast(errors)
                }
            }
        }
    }
    
    
}
