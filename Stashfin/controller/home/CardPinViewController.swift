//
//  CardPinViewController.swift
//  StashFinDemo
//
//  Created by Macbook on 22/04/19.
//  Copyright © 2019 StashFin. All rights reserved.
//

import UIKit

class CardPinViewController: BaseViewController {
    
    static func getInstance(storyboard: UIStoryboard) -> CardPinViewController{
        return storyboard.instantiateViewController(withIdentifier: String(describing: self.classForCoder())) as! CardPinViewController
    }
    @IBOutlet weak var enterOtpView: UIView!
    @IBOutlet weak var enterPinView: UIView!
    @IBOutlet weak var enterOtpField: UITextField!
    @IBOutlet weak var enterPinField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        enterPinField.isSecureTextEntry=true
    }
    
    @IBAction func generateOTPBtn(_ sender: UIButton) {
        if sender.titleLabel?.text == "Submit"{
             changePin(sender: sender)
        }else if sender.titleLabel?.text == "Verify OTP"{
            submitOtp(sender: sender)
        }else if sender.titleLabel?.text == "Generate OTP"{
            generateOtp(sender: sender)
        }
    }
    
    private func changePin(sender: UIButton){
        if enterPinField.isEditBoxNotEmpty() && enterOtpField.isEditBoxNotEmpty(){
            self.showProgress()
            let params = ["mode":"changeCardPin","newPin":enterPinField.text.isNilOrValue,"otp":enterOtpField.text.isNilOrValue]
            ApiClient.getJSONResponses(route: APIRouter.stasheasyApi(param: params)){
                result, status in
                self.hideProgress()
                switch status{
                case .success:
                    self.openHomePageDialog(title: "Change PIN", message: "Your StashFin card pin change successfully!")
                case .errors(let error):
                    self.showToast(error)
                }
            }
        }
    }
    
    private func submitOtp(sender: UIButton){
        if enterOtpField.isEditBoxNotEmpty(){
            self.showProgress()
            let params = ["mode":"submitCardChangePinOtp","otp":enterOtpField.text.isNilOrValue]
            ApiClient.getJSONResponses(route: APIRouter.stasheasyApi(param: params)){
                result, status in
                self.hideProgress()
                switch status{
                case .success:
                    
                    self.enterPinView.isHidden=false
                    self.enterOtpField.isUserInteractionEnabled=false
                    sender.setTitle("Submit", for: .normal)
                    
                case .errors(let error):
                    self.showToast(error)
                }
            }
        }
    }

    private func generateOtp(sender: UIButton){
        self.showProgress()
        let params = ["mode":"sendCardPinChangeOtp"]
        ApiClient.getJSONResponses(route: APIRouter.stasheasyApi(param: params)){
            result, status in
            self.hideProgress()
            switch status{
            case .success:
                self.enterOtpView.isHidden=false
                sender.setTitle("Verify OTP", for: .normal)
                
            case .errors(let error):
                self.showToast(error)
            }
        }
    }
    
}
