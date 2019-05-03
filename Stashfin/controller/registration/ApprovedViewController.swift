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
    @IBOutlet weak var amount: CustomUILabel!
    @IBOutlet weak var tenure: CustomUILabel!
    @IBOutlet weak var emiAmount: CustomUILabel!
    var landing_page:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        checkPreApprovedApi()
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
                self.amount.text = json["approved_amount"].stringValue
                   self.tenure.text = json["approved_tenure"].stringValue
                   self.emiAmount.text = json["emi_amount"].stringValue
                    self.landing_page = json["landing_page"].stringValue
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
        self.changeViewController(controllerName: landing_page)
    }
    
}
