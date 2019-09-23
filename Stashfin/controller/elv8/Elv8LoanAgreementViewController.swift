//
//  Elv8LoanAgreementViewController.swift
//  Stashfin
//
//  Created by Macbook on 31/05/19.
//  Copyright © 2019 Stashfin. All rights reserved.
//

import UIKit

class Elv8LoanAgreementViewController: BaseLoginViewController {

    static func getInstance(storyboard: UIStoryboard) -> Elv8LoanAgreementViewController{
        return storyboard.instantiateViewController(withIdentifier: String(describing: self.classForCoder())) as! Elv8LoanAgreementViewController
    }
    
    var checked=false
    @IBOutlet weak var checkBoxBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func nextBtn(_ sender: UIButton) {
        if self.checkBoxBtn.currentBackgroundImage != #imageLiteral(resourceName: "check_box") {
            self.showToast("Please accept terms & conditions.")
            return
        }
        submitApi()
    }
    
    private func submitApi(){
        self.showProgress()
        let params=["mode":"acceptAgreement","agreement_type":"elevate"]
        
        ApiClient.getJSONResponses(route: APIRouter.v2Api(param: params)){
            result,status in
            self.hideProgress()
            switch status{
            case .success:
                self.changeViewController( response: result)
            case .errors(let error):
                self.showToast(error)
            }
        }
    }
    
    @IBAction func checkBtn(_ sender: UIButton) {
        if checked{
            checkBoxBtn.setBackgroundImage(#imageLiteral(resourceName: "box"), for: .normal)
            checked=false
        }else{
            checkBoxBtn.setBackgroundImage(#imageLiteral(resourceName: "check_box"), for: .normal)
            checked=true
            
        }
    }
    
    
}
