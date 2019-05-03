//
//  LoadMyCardConfirmViewController.swift
//  StashFinDemo
//
//  Created by Macbook on 10/04/19.
//  Copyright © 2019 StashFin. All rights reserved.
//

import UIKit
import SwiftyJSON

class LoadMyCardConfirmViewController: BaseLoginViewController {
    
    static func getInstance(storyboard: UIStoryboard) -> LoadMyCardConfirmViewController{
        return storyboard.instantiateViewController(withIdentifier: String(describing: self.classForCoder())) as! LoadMyCardConfirmViewController
    }
    
    public var locResponse:Data?
    var requestedAmount=""
    var tenure=""
    var checked:Bool=false
    let dropDown=DropDown()
    var chargesList=[String]()
    @IBOutlet weak var monthsLabel: UILabel!
    @IBOutlet weak var roiLabel: UILabel!
    @IBOutlet weak var emidateLabel: UILabel!
    @IBOutlet weak var monthlyEmiLabel: UILabel!
    @IBOutlet weak var totalPaymentLabel: UILabel!
    @IBOutlet weak var feesLabel: UILabel!
    @IBOutlet weak var finalDisAmntLabel: UILabel!
    @IBOutlet weak var requestedAmountLabel: UILabel!
    @IBOutlet weak var checkBoxBtn: UIButton!
    
    @IBOutlet weak var chargesInfoBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       self.title="LOC"
        SessionManger.getInstance.saveLocResponse(locResponse: "")
        
        // Do any additional setup after loading the view.
        dropDown.anchorView=chargesInfoBtn
        if let json = try? JSON(data: locResponse!){
            requestedAmount = json["requested_amount"].stringValue
            tenure = json["tenure"].stringValue
            self.requestedAmountLabel.text = Constants.Values.RupeeSign + requestedAmount
            self.finalDisAmntLabel.text = Constants.Values.RupeeSign + json["final_disbursal_amount"].stringValue
            self.monthsLabel.text = tenure
            self.roiLabel.text = json["rate_of_interest"].stringValue
            self.emidateLabel.text = json["first_emi_date"].stringValue.replacingOccurrences(of: "th", with: "")
            self.monthlyEmiLabel.text = Constants.Values.RupeeSign + json["emi_amount"].stringValue
            self.totalPaymentLabel.text = Constants.Values.RupeeSign + json["net_amount_payable"].stringValue
            let procesing=json["processing_fees"].doubleValue
            let upfront_interest=json["upfront_interest"].doubleValue
            let gst=json["gst"].doubleValue
            let totalChanges=procesing+gst+upfront_interest
            chargesList.append("Processing charges : \(procesing)")
            chargesList.append("Upfront charges : \(upfront_interest)")
            chargesList.append("GST : \(gst)")
            self.feesLabel.text = Constants.Values.RupeeSign + "\(totalChanges)"
            if totalChanges>1{
                dropDown.dataSource=self.chargesList
                self.chargesInfoBtn.isHidden=false
            }else{
                self.chargesInfoBtn.isHidden=true
            }
            
        }else{
            self.openHomePageDialog(title: "LOC Card", message: "Something went wrong")
        }
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
            confirmApi()
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
        controller.emi_amount = self.monthlyEmiLabel.text.isNilOrValue
        controller.emi_date = self.emidateLabel.text.isNilOrValue
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
