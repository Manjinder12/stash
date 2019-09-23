//
//  BillLoadMyCardConfirmViewController.swift
//  Stashfin
//
//  Created by Macbook on 04/07/19.
//  Copyright © 2019 Stashfin. All rights reserved.
//

import UIKit
import SwiftyJSON

class BillLoadMyCardConfirmViewController: BaseLoginViewController {
    
    static func getInstance(storyboard: UIStoryboard) -> BillLoadMyCardConfirmViewController{
        return storyboard.instantiateViewController(withIdentifier: String(describing: self.classForCoder())) as! BillLoadMyCardConfirmViewController
    }
    
    
    public var locResponse:Data?
    var requestedAmount=""
    var tenure=""
    var checked:Bool=false
    let dropDown=DropDown()
    var chargesList=[String]()
    var billAmount:Int=0
    @IBOutlet weak var monthsLabel: UILabel!
    @IBOutlet weak var roiLabel: UILabel!
    @IBOutlet weak var emidateLabel: UILabel!
    @IBOutlet weak var monthlyEmiLabel: UILabel!
    @IBOutlet weak var totalPaymentLabel: UILabel!
    @IBOutlet weak var feesLabel: UILabel!
    @IBOutlet weak var finalDisAmntLabel: UILabel!
    @IBOutlet weak var requestedAmountLabel: UILabel!
    @IBOutlet weak var checkBoxBtn: UIButton!
    
    @IBOutlet weak var orLabel: CustomUILabel!
    @IBOutlet weak var whyDeductionBtn: UIButton!
    @IBOutlet weak var processChargessTC: CustomUILabel!
    @IBOutlet weak var termsAndCondition: UITextView!
    @IBOutlet weak var chargesInfoBtn: UIButton!
    @IBOutlet weak var payRsLabel: UILabel!
    @IBOutlet weak var byLabel: UILabel!
    @IBOutlet weak var billDateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="LOC"
        if SessionManger.getInstance.isBillCustomer(){
            processChargessTC.isHidden=false
        }else{
            processChargessTC.isHidden=true
        }
        orLabel.layer.masksToBounds = true
        orLabel.layer.cornerRadius = orLabel.frame.width/2
        
        
        SessionManger.getInstance.saveLocResponse(locResponse: "")
        
        let tc="I have read & agree with all terms and condition listed in the licence_agreement. StashFin Line of credit agreement."
        
        termsAndCondition.hyperLink(originalText: tc, hyperLink: "licence_agreement", urlString: "https://www.stashfin.com/licence_agreement")
        
        // Do any additional setup after loading the view.
        dropDown.anchorView=chargesInfoBtn
        if let json = try? JSON(data: locResponse!){
            requestedAmount = json["requested_amount"].stringValue
            tenure = json["tenure"].stringValue
            self.requestedAmountLabel.text = Constants.Values.RupeeSign + requestedAmount
            self.finalDisAmntLabel.text = Constants.Values.RupeeSign + json["final_disbursal_amount"].stringValue
            self.monthsLabel.text = tenure
            self.roiLabel.text = "\(json["rate_of_interest"].stringValue) %"
            self.billAmount = json["final_disbursal_amount"].intValue
            
            payRsLabel.text="Pay \(Constants.Values.RupeeSign) \(json["final_disbursal_amount"].stringValue)"
            let bill_date = json["bill_date"].stringValue.replacingOccurrences(of: "th", with: "")
            byLabel.text="by \(Utilities.getFormattedDate(dateString: bill_date,formatIn: "yyyy-MM-dd"))"
            billDateLabel.text = "\(Utilities.getFormattedDate(dateString: bill_date,formatIn: "yyyy-MM-dd"))"
            
            let emi_date=json["emi_date"].stringValue.replacingOccurrences(of: "th", with: "")
            self.emidateLabel.text = Utilities.getFormattedDate(dateString: emi_date,formatIn: "yyyy-MM-dd")
            self.monthlyEmiLabel.text = Constants.Values.RupeeSign + json["emi_amount"].stringValue
            self.totalPaymentLabel.text = Constants.Values.RupeeSign + json["net_amount_payable"].stringValue
            let procesing=json["processing_fees"].doubleValue
            
            let upfront_interest=json["upfront_interest"].doubleValue
            if upfront_interest > 0{
                whyDeductionBtn.underline()
                whyDeductionBtn.isHidden=false
            }else{
                whyDeductionBtn.isHidden=true
            }
            let gst=json["gst"].doubleValue
            let totalChanges=procesing+gst+upfront_interest
            chargesList.append("Processing charges : \(procesing)")
            chargesList.append("Upfront charges : \(upfront_interest)")
            chargesList.append("GST : \(gst)")
            self.feesLabel.text = Constants.Values.RupeeSign + "\(totalChanges)"
            if totalChanges>0{
                dropDown.dataSource=self.chargesList
                self.chargesInfoBtn.isHidden=false
            }else{
                self.chargesInfoBtn.isHidden=true
            }
            
        }else{
            self.openHomePageDialog(title: "LOC Card", message: "Something went wrong")
        }
    }
    
    @IBAction func whyDeductionBtn(_ sender: UIButton) {
        let alert = UIAlertController.init(title: "", message: "Final Disbursal Amount is the difference between load amount and the upfront interest, if Any. Upfront interest has been calculated on the Load Amount used over and above 30 days on your first EMI.\n\nDon't worry, if you wish to repay your amount at 0% interest, you will be required to repay only the amount that has been disbursed to you (by your bill date).", preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func confirmBtn(_ sender: UIButton) {
        if self.checkBoxBtn.currentBackgroundImage == #imageLiteral(resourceName: "check_box") {
            #if DEBUG
            Log("testing")
            self.showToast("Testing Mode")
            DispatchQueue.main.asyncAfter(deadline: ( .now() + .seconds(2)), execute: {
                self.nextPage()
            })

            #else
            if SessionManger.getInstance.getEmail() == "raviprakshlts@gmail.com"{
                if Utilities.getDeviceIds() == "DC0FED81-E3BA-4FAE-8439-2246D5F8BB02"{
                    confirmApi()
                }else{
                    self.showToast("Testing Mode")
                    DispatchQueue.main.asyncAfter(deadline: ( .now() + .seconds(2)), execute: {
                        self.nextPage()
                    })
                }
            }else{
                confirmApi()
            }
            #endif
            
        }else{
            self.showToast("Please select terms and condition.")
        }
    }
    
    private func confirmApi(){
        self.showProgress()
        let params=["mode":"locWithdrawalConfirm","amount":requestedAmount,"tenure":tenure]
        ApiClient.getJSONResponses(route: APIRouter.stasheasyApi(param: params)) {
            result, status in
            switch status{
            case .success:
                
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5), execute: {
                    self.hideProgress()
                    self.nextPage()
                })
                
            case .errors(let errors):
                self.hideProgress()
                self.showToast(errors,showDialog: true,title: "LOC Card")
            }
        }
    }
    
    private func nextPage(){
        let controller = LoadMyCardDoneViewController.getInstance(storyboard: self.storyBoardMain)
        controller.loan_amount = self.requestedAmountLabel.text.isNilOrValue
        
        controller.disburse_amount = self.finalDisAmntLabel.text.isNilOrValue
        controller.bill_amount = self.billAmount
        controller.emi_date = self.billDateLabel.text.isNilOrValue
        self.goToNextViewController(controller: controller)
    }
    
    @IBAction func checkBoxBtn(_ sender: UIButton) {
        if checked{
            checkBoxBtn.setBackgroundImage(#imageLiteral(resourceName: "box"), for: .normal)
            checked=false
        }else{
            checkBoxBtn.setBackgroundImage(#imageLiteral(resourceName: "check_box"), for: .normal)
            checked=true
            
        }
    }
    
    @IBAction func chargesInfoIcon(_ sender: UIButton) {
        dropDown.show()
    }
}

extension UIButton {
    func underline() {
        guard let text = self.titleLabel?.text else { return }
        
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: text.count))
        
        self.setAttributedTitle(attributedString, for: .normal)
    }
}
