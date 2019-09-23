//
//  LoginViewController.swift
//  StashFinDemo
//
//  Created by Macbook on 22/01/19.
//  Copyright © 2019 StashFin. All rights reserved.
//

import Foundation
import UIKit
import Toast_Swift
import SwiftyJSON
import Crashlytics


class LoginViewController:BaseLoginViewController {
    @IBOutlet weak var emailNumberBox: UITextField!
    @IBOutlet weak var passwordOtpBox: UITextField!
    @IBOutlet weak var sendOtpBtn: UIButton!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var passwordText: UILabel!
    @IBOutlet weak var backgroundImg: UIImageView!
    @IBOutlet weak var forgotPasswordBtn: UIButton!
    
    
    static func getInstance(storyboard: UIStoryboard) -> LoginViewController{
        return storyboard.instantiateViewController(withIdentifier: String(describing: self.classForCoder())) as! LoginViewController
    }
    
    override func viewDidLoad() {
        print("viewDidLoad")
        view.sendSubviewToBack(backgroundImg)
        
        //        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        emailNumberBox.addTarget(self, action: #selector(emailFeildDidChange), for: .editingChanged)
        passwordOtpBox.isSecureTextEntry.toggle()
        passwordOtpBox.addTarget(self, action: #selector(passwordLimit(field:)), for: .editingChanged)
        
        //        emailNumberBox.text="stash209@gmail.com"
        //        passwordOtpBox.text="123456789"
    }
    
    @IBAction func bacBtn(_ sender: UIButton) {
        onBackPressed()
    }
    
    @objc func emailFeildDidChange() {
        if Utilities.isEmailValid(email: emailNumberBox.text.isNilOrValue){
            passwordEnable(status:true)
            sendOtpBtn.alpha = 0
            passwordText.text = "Password"
            passwordOtpBox.keyboardType = .emailAddress
        }else if Utilities.isPhoneNumberValid(value: emailNumberBox.text.isNilOrValue) {
            sendOtpBtn.alpha = 1
            passwordEnable(status:false)
            passwordText.text = "OTP"
            passwordOtpBox.keyboardType = .numberPad
        }else{
            sendOtpBtn.alpha = 0
            passwordEnable(status:true)
            passwordOtpBox.keyboardType = .emailAddress
            passwordText.text = "Password"
        }
    }
    
    @objc func passwordLimit(field:UITextField){
        var MAX_LENGHT:Int=25
        if passwordText.text=="OTP"{
            MAX_LENGHT = 6
        }else if passwordText.text=="Password"{
            MAX_LENGHT = 25
        }
        if let text = field.text, text.count >= MAX_LENGHT {
            field.text = String(text.dropLast(text.count - MAX_LENGHT))
            return
        }
    }
    
    private func passwordEnable(status:Bool){
        if status{
            passwordText.alpha=1
            passwordOtpBox.alpha=1
        }else{
            passwordText.alpha=0
            passwordOtpBox.alpha=0
        }
    }
    
    @IBAction func loginSubmitBtn(_ sender: UIButton) {
        print("login Pressed")
        print(emailNumberBox.text!)
        print(passwordOtpBox.text!)
        if(emailNumberBox.isEditBoxNotEmpty() && passwordOtpBox.isEditBoxNotEmpty()){
            if  Utilities.isEmailValid(email: emailNumberBox.text.isNilOrValue) || Utilities.isPhoneNumberValid(value: emailNumberBox.text.isNilOrValue){
                checkLoginDetail(email: emailNumberBox.text!,password: passwordOtpBox.text!);
            }else{
                emailNumberBox.becomeFirstResponder()
                self.showToast("Please enter valid email or mobile number")
            }
        }
    }
    
    @IBAction func sendOtp(_ sender: UIButton) {
        
        if(emailNumberBox.isEditBoxNotEmpty()){
            sendOtp(email: emailNumberBox.text!);
        }
    }
    
    private func sendOtp(email:String){
        
        let param:[String:String] = ["phone":email, "mode":"generate_otp"]
        self.showProgress()
        ApiClient.getJSONResponses(route: APIRouter.v2Api(param: param)){
            result,code in
            self.hideProgress()
            switch code{
            case .success:
                //                if let json = try? JSON(data: result!){
                self.passwordEnable(status:true)
                self.showToast("OTP sent!")
                self.passwordText.isHidden = false
                self.passwordText.text = "OTP"
                self.submitBtn.isHidden = false
                self.passwordOtpBox.isHidden = false
                //                }
                
            case .errors(let error):
                self.showToast(error)
            }
        }
    }
    
    private func checkLoginDetail(email:String, password:String){
        let param:[String:String]
        if email.contains("@"){
            param = ["email":email,"password":password,"mode":"login","source":Constants.Values.ios,"device_id":Utilities.getDeviceIds(),"status":"1"]
        }else{
            param = ["phone":email,"otp":password,"mode":"login","source":Constants.Values.ios,"device_id":Utilities.getDeviceIds(),"status":"1"]
        }
        self.showProgress()
        ApiClient.getJSONResponses(route: APIRouter.v2Api(param: param)){
            result,code in
            self.hideProgress()
            switch code{
            case .success:
                print("result....\(String(describing: result!))");
                SessionManger.getInstance.setUserLogin(status: true)
                
                self.passwordOtpBox.text=""
                self.emailNumberBox.text=""
                if let response = try? JSON(data: result!){
                   
                    SessionManger.getInstance.saveEmail(email: response["email"].stringValue)
                    SessionManger.getInstance.saveNumber(number: response["phone"].stringValue)
                    SessionManger.getInstance.saveAuthToken(token: response["auth_token"].stringValue)
                    let mPinStatus = response["m_pin"].intValue
                    if mPinStatus == 1{
                        SessionManger.getInstance.setMpinActive(status: true)
                        self.parseResonse(result:result)
                    }else{
                        self.openAlertMpin(data:result)
                    }
                }
                
            case .errors(let error):
                self.showToast(error)
            }
        }
    }
    
    @IBAction func forgotPassword(_ sender: UIButton) {
        self.changeViewController(controllerName: Constants.Controllers.FORGOT_PASSWORD)
    }
    
    private func openAlertMpin(data:Data?){
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
            let alert = UIAlertController.init(title: "mPIN", message: "\nEnable your 4 digit M-PIN to login to your App in a more secure and faster manner", preferredStyle: .alert)
            alert.addAction(UIAlertAction.init(title: "Activate", style: .default, handler: {(_) -> Void in
                SessionManger.getInstance.setMpinActive(status: false)
                self.pin(.create)
            }))
            alert.addAction(UIAlertAction.init(title: "Later", style: .default, handler: {(_) -> Void in
                SessionManger.getInstance.setMpinActive(status: false)
                self.parseResonse(result:data)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}
