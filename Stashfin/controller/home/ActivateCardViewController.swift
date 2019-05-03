//
//  ActivateCardViewController.swift
//  StashFinDemo
//
//  Created by Macbook on 22/04/19.
//  Copyright © 2019 StashFin. All rights reserved.
//

import UIKit

class ActivateCardViewController: BaseLoginViewController {
    
    static func getInstance(storyboard: UIStoryboard) -> ActivateCardViewController{
        return storyboard.instantiateViewController(withIdentifier: String(describing: self.classForCoder())) as! ActivateCardViewController
    }
    
    
    @IBOutlet weak var cardNumberView: UIView!
    @IBOutlet weak var otpView: UIView!
    @IBOutlet weak var cardNumberFeild: UITextField!
    @IBOutlet weak var otpFeild: UITextField!
    var cardNumber:String=""
    public var cardTypeStatus="P" //V
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if cardTypeStatus == "V"{
            submitCardNumber(cardNo: "0000000000000000")
        }
    }
    
    
    @IBAction func sendOtpBtn(_ sender: UIButton) {
       let  number=cardNumberFeild.text.isNilOrValue
        if cardNumberFeild.isEditBoxNotEmpty() {
            if number.count != 16{
                self.showToast("Please enter valid card number")
            }else{
                submitCardNumber(cardNo: number)
            }
        }
    }
    @IBAction func activateBtn(_ sender: UIButton) {
        if otpFeild.isEditBoxNotEmpty(){
            verifyOTP()
        }
    }
    
    func submitCardNumber(cardNo:String){
        self.cardNumber=cardNo
        self.showProgress()
        let params=["mode":"submitCardNo","cardNo":cardNo,"card_type":cardTypeStatus]
        ApiClient.getJSONResponses(route: APIRouter.stasheasyApi(param: params)) {
            result, status in
            self.hideProgress()
            switch status{
            case .success:
                self.otpView.isHidden=false
                self.cardNumberView.isHidden=true
                self.showToast("OTP sent to your registered mobile number")
                Log(result)
            case .errors(let errors):
                self.showToast(errors)
            }
        }
    }
    
    func verifyOTP(){
        self.showProgress()
        let params=["mode":"submitCardOtp","cardNo":cardNumber,"otp":otpFeild.text.isNilOrValue,"card_type":cardTypeStatus]
        ApiClient.getJSONResponses(route: APIRouter.stasheasyApi(param: params)) {
            result, status in
            switch status{
            case .success:
                SessionManger.getInstance.saveCardResponse(cardResponse: "")
                self.checkCardStatusApi()
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4), execute: {
                    self.hideProgress()
                    self.showHomePage()
                })
                Log(result)
            case .errors(let errors):
                self.hideProgress()
                self.showToast(errors)
            }
        }
    }
}

