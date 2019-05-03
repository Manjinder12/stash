
//
//  RegisterLoginViewController.swift
//  StashFinDemo
//
//  Created by Macbook on 22/01/19.
//  Copyright © 2019 StashFin. All rights reserved.
//

import Foundation
import UIKit


class RegisterLoginViewController :BaseLoginViewController,UITextFieldDelegate{
    
    static func getInstance(storyboard: UIStoryboard) -> RegisterLoginViewController{
        return storyboard.instantiateViewController(withIdentifier: String(describing: self.classForCoder())) as! RegisterLoginViewController
    }

    
    @IBOutlet weak var backgroundImg: UIImageView!
    @IBOutlet weak var mobileNumberBox: UITextField!
    @IBOutlet weak var otpBox: UITextField!
    @IBOutlet weak var otpStack: UIStackView!
    
    
    var mobileNumber:String = ""
    let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        mobileNumberBox.addTarget(self, action: #selector(checkValidNumber(field:)), for: .editingChanged)
        otpBox.addTarget(self, action: #selector(checkValidOtp(field:)), for: .editingChanged)
        view.sendSubviewToBack(backgroundImg)
        otpBox.isSecureTextEntry.toggle()
        otpStack.alpha=0
    }
    
    @objc func checkValidOtp(field: UITextField){
        let MAX_LENGHT = 6
        if let text = field.text, text.count >= MAX_LENGHT {
            field.text = String(text.dropLast(text.count - MAX_LENGHT))
            return
        }
    }
    
    @objc func checkValidNumber(field: UITextField){
        let MAX_LENGHT = 10
        if let text = field.text, text.count >= MAX_LENGHT {
            field.text = String(text.dropLast(text.count - MAX_LENGHT))
            return
        }
        if Utilities.isPhoneNumberValid(value: field.text.isNilOrValue) {
            otpStack.alpha=1
        }else{
            otpStack.alpha=0
            otpBox.text=""
            otpBox.placeholder=""
        }
    }
    
    @IBAction func nextNutton(_ sender: UIButton) {

        if mobileNumberBox.isEditBoxNotEmpty() {
            if mobileNumberBox.text != "1111111111"{
                if otpBox.isEditBoxNotEmpty(){
                    let params:[String:String] = ["mode":Constants.Modes.VERIFY_OTP_REGISTRATION,"otp":otpBox.text.isNilOrValue,"phone_number":mobileNumberBox.text.isNilOrValue]
                    ApiClient.getJSONResponses(route: APIRouter.v2Api(param: params)){
                        result, code in
                        switch code{
                        case .success:
                            SessionManger.getInstance.setRegistrationPage(page: Constants.Controllers.SegueController.Personal.rawValue)
                           
                           self.personalData = self.mobileNumberBox.text.isNilOrValue
                            self.changeViewController(controllerName:Constants.Controllers.REGISTER)
//                           let controller = RegisterViewController.getInstance(storyboard: self.storyBoardRegister)
                            
//                           controller.mobileNumber = self.mobileNumbers
//                            self.goToNextViewController(controller: controller)
                        case .errors(let error):
                            self.showToast(error)
                        }
                    }
                }
            }else{
//                self.showToast("sucessfully  personal api")
//                self.view.makeToast("sucessfully  personal api")
                self.changeViewController(controllerName:Constants.Controllers.REGISTER)
            }
        }
    }
    
    @IBAction func bacBtn(_ sender: UIButton) {
        onBackPressed()
    }
    
    @IBAction func ty(_ sender: UIButton) {
        
        
        if mobileNumberBox.isEditBoxNotEmpty()  {
            mobileNumber = mobileNumberBox.text.isNilOrValue
            if mobileNumber.count == 10{
                let param = ["mode":Constants.Modes.SEND_OTP_REGISTRATION,"phone_number":mobileNumber]
                self.showProgress()
                ApiClient.getJSONResponses(route: APIRouter.v2Api(param: param)){
                    result, code in
                    self.hideProgress()
                    switch code{
                    case .success:
                        self.otpStack.alpha=1
                        self.otpBox.text=""
                        self.showToast("OTP sent")
                        print("success otp")
                    case .errors(let error):
                        self.showToast(error)
                        print("error \(error)")
                    }
                }
            }else{
                self.showToast("Mobile number not valid")
            }
        }
//        else{
//                    changeViewController(controllerName: Constants.Controllers.UPLOAD_DOCUMENT)
//        }
    }
    
  
}