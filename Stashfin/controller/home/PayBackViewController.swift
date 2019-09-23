//
//  PayBackViewController.swift
//  StashFinDemo
//
//  Created by Macbook on 08/04/19.
//  Copyright © 2019 StashFin. All rights reserved.
//

import UIKit
import SwiftyJSON

class PayBackViewController: BaseViewController {
    
    static func getInstance(storyboard: UIStoryboard) -> PayBackViewController{
        return storyboard.instantiateViewController(withIdentifier: String(describing: self.classForCoder())) as! PayBackViewController
    }
    
    @IBOutlet weak var paybackUserLabel: UITextField!
    @IBOutlet weak var pinLabel: UITextField!
    @IBOutlet weak var paybackResultView: UIScrollView!
    @IBOutlet weak var paybackLoginView: UIScrollView!
    @IBOutlet weak var paybackIdLabel: UILabel!
    @IBOutlet weak var eligibleAmountLabel: UILabel!
    @IBOutlet weak var unlockedAmount: UILabel!
    @IBOutlet weak var totalPointslabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="PAYBACK"
        updatePaybackView()
        
        paybackUserLabel.text=SessionManger.getInstance.getNumber()
        pinLabel.isSecureTextEntry = true
        
        paybackIdLabel.layer.cornerRadius = 15
        paybackIdLabel.layer.borderWidth=0.7
        
        eligibleAmountLabel.layer.cornerRadius = 15
        eligibleAmountLabel.layer.borderWidth=0.7
        
        unlockedAmount.layer.cornerRadius = 15
        unlockedAmount.layer.borderWidth=0.7
        
        totalPointslabel.layer.cornerRadius = 15
        totalPointslabel.layer.borderWidth=0.7
        
        
        // Do any additional setup after loading the view.
    }
    
    private func updatePaybackView(){
        let value=SessionManger.getInstance.getPaybackValue().toData()
        if let json = try? JSON(data: value!){
            self.unlockedAmount.text =  json["unlock_points"].stringValue+" Points"
            
            self.eligibleAmountLabel.text = json["eligible_points"].stringValue+" Points"
            self.totalPointslabel.text=json["total_points"].stringValue+" Points"
            self.paybackIdLabel.text=json["loyCardNumber"].stringValue
            self.paybackViewChange(isResult: true)
            
        }else{
            paybackViewChange()
        }
    }
    
    private func paybackViewChange(isResult:Bool=false){
        if isResult{
            paybackLoginView.isHidden=true
            paybackResultView.isHidden=false
        }else{
            paybackLoginView.isHidden=false
            paybackResultView.isHidden=true
        }
    }
    
    @IBAction func generateNewPinBtn(_ sender: UIButton) {
        if paybackUserLabel.isEditBoxNotEmpty(){
            let params=["mode":"getPassword","phone":paybackUserLabel.text.isNilOrValue]
            self.showProgress()
            ApiClient.getJSONResponses(route: APIRouter.androidApi(param: params)){
                result,status in
                self.hideProgress()
                switch status{
                case .success:
                    
                    if let json = try? JSON(data: result!){
                        if let msg = json["message"].string{
                            self.showToast(msg)
                        }
                    }
                case .errors(let errors):
                    self.showToast(errors)
                }
            }
        }
    }
    
    @IBAction func submitBtn(_ sender: UIButton) {
        if paybackUserLabel.isEditBoxNotEmpty() && pinLabel.isEditBoxNotEmpty(){
            if paybackUserLabel.text.isNilOrValue.count<5{
                self.showToast("Please enter valid number")
                return
            }
            
            let params=["mode":"PaybackRewardPoints","phone":paybackUserLabel.text.isNilOrValue,"pin":pinLabel.text.isNilOrValue]
            self.showProgress()
            ApiClient.getJSONResponses(route: APIRouter.androidApi(param: params)){
                result,status in
                self.hideProgress()
                switch status{
                case .success:
                    SessionManger.getInstance.savePaybackValue(value: result?.toString() ?? "")
                    self.updatePaybackView()
                case .errors(let errors):
                    self.showToast(errors)
                    
                }
            }
        }
    }
    
    
}
