//
//  ApprovedViewController.swift
//  StashFinDemo
//
//  Created by Macbook on 05/02/19.
//  Copyright © 2019 StashFin. All rights reserved.
//


import UIKit
import SwiftyJSON

class ApprovedViewController: BaseLoginViewController {
    
    static func getInstance(storyboard: UIStoryboard) -> ApprovedViewController{
        return storyboard.instantiateViewController(withIdentifier: String(describing: self.classForCoder())) as! ApprovedViewController
    }
    
    @IBOutlet weak var amount: CustomUILabel!
    @IBOutlet weak var tenure: CustomUILabel!
    @IBOutlet weak var emiAmount: CustomUILabel!
    var landing_page:String = ""
    public var amountResponse:String=""
    public var tenureResponse:String=""
    public var emiAmountResponse:String=""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if SessionManger.getInstance.isTester(){
            self.amount.text = Constants.Values.RupeeSign + "500"
            self.tenure.text = "3" + " Months"
            self.emiAmount.text = Constants.Values.RupeeSign + "173"
        }else{
            
            self.amount.text = Constants.Values.RupeeSign + amountResponse
            self.tenure.text = tenureResponse + " Months"
            self.emiAmount.text = Constants.Values.RupeeSign + emiAmountResponse
          
        }
    }
    
    private func checkPreApprovedApi(){
        self.showProgress()
        let params:[String:String] = ["mode":"approve_next"]
        ApiClient.getJSONResponses(route: APIRouter.v2Api(param: params)){
            result,status in
            self.hideProgress()
            switch status{
            case .success:
                if let json = try? JSON(data:result!){
                    self.amount.text = Constants.Values.RupeeSign + json["approved_amount"].stringValue
                    self.tenure.text = json["approved_tenure"].stringValue + " Months"
                    self.emiAmount.text = Constants.Values.RupeeSign + json["emi_amount"].stringValue
                    self.landing_page = json["landing_page"].stringValue
                    self.submitDetails()
                }
            case .errors(let errors):
                self.showToast(errors)
            }
        }
    }
    
    // MARK: - Init
    
    // MARK: - Properties
    
    // MARK: - Handlers
    
    @IBAction func nextBtn(_ sender: UIButton) {
        if SessionManger.getInstance.isTester(){
            self.changeViewController(controllerName: Constants.Controllers.PICKUP)
            
        }else{
            self.checkPreApprovedApi()
        }
    }
    
    private func submitDetails(){
        self.changeViewController(controllerName: landing_page)
    }
    
}
