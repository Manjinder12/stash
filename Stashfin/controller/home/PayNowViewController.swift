//
//  PayNowViewController.swift
//  StashFinDemo
//
//  Created by Macbook on 09/04/19.
//  Copyright © 2019 StashFin. All rights reserved.
//

import UIKit
import SwiftyJSON

class PayNowViewController: BaseLoginViewController {
    
    @IBOutlet weak var amountDue: UILabel!
    @IBOutlet weak var principalLabel: UILabel!
    @IBOutlet weak var interestLabel: UILabel!
    @IBOutlet weak var overdueLabel: UILabel!
    @IBOutlet weak var chargesLabel: UILabel!
    @IBOutlet weak var payableAmountField: UITextField!
    @IBOutlet weak var paymentDetailsView: RoundUIView!
    @IBOutlet weak var amounttitle: UILabel!
    @IBOutlet weak var foreCloseBtn: UIButton!
    
    var EMI_MODE = "0"
    var foreCloseAmount = 0.0
    var emiAmount = 0.0
    let foreClose="Make Foreclosure Payment"
    let wantForeclose="I want to pre pay my dues / foreclose"
    
    static func getInstance(storyBoard:UIStoryboard) -> PayNowViewController{
        
        return storyBoard.instantiateViewController(withIdentifier: String(describing: self.classForCoder())) as! PayNowViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkPaymentApi()
        self.title="Payment"
    }
    
    private func checkPaymentApi(){
        self.showProgress()
        let params=["mode":"emiPayment"]
        ApiClient.getJSONResponses(route: APIRouter.v2Api(param: params)){
            result, status in
            self.hideProgress()
            switch status {
            case .success:
                if let json = try? JSON(data: result!){
//                    if let dues = json["dues"].int, dues == 1{
                    
                        //                        self.emiDateLabel.text = json["emi_date"].stringValue
                        self.principalLabel.text = Constants.Values.RupeeSign +  "\(json["principle"].doubleValue)"
                        self.interestLabel.text = Constants.Values.RupeeSign + "\(json["interest"].doubleValue)"
                        self.overdueLabel.text = Constants.Values.RupeeSign + "\(json["overdue"].doubleValue)"
                    
                    self.chargesLabel.text = Constants.Values.RupeeSign + "\(json["charges"].doubleValue)"
                    
                    
                        self.payableAmountField.text = "\(json["total_pay_amount"].doubleValue)"
                        self.amountDue.text = Constants.Values.RupeeSign + "\(json["total_pay_amount"].doubleValue)"
                        self.foreCloseAmount=json["foreclose"].doubleValue
                        //                        self.foreCloseAmount=10.0
                        self.emiAmount=json["emi_amount"].doubleValue
                        
                        self.checkForecloseStatus()
                    
                    if json["total_pay_amount"].doubleValue==0{
                        self.openHomePageDialog(title: "Pay EMI", message: "No paymnet due found!!\nPlease try later")
                    }
                }
            case .errors(let error):
                Log(error)
                self.openHomePageDialog(title: "Pay EMI", message: "No paymnet due found!!\nPlease try later")
            }
        }
    }
    
    private func checkForecloseStatus(){
        if self.foreCloseAmount>2{
            self.foreCloseBtn.setTitle(self.foreClose, for: .normal)
            self.foreCloseBtn.setTitleColor(.red, for: .normal)
        }else{
            self.foreCloseBtn.setTitle(self.wantForeclose, for: .normal)
        }
    }
    
    @IBAction func payNowBtn(_ sender: UIButton) {
        SessionManger.getInstance.saveLocResponse(locResponse: "")
        
        if let amount = Double(self.payableAmountField.text ?? "0"), amount > 1.0{
            let controller = WebViewViewController.getInstance(storyBoard: self.storyBoardMain)
            controller.url = ""
            controller.urlType = "payment"
            controller.paymentModel = PaymentAmountModel(amount:"\(amount)", mode:EMI_MODE, paymentCode:"",billId: "")
            self.goToNextViewController(controller:controller)
        }else{
            self.showToast("Amount should be more than \(Constants.Values.RupeeSign)100")
        }
    }
    
    @IBAction func forCloseBtn(_ sender: UIButton) {
        switch sender.currentTitle.isNilOrValue {
        case "Pay EMI":
            self.showProgress()
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1) , execute: {
                self.hideShowView(showStatus: true)
                self.checkForecloseStatus()
            })
            
        case foreClose:
            self.showProgress()
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1) , execute: {
                self.hideShowView(showStatus: false)
                sender.setTitle("Pay EMI", for: .normal)
            })
            
            
        case wantForeclose:
            let alert = UIAlertController.init(title: "Foreclose Loan", message: "\nLet us know your reason for this request. Our customer support team will contact you.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Send Request", style: .default, handler: {(_)-> Void in
                self.changeViewController(controllerName: Constants.Controllers.CUSTOMER_CARE)
            }))
            self.present(alert, animated: true, completion: nil)
        default:
            Log("No action \(sender.currentTitle.isNilOrValue)")
        }
        
    }
    
    private func hideShowView(showStatus:Bool){
        self.hideProgress()
        if showStatus {
            UIView.transition(with: paymentDetailsView, duration: 0.3, options: .showHideTransitionViews, animations: {
                self.paymentDetailsView.isHidden=false
                self.payableAmountField.isUserInteractionEnabled=true
                self.EMI_MODE="0"
                self.amounttitle.text = "Total Amount Due"
                self.payableAmountField.text="\(self.emiAmount)"
                self.amountDue.text="\(self.emiAmount)"
            })
        }
        else {
            UIView.transition(with: paymentDetailsView, duration: 0.3, options: .showHideTransitionViews, animations: {
                self.paymentDetailsView.isHidden=true
                self.payableAmountField.isUserInteractionEnabled=false
                self.amounttitle.text = "Foreclose Amount"
                self.EMI_MODE="1"
                self.payableAmountField.text="\(self.foreCloseAmount)"
                self.amountDue.text="\(self.foreCloseAmount)"
                
            })
        }
    }
}
