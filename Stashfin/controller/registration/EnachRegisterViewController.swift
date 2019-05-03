//
//  EnachRegisterViewController.swift
//  StashFinDemo
//
//  Created by Macbook on 12/04/19.
//  Copyright © 2019 StashFin. All rights reserved.
//

import UIKit
import SwiftyJSON

class EnachRegisterViewController: BaseLoginViewController {

    @IBOutlet weak var accountNumberLabel: UILabel!
    @IBOutlet weak var ifscFeild: UILabel!
    @IBOutlet weak var bankNameFeild: UILabel!
    @IBOutlet weak var skipButton: UIButton!
    
    
    var response:Data?
    var accountNumber=""
    var ifscCode=""
    var bankName=""
    var enachSkip=""
    var enachUrl=""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
          if let json = try? JSON(data:response!){
            self.accountNumber=json["account_no"].stringValue
            self.ifscCode=json["ifsc_code"].stringValue
            self.bankName=json["bank_name"].stringValue
            self.enachSkip=json["enach_skip"].stringValue
            self.enachUrl=json["enach_url"].stringValue
        }
       
        if enachSkip=="1"{
            skipButton.isHidden=false
        }
        accountNumberLabel.text=accountNumber
        ifscFeild.text=ifscCode
        bankNameFeild.text=bankName
    }


    @IBAction func submitEnach(_ sender: UIButton) {
        let controller = WebViewViewController.getInstance(storyBoard: self.storyBoardMain)
        controller.url = self.enachUrl
        controller.urlType = "enach"
        self.goToNextViewController(controller:controller)
//        guard let url = URL(string: self.enachUrl) else
//       {
//        self.showToast("Path is not valid")
//        return }
//       UIApplication.shared.open(url)
    }
    
    private func skipApi(){
        let params=["mode":"enachSkipped"]
        ApiClient.getJSONResponses(route: APIRouter.v2Api(param: params)){
            result, status in
            switch status{
            case .success: self.changeViewController(response: result)
                
            case .errors(let error):
                self.showToast(error)
            }
        }
    }
    
    @IBAction func skipBtn(_ sender: UIButton) {
       skipApi()
    }
    
    
}
