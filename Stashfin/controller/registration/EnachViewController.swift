//
//  EnachViewController.swift
//  StashFinDemo
//
//  Created by Macbook on 05/02/19.
//  Copyright © 2019 StashFin. All rights reserved.
//


import UIKit
import SwiftyJSON

class EnachViewController: BaseLoginViewController {
    //    weak var delegate:BaseViewdelagate?
    @IBOutlet weak var accountNumber: UITextField!
    @IBOutlet weak var confirmAccountNumber: UITextField!
    @IBOutlet weak var ifscCode: UITextField!
    
    
    // MARK: - Init
    
    
    // MARK: - Properties
    override func viewDidLoad() {
        super.viewDidLoad()
        accountNumber.isSecureTextEntry = true
        
    }
    
    // MARK: - Handlers
    @IBAction func nextBtnHandler(_ sender: UIButton) {
        
        if accountNumber.isEditBoxNotEmpty() && confirmAccountNumber.isEditBoxNotEmpty() && ifscCode.isEditBoxNotEmpty(){
            if accountNumber.text.isNilOrValue.count > 7 && accountNumber.text.isNilOrValue.count<25{
                if ifscCode.text.isNilOrValue.count == 11{
                    if accountNumber.text == confirmAccountNumber.text{
                        checkIfscCoeApi(ifsc:ifscCode.text.isNilOrValue)
                    }else{
                        self.showToast("Account numbers don't match")
                    }
                }else{
                    self.showToast("Ifsc code not valid")
                }
            }else{
                self.showToast("Account number not valid")
            }
            
        }
    }
    private func checkIfscCoeApi(ifsc:String){
        self.showProgress()
        let urlPath="https://ifsc.razorpay.com/\(ifsc)"
        let params:[String:String] = ["":""]
        ApiClient.get(path: urlPath, params: params){
            result, status in
            self.hideProgress()
            switch status{
            case .success:
                if let json = try? JSON(data: result!){
                    self.showConfirmationAlert(bankName: json["BANK"].stringValue,branchName: json["BRANCH"].stringValue);
                }
            case .errors(let errors):
                self.showToast(errors)
            }
        }
    }
    
    private func showConfirmationAlert(bankName:String,branchName:String){
        let message = "\nBank Name: \(bankName)\nBranch: \(branchName)\nAccount Number: \(accountNumber.text.isNilOrValue)\nIFSC: \(ifscCode.text.isNilOrValue) "
        let alert = UIAlertController(title: "Bank Details",message: message,preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: {(_) in
            self.submitDocumentDetails()
        }))
        alert.addAction(UIAlertAction(title: "Change", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    private func submitDocumentDetails(){
        let params:[String:String]=["mode":"bank_details","ifsc_code":ifscCode.text.isNilOrValue,"account_no":accountNumber.text.isNilOrValue]
        self.showProgress()
        ApiClient.getJSONResponses(route: APIRouter.v2Api(param: params)){
            result,status in
            self.hideProgress()
            switch status{
            case .success:
                self.changeViewController(response: result)
            case .errors(let errors):
                self.showToast(errors)
            }
        }
    }
}
