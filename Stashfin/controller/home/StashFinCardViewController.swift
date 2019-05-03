//
//  StashFinCardViewController.swift
//  StashFinDemo
//
//  Created by Macbook on 16/04/19.
//  Copyright © 2019 StashFin. All rights reserved.
//

import UIKit
import SwiftyJSON

class StashFinCardViewController: BaseViewController {
    
    static func getInstance(storyboard: UIStoryboard) -> StashFinCardViewController{
        return storyboard.instantiateViewController(withIdentifier: String(describing: self.classForCoder())) as! StashFinCardViewController
    }
    
    @IBOutlet weak var physicalBtn: UIButton!
    @IBOutlet weak var virtualBtn: UIButton!
    
    @IBOutlet weak var virtualCardView: RoundUIView!
    var cardNumberV=""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkStatus()

    }
    
    private func checkStatus() {
        self.showProgress()
        let params=["mode":"cardOverview"]
        ApiClient.getJSONResponses(route: APIRouter.stasheasyApi(param: params)){
            result, status in
            self.hideProgress()
            switch status{
            case .success:
                if let json = try? JSON(data: result!).rawString(){
                    guard let value = json else{
                        return
                    }
                    SessionManger.getInstance.saveCardResponse(cardResponse: value)
                    
                    self.updateCardStatus()
                    
                }
            case .errors(let errors):
                Log(errors)
                SessionManger.getInstance.saveCardResponse(cardResponse: "No card found")
                self.updateCardStatus()
            }
        }
    }
    
    
    @IBAction func physicalCardBtn(_ sender: UIButton) {
        switch sender.currentTitle {
        case "Change Card PIN":
            self.changeViewController(controllerName: Constants.Controllers.CHANGE_CARD_PIN)

        case "Send Request":
            self.changeViewController(controllerName: Constants.Controllers.GET_STASHFIN_CARD)
            
        case "Activate Card":
            self.cardType="P"
            self.changeViewController(controllerName: Constants.Controllers.ACTIVE_STASHFIN_CARD)
            
            
        default:
            Log("No action found")
        }
    }
    
    @IBAction func virtualCardBtn(_ sender: UIButton) {
        
        if sender.currentTitle == "Activate Card" {
            self.cardType="V"
            self.changeViewController(controllerName: Constants.Controllers.ACTIVE_STASHFIN_CARD)
            
        }
    }
    

    public func updateCardStatus(){
        let response = SessionManger.getInstance.getCardResponse()
        Log("updateCard response: \(response)")
        let json = JSON(parseJSON: SessionManger.getInstance.getCardResponse())
        Log("cardResponse \(json)")
        
        if json["cards"]["physical"].dictionary != nil{
            let otp_verified = json["cards"]["physical"]["otp_verified"].boolValue
            let card_registred = json["cards"]["physical"]["registered"].boolValue
            
            if card_registred{
                physicalBtn.setTitle("Change Card PIN", for: .normal)
            }else if otp_verified && !card_registred{
                physicalBtn.setTitle("Activation ERROR!", for: .normal)

            }else if !otp_verified && !card_registred{
                physicalBtn.setTitle("Activate Card", for: .normal)
            }
        }else{
            let requestStatus = SessionManger.getInstance.getCardRequest()
            Log("card status: \(requestStatus)")
            if requestStatus {
                physicalBtn.setTitle("Card request submitted!", for: .normal)
           }else{
              physicalBtn.setTitle("Send Request", for: .normal)
            }
        }
        
        if json["cards"]["virtual"].dictionary != nil{
          cardNumberV = json["cards"]["virtual"]["card_no"].stringValue
            virtualCardView.alpha = 1
            
            let otp_verified = json["cards"]["virtual"]["otp_verified"].boolValue
            let card_registred = json["cards"]["virtual"]["registered"].boolValue
            
            if card_registred{
                virtualBtn.setTitle("Card is already registered", for: .normal)
            }else if otp_verified && !card_registred{
                virtualBtn.setTitle("Activation ERROR!", for: .normal)
                
            }else if !otp_verified && !card_registred{
                virtualBtn.setTitle("Activate Card", for: .normal)
            }
        
        }else{
            virtualCardView.alpha = 0
        }
    }
}
