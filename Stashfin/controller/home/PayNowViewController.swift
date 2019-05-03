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
        ApiClient.getJSONResponses(route: APIRouter.stasheasyApi(param: params)){
            result, status in
            self.hideProgress()
            switch status {
            case .success:
                if let json = try? JSON(data: result!){
                    if let dues = json["dues"].int, dues == 1{
                        
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

                    }else{
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
            controller.paymentModel = PaymentAmountModel(amount:"\(amount)", mode:EMI_MODE, paymentCode:"")
            self.goToNextViewController(controller:controller)
        }else{
            self.showToast("Amount should be more than \(Constants.Values.RupeeSign)100")
        }
    }
    
    @IBAction func forCloseBtn(_ sender: UIButton) {
        switch sender.currentTitle.isNilOrValue {
        case "Pay EMI":
            paymentDetailsView.isHidden=false
            amounttitle.text = "Total Amount Due"
            self.checkForecloseStatus()
            payableAmountField.isUserInteractionEnabled=true
            payableAmountField.text="\(emiAmount)"
            amountDue.text="\(emiAmount)"
            EMI_MODE="0"
            
        case foreClose:
            paymentDetailsView.isHidden=true
            payableAmountField.isUserInteractionEnabled=false
            amounttitle.text = "Foreclose Amount"
            payableAmountField.text="\(foreCloseAmount)"
            amountDue.text="\(foreCloseAmount)"
            sender.setTitle("Pay EMI", for: .normal)
            EMI_MODE="1"
            
        case wantForeclose:
            let alert = UIAlertController.init(title: "Foreclose Loan", message: "\nLet us know your reason for this request. Our customer support team will contact you.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Send Request", style: .default, handler: {(_)-> Void in
                self.changeViewController(controllerName: Constants.Controllers.CUSTOMER_CARE)
            }))
            self.present(alert, animated: true, completion: nil)
        default:
            self.showToast("No action \(sender.currentTitle.isNilOrValue)")
        }
        
    }
    
    
}
