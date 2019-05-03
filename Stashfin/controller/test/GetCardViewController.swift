//
//  GetCardViewController.swift
//  StashFinDemo
//
//  Created by Macbook on 08/04/19.
//  Copyright © 2019 StashFin. All rights reserved.
//

import UIKit

class GetCardViewController: BaseViewController {

    static func getInstance(storyboard: UIStoryboard) -> GetCardViewController{
        return storyboard.instantiateViewController(withIdentifier: String(describing: self.classForCoder())) as! GetCardViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func cardRequestBtn(_ sender: UIButton) {
        sendCardRequestApi()
    }
    
    private func sendCardRequestApi(){
        let params=["mode":"requestForCardLoggedCustomer"]
        self.showProgress()
        ApiClient.getJSONResponses(route: APIRouter.stasheasyApi(param: params)){
            result, status in
            self.hideProgress()
            switch status {
            case .success:
                SessionManger.getInstance.saveCardRequest(cardResponse: true)
                self.changeViewController(controllerName: Constants.Controllers.STASHFIN_CARD)
            case .errors(let error):
                self.showToast(error)
            }
            
        }
    }

}
