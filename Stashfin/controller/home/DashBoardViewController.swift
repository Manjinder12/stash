//
//  DashBoard.swift
//  StashFinDemo
//
//  Created by Macbook on 06/02/19.
//  Copyright © 2019 StashFin. All rights reserved.
//

import UIKit
import SwiftyJSON

class DashBoardViewController: BaseViewController {
    
    @IBOutlet weak var loadMyCardViewClick: UIView!
    @IBOutlet weak var trnxViewClicked: UIView!
    @IBOutlet weak var payNowViewClicked: UIView!
    @IBOutlet weak var outgoingEmiViewClicked: UIView!
    
    @IBOutlet weak var cardBalance: UILabel!
    @IBOutlet weak var emiDate: UILabel!
    @IBOutlet weak var emiAmount: UILabel!
    @IBOutlet weak var approvedLimit: UILabel!
    @IBOutlet weak var usedLimit: UILabel!
    @IBOutlet weak var availableLimit: UILabel!
    
    var isLoadCardEnabled=false
    var cardErrorMessage="LOC is disabled, please contact us!"
    
    static func getInstance(storyboard: UIStoryboard) -> DashBoardViewController{
        return storyboard.instantiateViewController(withIdentifier: String(describing: self.classForCoder())) as! DashBoardViewController
    }
    
    override func viewDidLoad() {
        let loadMyCardView = UITapGestureRecognizer(target: self, action: #selector(openLocPage(_:)))
        
        let outgoingEmiView = UITapGestureRecognizer(target: self, action: #selector(openLocPage(_:)))
        let trnxView = UITapGestureRecognizer(target: self, action: #selector(openLocPage(_:)))
        let payNowView = UITapGestureRecognizer(target: self, action: #selector(openLocPage(_:)))
        
        self.outgoingEmiViewClicked.addGestureRecognizer(outgoingEmiView)
        self.trnxViewClicked.addGestureRecognizer(trnxView)
        self.payNowViewClicked.addGestureRecognizer(payNowView)
        self.loadMyCardViewClick.addGestureRecognizer(loadMyCardView)
        
        loadMyCardViewClick.tag=1
        trnxViewClicked.tag=2
        payNowViewClicked.tag=3
        outgoingEmiViewClicked.tag=4
        
        addMenuBarButtonItem()
        let response = SessionManger.getInstance.getLocResponse().data(using: .utf8, allowLossyConversion: true)
        if (try? JSON(data: response!)) != nil{
            self.setDetails(response)
        }else{
            checkLocApi()
        }
    }
    
    @objc func openLocPage(_ view: UITapGestureRecognizer){
        switch view.view!.tag {
        case 1:
            if isLoadCardEnabled{
                self.changeViewController(controllerName: Constants.Controllers.LOAD_MY_CARD)
            }else{
                self.showToast(cardErrorMessage,showDialog: true,title: "LOC Card")
            }
        case 2:
            if isLoadCardEnabled{
                self.changeViewController(controllerName: Constants.Controllers.TRANSACTION)
            }else{
                self.showToast(cardErrorMessage,showDialog: true,title: "Card Transaction")
            }
            
        case 3:
            self.changeViewController(controllerName: Constants.Controllers.PAY_NOW)
        case 4:
            self.changeViewController(controllerName: Constants.Controllers.OUTGOING_EMI)
        default:
            Log("vies.... \(view)")
        }
    }
    
    private func checkLocApi(){
        self.showProgress()
        let params:[String:String] = ["mode":"locDetails"]
        ApiClient.getJSONResponses(route: APIRouter.stasheasyApi(param: params)){
            result, status in
            self.hideProgress()
            switch status {
            case .success:
                self.setDetails(result)
                
            case .errors(let errors):
                self.showToast(errors)
            }
        }
    }
    
    private func setDetails(_ result:Data?){
        if let json = try? JSON(data: result!){
            SessionManger.getInstance.saveLocResponse(locResponse: "\(json)")
            Log("response for loc Api:  \(json)")
            self.isLoadCardEnabled = json["can_reload_card"].boolValue
            if let msg = json["reload_card_blocked_msg"].string, msg.count>2{
                self.cardErrorMessage = msg
            }
            self.cardBalance.text = Constants.Values.RupeeSign + (json["balance_on_card"].stringValue.isEmpty ? "0" : json["balance_on_card"].stringValue)
            self.emiDate.text = json["next_emi_date"].stringValue
            self.emiAmount.text = Constants.Values.RupeeSign + (json["next_emi_amount"].stringValue.isEmpty ? "0" : json["next_emi_amount"].stringValue)
            self.approvedLimit.text = Constants.Values.RupeeSign + (json["loc_limit"].stringValue.isEmpty ? "0" : json["loc_limit"].stringValue)
            self.usedLimit.text = Constants.Values.RupeeSign + (json["used_loc"].stringValue.isEmpty ? "0" : json["used_loc"].stringValue)
            self.availableLimit.text = Constants.Values.RupeeSign + (json["remaining_loc"].stringValue.isEmpty ? "0" : json["remaining_loc"].stringValue)
        }
        if SessionManger.getInstance.getCardResponse().isEmpty{
            self.checkCardStatusApi()
        }
    }
    
}
