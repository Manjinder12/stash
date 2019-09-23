//
//  BillPayNowViewController.swift
//  Stashfin
//
//  Created by Macbook on 04/07/19.
//  Copyright © 2019 Stashfin. All rights reserved.
//

import UIKit
import SwiftyJSON

class BillPayModel{
    var billStatus:Bool=false
    var billAmount:Int=0
    var billDate,loanId:String?
    
    init(billStatus:Bool,billAmount:Int,billDate:String,loanId:String="") {
        self.billStatus=billStatus
        self.billAmount=billAmount
        self.billDate=billDate
        self.loanId=loanId
    }
}

class BillCell: UITableViewCell{
    var billLoanCallback:(()->Void)?
    
    @IBOutlet weak var billButton: UIButton!
    @IBOutlet weak var amountBillLabel: UILabel!
    @IBOutlet weak var dateBillLabel: UILabel!
    
    @IBAction func billLoanCellCheckBox(_ sender: UIButton) {
        billLoanCallback?()
    }
    
}

class BillPayNowViewController: BaseLoginViewController,UITableViewDataSource,UITableViewDelegate {
    
    static func getInstance(storyBoard: UIStoryboard)->BillPayNowViewController{
        return storyBoard.instantiateViewController(withIdentifier: String(describing: self.classForCoder())) as! BillPayNowViewController
    }
    
    var billList=[BillPayModel]()
    
    
    
    @IBOutlet weak var paymentUiVIewHeight: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var amountTitle: CustomUILabelBold!
    @IBOutlet weak var amountRupee: CustomUILabel!
    @IBOutlet weak var billAmountDetails: UIView!
    @IBOutlet weak var billAmountHeight: NSLayoutConstraint!
    @IBOutlet weak var emiAmountDetails: UIView!
    @IBOutlet weak var emiAmountHeight: NSLayoutConstraint!
    @IBOutlet weak var billBtn: UIButton!
    @IBOutlet weak var emiButton: UIButton!
    @IBOutlet weak var emiPayNowField: UITextField!
    @IBOutlet weak var billTableView: UITableView!
    @IBOutlet weak var billTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var billDateLabel: CustomUILabel!
    @IBOutlet weak var emiDateLabel: CustomUILabel!
    @IBOutlet weak var emiLabel: CustomUILabelBold!
    @IBOutlet weak var overdueLabel: CustomUILabelBold!
    @IBOutlet weak var latePaymentLabel: CustomUILabelBold!
    @IBOutlet weak var processingLabel: CustomUILabelBold!
    @IBOutlet weak var billUiView: CardView!
    @IBOutlet weak var emiUiView: CardView!
    @IBOutlet weak var emiBillStackView: UIStackView!
    @IBOutlet weak var foreCloseBtn: UIButton!
    
    @IBOutlet weak var billCheckBox: UIButton!
    @IBOutlet weak var emiCheckBox: UIButton!
    var EMI_MODE = "0"
    var chargesList=[String]()
    var foreCloseAmount = 0.0
    var emiAmount = 0.0
    let foreClose="Make Foreclosure Payment"
    let wantForeclose="I want to pre pay my dues / foreclose"
    let dropDown=DropDown()
    let emiDropDown = DropDown()
    
    @IBOutlet weak var termsAndCondition: UITextField!
    @IBOutlet weak var totalAmoutUiView: UIView!
    @IBOutlet weak var emiInfoBtn: UIButton!
    @IBOutlet weak var chargesInfoBtn: UIButton!
    @IBOutlet weak var billAmountLabel: UILabel!
    @IBOutlet weak var billAmountRs: UILabel!
    @IBOutlet weak var emiAmountLabel: UILabel!
    @IBOutlet weak var amiAmountRs: UILabel!
    @IBOutlet weak var totalAmountLabel: UILabel!
    var billChecked=true
    var emiChecked=true
    
    @IBAction func billAmountBtn(_ sender: UIButton) {
        let billAMnt:Double = Double(billAmountLabel.text ?? "0") ?? 0.0
        if billAMnt > 0.0 {
            
            UIView.animate(withDuration: 0.3, animations: {
                sender.transform = sender.transform.rotated(by: CGFloat(Double.pi ))
            })
            
            if billAmountHeight.constant == 60 {
                UIView.transition(with: billAmountDetails, duration: 0.3, options: .showHideTransitionViews, animations: {
                    self.billAmountDetails.isHidden=false
                })
                
                let height = self.paymentUiVIewHeight.constant + CGFloat(getBillHeight())
                if height > 200 {
                    self.paymentUiVIewHeight.constant =  height
                }else{
                    self.paymentUiVIewHeight.constant =  300
                }
                
                self.billAmountHeight.constant = CGFloat(getBillHeight()+70)
                self.billTableViewHeight.constant = CGFloat(getBillHeight())
                
                //            self.paymentUiVIewHeight.constant =  height
                Log("height cell bill : \(height)")
                UIView.animate(withDuration: 0.2) {
                    self.view.layoutIfNeeded()
                }
            }else{
                
                self.paymentUiVIewHeight.constant =  self.paymentUiVIewHeight.constant - CGFloat(getBillHeight())
                UIView.transition(with: billAmountDetails, duration: 0.3, options: .showHideTransitionViews, animations: {
                    self.billAmountDetails.isHidden=true
                })
                self.billAmountHeight.constant = 60
                UIView.animate(withDuration: 0.3) {
                    self.view.layoutIfNeeded()
                }
            }
        }else{
            self.showToast("No Bills Data Found")
        }
    }
    
    @IBAction func emiAmountBtn(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.3, animations: {
            sender.transform = sender.transform.rotated(by: CGFloat(Double.pi ))
        })
        
        if emiAmountHeight.constant == 60 {
            UIView.transition(with: emiAmountDetails, duration: 0.3, options: .showHideTransitionViews, animations: {
                self.emiAmountDetails.isHidden=false
            })
            
            //            let height = self.paymentUiVIewHeight.constant + CGFloat(getBillHeight())
            //            if height > 200 {
            //                self.paymentUiVIewHeight.constant =  height
            //            }else{
            //                self.paymentUiVIewHeight.constant =  300
            //            }
            
            self.paymentUiVIewHeight.constant = paymentUiVIewHeight.constant + 300
            self.emiAmountHeight.constant = 270
            UIView.animate(withDuration: 0.2) {
                self.view.layoutIfNeeded()
            }
        }else{
            
            self.paymentUiVIewHeight.constant =  self.paymentUiVIewHeight.constant - 300
            UIView.transition(with: emiAmountDetails, duration: 0.3, options: .showHideTransitionViews, animations: {
                self.emiAmountDetails.isHidden=true
            })
            self.emiAmountHeight.constant = 60
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="Pay Bill & EMI"
        self.view.bringSubviewToFront(billUiView)
        self.view.sendSubviewToBack(totalAmoutUiView)
        totalAmoutUiView.isUserInteractionEnabled=false
        self.emiAmountHeight.constant = 60
        self.billAmountHeight.constant = 60
        self.billAmountDetails.isHidden=true
        self.emiAmountDetails.isHidden=true
        self.paymentUiVIewHeight.constant=400
        
//        if SessionManger.getInstance.isBillCustomer(){
//            self.billAmountHeight.constant = 60
//        }else{
//            self.billUiView.isHidden=true
//            self.billAmountHeight.constant = 0
//            self.emiButton.sendActions(for: UIControl.Event.touchUpInside)
//            self.emiCheckBox.isUserInteractionEnabled=false
//        }
//
        
        amountRupee.text=Constants.Values.RupeeSign
        billAmountRs.text="\(Constants.Values.RupeeSign)"
        amiAmountRs.text="\(Constants.Values.RupeeSign)"
        
        
        emiPayNowField.addTarget(self, action: #selector(amountChange), for: .editingChanged)
        //        billBtn.sendActions(for: .touchUpInside)
        //        emiButton.sendActions(for: .touchUpInside)
        
        hitApi()
    }
    
    private func hitApi(){
        //        billDateLabel
        self.showProgress()
        let params=["mode":"emiPayment"]
        ApiClient.getJSONResponses(route: APIRouter.v2Api(param: params)){
            result, status in
            self.hideProgress()
            switch status {
            case .success:
                if let json = try? JSON(data: result!){
                    //                    if let dues = json["dues"].int, dues == 0{
                    
                    //                        self.emiDateLabel.text = json["emi_date"].stringValue
                    self.emiLabel.text = Constants.Values.RupeeSign +  "\(json["principle"].doubleValue + json["interest"].doubleValue)"
                    //                        self.interestLabel.text = Constants.Values.RupeeSign + "\(json["interest"].doubleValue)"
                    let emiTotal = json["principle"].doubleValue + json["interest"].doubleValue
                    
                    var emiList=[String]()
                    emiList.append("Principle : \(json["principle"].doubleValue)")
                    emiList.append("Interest : \(json["interest"].doubleValue)")
                    if emiTotal>0{
                        self.emiDropDown.dataSource=emiList
                        self.emiInfoBtn.isHidden=false
                    }else{
                        self.emiInfoBtn.isHidden=true
                    }
                    
                    self.overdueLabel.text = Constants.Values.RupeeSign + "\(json["overdue"].doubleValue)"
                    
                    self.emiDateLabel.text = "EMI date : \(Utilities.getFormattedDate(dateString: json["emi_date"].stringValue,formatIn: "yyyy-MM-dd"))"
                    self.billDateLabel.text="Bill Date : \(Utilities.getFormattedDate(dateString: json["bill_date"].stringValue,formatIn: "yyyy-MM-dd"))"
                    
                    var totalCharges=0.0
                    let bounce = json["charges"]["Bounce"].doubleValue
                    let late = json["charges"]["Late"].doubleValue
                    let pickup = json["charges"]["Pickup"].doubleValue
                    let other = json["charges"]["Other"].doubleValue
                    let card = json["charges"]["Card"].doubleValue
                    
                    if bounce>0{ self.chargesList.append("Bounce charges : \(bounce)")
                        totalCharges = totalCharges + bounce
                    }
                    if late>0{
                        self.chargesList.append("Late : \(late)")
                        totalCharges = totalCharges + late
                    }
                    if pickup>0{
                        self.chargesList.append("Pickup charges : \(pickup)")
                        totalCharges = totalCharges + pickup
                    }
                    if other>0{
                        self.chargesList.append("Other charges : \(other)")
                        totalCharges = totalCharges + other
                    }
                    if card>0{
                        self.chargesList.append("Card charges : \(card)")
                        totalCharges = totalCharges + card
                    }
                    
                    self.latePaymentLabel.text = Constants.Values.RupeeSign + "\(totalCharges)"
                    if totalCharges>0{
                        self.dropDown.dataSource=self.chargesList
                        self.chargesInfoBtn.isHidden=false
                    }else{
                        self.chargesInfoBtn.isHidden=true
                    }
                    
                    self.latePaymentLabel.text = Constants.Values.RupeeSign + "\(totalCharges)"
                    
                    self.processingLabel.text = "\(json["processing_fee"].doubleValue)"
                    
                    self.emiPayNowField.text = "\(json["total_emi_amount"].doubleValue)"
                    
                    self.emiAmountLabel.text = "\(json["total_emi_amount"].doubleValue)"
                    self.foreCloseAmount=json["foreclose"].doubleValue
                    self.emiAmount=json["emi_amount"].doubleValue
                    self.billList.removeAll()
                    
                    if let billArray = json["bills"].array{
                        for bill in billArray{
                            self.billList.append(BillPayModel(billStatus: true,billAmount: bill["amount"].intValue,billDate: bill["date"].stringValue,loanId: bill["loan_id"].stringValue))
                        }
                    }
                    if self.billList.count>0{
                        self.billAmountHeight.constant = 60
                        self.billUiView.isHidden=false
                    }else{
                        self.billUiView.isHidden=true
                        self.billAmountHeight.constant = 0
                        self.emiButton.sendActions(for: UIControl.Event.touchUpInside)
                        self.emiCheckBox.isUserInteractionEnabled=false
                    }
                    
                    self.billTableView.reloadData()
                    
                    self.checkForecloseStatus()
                    self.updateTotalAmount()
                    //                    }else{
                    //                        self.openHomePageDialog(title: "Pay EMI", message: "No paymnet due found!!\nPlease try later")
                    //                    }
                }
            case .errors(let error):
                Log(error)
                self.openHomePageDialog(title: "Pay EMI", message: "No paymnet due found!!\nPlease try later")
                
            }
        }
    }
    
    private func checkForecloseStatus(){
        if self.foreCloseAmount>2{
            self.foreCloseBtn.setTitle(self.foreClose, for: .normal)
            self.foreCloseBtn.setTitleColor(.red, for: .normal)
        }else{
            self.foreCloseBtn.setTitle(self.wantForeclose, for: .normal)
        }
    }
    
    @objc func amountChange() {
        updateTotalAmount()
        let emiAmount:Double = Double(emiPayNowField.text ?? "0") ?? 0.0
        
        if emiAmount == 0 {
            emiCheckBox.setBackgroundImage(#imageLiteral(resourceName: "check_box-1"), for: .normal)
            emiChecked=false
        }else{
            emiCheckBox.setBackgroundImage(#imageLiteral(resourceName: "check_box_checked"), for: .normal)
            emiChecked=true
        }
    }
    
    private func getBillHeight() -> Int{
        let height = (billList.count * 40)+50
        return height
    }
    
    private func updateTotalAmount(){
        //        let stringBill:String = billAmountLabel.text ?? "0"
        
        var emiAmount = 0.0
        if emiChecked{
            emiAmount = Double(emiPayNowField.text ?? "0") ?? 0.0
        }
        var billAmountCount = 0.0
        var allBillStatus = true
        var totalBillAmount=0
        
        for bill in billList{
            totalBillAmount = totalBillAmount + bill.billAmount
            if bill.billStatus{
                billAmountCount = billAmountCount + Double(bill.billAmount)
            }else{
                allBillStatus=false
            }
        }
        billAmountLabel.text = "\(totalBillAmount)"
        if allBillStatus{
            billCheckBox.setBackgroundImage(#imageLiteral(resourceName: "check_box_checked"), for: .normal)
            billChecked=true
        }else{
            billCheckBox.setBackgroundImage(#imageLiteral(resourceName: "check_box-1"), for: .normal)
            billChecked=false
        }
        
        totalAmountLabel.text = "\(emiAmount + billAmountCount)"
        
    }
    
    
    @IBAction func chargesinfoBtn(_ sender: UIButton) {
        dropDown.show()
    }
    
    @IBAction func emiInfoBtn(_ sender: UIButton) {
        emiDropDown.show()
    }
    
    
    @IBAction func submitBtn(_ sender: UIButton) {
        //        self.showToast("Testing...")
        SessionManger.getInstance.saveLocResponse(locResponse: "")
        
        if let amount = Double(self.totalAmountLabel.text ?? "0"), amount > 1.0{
            let controller = WebViewViewController.getInstance(storyBoard: self.storyBoardMain)
            controller.url = ""
            controller.urlType = "payment"
            controller.paymentModel = PaymentAmountModel(amount:"\(amount)", mode:EMI_MODE, paymentCode:"", billId: self.getBillId())
            self.goToNextViewController(controller:controller)
        }else{
            self.showToast("Amount should be more than \(Constants.Values.RupeeSign)100")
        }
    }
    
    private func getBillId() -> String{
        var billIds=""
        for bill in billList{
            if bill.billStatus{
                if billIds.count==0{
                    billIds = bill.loanId ?? ""
                }else{
                    billIds = "\(billIds),\(bill.loanId ?? "")"
                }
            }
        }
        Log("bill ids: \(billIds)")
        return billIds;
    }
    
    @IBAction func foreCloseBtn(_ sender: UIButton) {
        switch sender.currentTitle.isNilOrValue {
        case "Pay EMI":
            self.showProgress()
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1) , execute: {
                self.hideShowView(showStatus: true)
                self.checkForecloseStatus()
            })
            
        case foreClose:
            self.showProgress()
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1) , execute: {
                self.hideShowView(showStatus: false)
                sender.setTitle("Pay EMI", for: .normal)
            })
            
            
        case wantForeclose:
            let alert = UIAlertController.init(title: "Foreclose Loan", message: "\nLet us know your reason for this request. Our customer support team will contact you.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Send Request", style: .default, handler: {(_)-> Void in
                self.changeViewController(controllerName: Constants.Controllers.CUSTOMER_CARE)
            }))
            self.present(alert, animated: true, completion: nil)
        default:
            Log("No action \(sender.currentTitle.isNilOrValue)")
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return billList.count
    }
    
    @IBAction func billAmountCheckBox(_ sender: UIButton) {
        if billChecked{
            sender.setBackgroundImage(#imageLiteral(resourceName: "check_box-1"), for: .normal)
            billChecked=false
            for bill in billList{
                bill.billStatus = false
            }
        }else{
            sender.setBackgroundImage(#imageLiteral(resourceName: "check_box_checked"), for: .normal)
            billChecked=true
            for bill in billList{
                bill.billStatus = true
            }
        }
        
        updateTotalAmount()
        billTableView.reloadData()
    }
    
    @IBAction func emiAmountCheckBox(_ sender: UIButton) {
        if emiChecked{
            sender.setBackgroundImage(#imageLiteral(resourceName: "check_box-1"), for: .normal)
            emiChecked=false
        }else{
            sender.setBackgroundImage(#imageLiteral(resourceName: "check_box_checked"), for: .normal)
            emiChecked=true
        }
        updateTotalAmount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "billCell") as! BillCell
        cell.amountBillLabel.text = "\(Constants.Values.RupeeSign) \(billList[indexPath.row].billAmount)"
        cell.dateBillLabel.text = billList[indexPath.row].billDate
        cell.billLoanCallback={
            Log("clicked \(indexPath.row)")
            if self.billList[indexPath.row].billStatus{
                cell.billButton.setBackgroundImage(#imageLiteral(resourceName: "check_box-1"), for: .normal)
                self.billList[indexPath.row].billStatus=false
            }else{
                cell.billButton.setBackgroundImage(#imageLiteral(resourceName: "check_box_checked"), for: .normal)
                self.billList[indexPath.row].billStatus=true
            }
            
            self.updateTotalAmount()
        }
        if self.billList[indexPath.row].billStatus{
            cell.billButton.setBackgroundImage(#imageLiteral(resourceName: "check_box_checked"), for: .normal)
        }else{
            cell.billButton.setBackgroundImage(#imageLiteral(resourceName: "check_box-1"), for: .normal)
        }
        return cell
    }
    
    
    private func hideShowView(showStatus:Bool){
        self.hideProgress()
        if showStatus {
            
            UIView.transition(with: self.emiBillStackView, duration: 0.3, options: .showHideTransitionViews, animations: {
                self.emiBillStackView.isHidden=false
                //                self.billUiView.isUserInteractionEnabled=true
                self.EMI_MODE="0"
                self.amountTitle.text = "Total Amount Due"
                self.totalAmountLabel.text="\(self.emiAmount)"
                
                self.emiAmountHeight.constant = 60
                self.billAmountHeight.constant = 60
                
                self.paymentUiVIewHeight.constant=400
                //                self.amountDue.text="\(self.emiAmount)"
            })
        }
        else {
            self.emiAmountHeight.constant = 10
            self.billAmountHeight.constant = 10
            self.billAmountDetails.isHidden=true
            self.emiAmountDetails.isHidden=true
            self.paymentUiVIewHeight.constant=400
            
            scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            UIView.transition(with: self.emiBillStackView, duration: 0.3, options: .showHideTransitionViews, animations: {
                self.emiBillStackView.isHidden=true
                //                self.emiBillStackView.isUserInteractionEnabled=false
                self.amountTitle.text = "Foreclose Amount"
                self.EMI_MODE="1"
                self.totalAmountLabel.text="\(self.foreCloseAmount)"
                //                self.amountDue.text="\(self.foreCloseAmount)"
                
            })
        }
    }
}

