//
//  BillLoadMyCardViewController.swift
//  Stashfin
//
//  Created by Macbook on 04/07/19.
//  Copyright © 2019 Stashfin. All rights reserved.
//

import UIKit
import SwiftyJSON

class BillLoadMyCardViewController: BaseLoginViewController {

    static func getInstance(storyboard: UIStoryboard) -> BillLoadMyCardViewController{
        return storyboard.instantiateViewController(withIdentifier: String(describing: self.classForCoder())) as! BillLoadMyCardViewController
    }
    
    @IBOutlet weak var amountRupee: UILabel!
    @IBOutlet weak var amountSlider: UISlider!
    @IBOutlet weak var tenureSlider: UISlider!
    @IBOutlet weak var minAmountLabel: UILabel!
    @IBOutlet weak var maxAmountLabel: UILabel!
    @IBOutlet weak var minTenureLabel: UILabel!
    @IBOutlet weak var maxTenureLabel: UILabel!
    @IBOutlet weak var remainingBalanceLabel: UILabel!
    @IBOutlet weak var expectedEmiLabel: UILabel!
    @IBOutlet weak var loadNowBtn: UIButton!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var tenureLabel: UILabel!
    var min_tenure:Int = 0
    var min_amount:Double = 0
    var max_amount:Double = 0
    var request_amount_step:Int = 1000
    var roi:Double = 0
    private var popGesture: UIGestureRecognizer?
    
    //    var amount:Double = 0
    //    var tenure:Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "LOC"
        // Do any additional setup after loading the view.
        hitLocApi()
        amountRupee.text="\(Constants.Values.RupeeSign)"
        if navigationController!.responds(to: #selector(getter: UINavigationController.interactivePopGestureRecognizer)) {
            self.popGesture = navigationController!.interactivePopGestureRecognizer
            self.navigationController!.view.removeGestureRecognizer(navigationController!.interactivePopGestureRecognizer!)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let gesture = self.popGesture {
            self.navigationController!.view.addGestureRecognizer(gesture)
        }
        
    }
    
    private func hitLocApi(){
        self.showProgress()
        let params=["mode":"locWithdrawalRequestform"]
        ApiClient.getJSONResponses(route: APIRouter.stasheasyApi(param: params)){
            result, status in
            self.hideProgress()
            switch status{
            case.success:
                if let json = try? JSON(data: result!){
                    self.min_tenure = json["min_tenure"].intValue
                    self.min_amount = json["minimum_request_amount"].doubleValue
                    if json["request_amount_increment_step"].intValue > 100{
                        self.request_amount_step = json["request_amount_increment_step"].intValue
                    }else{
                        self.request_amount_step = 500
                    }
                    
                    self.max_amount = json["remaining_loc"].doubleValue
                    let max_tenure = json["max_tenure"].intValue
                    self.amountSlider.maximumValue = Float(self.max_amount-self.min_amount)
                    self.amountSlider.value=Float(self.request_amount_step)
                    self.tenureSlider.value=3.0
                    self.tenureSlider.maximumValue = Float(((max_tenure/3) - (self.min_tenure/3)))
                    self.tenureSlider.minimumValue=0
                    self.amountSlider.minimumValue=0
                    
                    self.maxAmountLabel.text = Constants.Values.RupeeSign + json["remaining_loc"].stringValue
                    self.minAmountLabel.text = Constants.Values.RupeeSign + "\(self.min_amount)"
                    self.minTenureLabel.text = "\(self.min_tenure) months"
                    self.maxTenureLabel.text = "\(json["max_tenure"].stringValue) months"
                    self.remainingBalanceLabel.text =  Constants.Values.RupeeSign + json["remaining_loc"].stringValue
                    self.roi = json["rate_of_interest"].doubleValue
                    
                    self.amountLabel.text = "\(json["minimum_request_amount"].intValue)"
                    self.tenureLabel.text = "\(json["min_tenure"].intValue)"
                    
//                    self.calculateEmi()
                    self.tenureSlider.setValue(self.tenureSlider.maximumValue, animated: true)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.5){
                        self.caculateTenure(self.tenureSlider.maximumValue)
                    }
                }
            case .errors(let error):
                self.openHomePageDialog(title: "LOC Card", message: error)
            }
        }
    }
    
    func calculateEmi() {
        let interestRateVal = self.roi / 100
        
        guard let amount = Double(amountLabel.text.isNilOrValue), amount > 10 else{
            return
        }
       
        guard let tenure = Double(tenureLabel.text.isNilOrValue), tenure > 1 else {
            return
        }
        
        let emi = Int((amount * interestRateVal * pow((1+interestRateVal),tenure)) / (pow((1 + interestRateVal), tenure)-1))
        
//        Log("Loan details:  \(amount) **** \(interestRateVal) ***** \(tenure)  **** \(emi)")
        self.expectedEmiLabel.text =    Constants.Values.RupeeSign + "\(emi)"
        
        self.remainingBalanceLabel.text =  Constants.Values.RupeeSign + "\(max_amount - amount)"

    }
    
    fileprivate func caculateTenure(_ value:Float) {
        DispatchQueue.main.async {
            let tenure = Double((Int(value)*3)+self.min_tenure)
            Log("tenure details:  **** \(value) ***** \(tenure)")
            self.tenureLabel.text = "\(Int(tenure))"
            
            self.calculateEmi()
        }
    }
    
    @IBAction func tenureSliderAction(_ sender: UISlider) {
        caculateTenure(sender.value)
    }
    
    @IBAction func amountSliderAction(_ sender: UISlider) {
        DispatchQueue.main.async {
            
            if sender.isTracking{
                let progress = Int(sender.value)
                let amount = Double(((progress - (progress % self.request_amount_step)) + Int(self.min_amount)))
                self.amountLabel.text = "\(amount)"
                self.calculateEmi()
                   Log("amount details:  **** \(sender.value) ***** \(amount)")
            }else{
                if let amnt = Double(self.amountLabel.text.isNilOrValue),amnt>1{
                    self.validateEmi(amount: "\(amnt)")
                }
            }
        }
    }
    
    private func validateEmi(amount:String){
        self.showProgress()
        let params=["mode":"locGetTenure","amount":amount]
        ApiClient.getJSONResponses(route: APIRouter.stasheasyApi(param: params)){
            result, status in
            self.hideProgress()
            switch status{
            case .success:
                
                if let json = try? JSON(data: result!){
                    self.min_tenure = json["min_tenure"].intValue
                    
                    let max_tenure = json["max_tenure"].intValue
                    self.tenureSlider.maximumValue = Float(((max_tenure/3) - (self.min_tenure/3)))
                    self.minTenureLabel.text = "\(self.min_tenure) months"
                    self.maxTenureLabel.text = "\(max_tenure) months"
                    self.tenureLabel.text = json["min_tenure"].stringValue
                    
                    self.tenureSlider.setValue(self.tenureSlider.maximumValue, animated: true)
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.5){
                        self.caculateTenure(self.tenureSlider.maximumValue)
                    }
                    
                    if let msg = json["msg"].string, msg.count>3{
                        self.showToast(msg,showDialog: true,title: "LOC Card")
                    }
                }
                
            case .errors(let error):
                self.showToast(error,showDialog: true,title: "LOC Card")
            }
        }
    }
    
    @IBAction func confirmBtn(_ sender: UIButton) {
        checkLocDetailsApi()
    }
    
    private func checkLocDetailsApi(){
        self.showProgress()
        let params=["mode":"locWithdrawalRequest","amount":"\(amountLabel.text.isNilOrValue)","tenure":"\(tenureLabel.text.isNilOrValue)"]
        ApiClient.getJSONResponses(route: APIRouter.stasheasyApi(param: params)){
            result, status in
            self.hideProgress()
            switch status{
            case .success:
                self.changeViewController(controllerName: Constants.Controllers.BILL_LOAD_MY_CARD_CONFIRM, response: result)
                
            case .errors(let error):
                self.showToast(error,showDialog: true,title: "LOC Card")
            }
        }
    }
    
}