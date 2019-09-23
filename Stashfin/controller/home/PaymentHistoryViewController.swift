//
//  PaymentHistoryViewController.swift
//  Stashfin
//
//  Created by Macbook on 23/07/19.
//  Copyright © 2019 Stashfin. All rights reserved.
//

import UIKit
import SwiftyJSON

class PaymentHistoryModel{
    var title,date,amount,mode:String?
    
    init(title:String,date:String,amount:String,mode:String) {
        self.title=title
        self.amount=amount
        self.mode=mode
        self.date=date
    }
}

class PaymentHistoryCell: UITableViewCell{
    
    @IBOutlet weak var detailTitle: CustomUILabelBold!
    @IBOutlet weak var detailDate: CustomUILabel!
    @IBOutlet weak var detailMode: CustomUILabel!
    @IBOutlet weak var detailAmount: CustomUILabelBold!
    
}

class PaymentHistoryViewController: BaseViewController, UITableViewDelegate,UITableViewDataSource {
    
    static func getInstance(storyboard: UIStoryboard) -> PaymentHistoryViewController{
        return storyboard.instantiateViewController(withIdentifier: String(describing: self.classForCoder())) as! PaymentHistoryViewController
    }
    
    @IBOutlet weak var payableUiViewHeight: UIView!
    @IBOutlet weak var payableHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var paymentAmountLabel: CustomUILabelBold!
    @IBOutlet weak var overdueDate: CustomUILabel!
    
    @IBOutlet weak var paymentTableView: CustomTableView!
    var paymentList=[PaymentHistoryModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="Payment History"

        // Do any additional setup after loading the view.
        hitApi()
    }
    
    private func hitApi(){
        self.showProgress()
        paymentList.removeAll()
        let params=["mode":"paymentHistory"]
        ApiClient.getJSONResponses(route: APIRouter.stasheasyApi(param: params)){
            result, status in
            self.hideProgress()
            switch status{
            case .success:
                
                if let json = try? JSON(data: result!){
                    
                    self.paymentAmountLabel.text="\(Constants.Values.RupeeSign) \(json["overdue"].stringValue)"
                    
                    if json["overdue"].doubleValue > 0{
                        self.payableHeightConstant.constant = 170
                        self.payableUiViewHeight.isHidden=false
                    }else{
                        self.payableHeightConstant.constant = 0
                        self.payableUiViewHeight.isHidden=false
                    }
                    
                    if let otherPays = json["payments"].array{
                        for pay in otherPays{ self.paymentList.append(PaymentHistoryModel(title:pay["payment_type"].stringValue,date:pay["final_received_date"].stringValue,amount:pay["actual_payment"].stringValue,mode:pay["payment_method"].stringValue))
                            
                        }
                    }
                }
                self.paymentList=self.paymentList.reversed()
                self.paymentTableView.reloadData()
                
            case .errors(let error):
                self.showToast(error)
            }
            
        }
    }
    
    @IBAction func payNowBtn(_ sender: UIButton) {
        self.openPaymentPage()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.paymentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "paymentHistoryCell",for:indexPath) as! PaymentHistoryCell
        let model:PaymentHistoryModel=paymentList[indexPath.row]
        
        cell.detailAmount.text="\(Constants.Values.RupeeSign) \(model.amount!)"
        cell.detailDate.text = Utilities.getFormattedDate(dateString: model.date!)
        cell.detailMode.text=model.mode
        cell.detailTitle.text=model.title
        return cell
    }
    
    
}
