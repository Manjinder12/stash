//
//  Elv8ChooseRepaymentViewController.swift
//  Stashfin
//
//  Created by Macbook on 31/05/19.
//  Copyright © 2019 Stashfin. All rights reserved.
//

import UIKit
import SwiftyJSON

class RepaymentModel{
    var id,name,emi_tenure,total_tenure,emi_principal,emi_interest,emi_amount,total_amount,total_interest:String?
    init(id:String,name:String,emi_tenure:String,total_tenure:String,emi_principal:String,emi_interest:String,emi_amount:String,total_amount:String,total_interest:String) {
        self.name=name
        self.id=id
        self.emi_tenure=emi_tenure
        self.total_tenure=total_tenure
        self.emi_principal=emi_principal
        self.emi_interest=emi_interest
        self.emi_amount=emi_amount
        self.total_amount=total_amount
        self.total_interest=total_interest
    }
}


class EmiDetailsCell :UITableViewCell{
    
    @IBOutlet weak var emiNumberLabel: CustomUILabel!
    @IBOutlet weak var emiDateLabel: CustomUILabel!
    @IBOutlet weak var emiAmountLabel: CustomUILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
}

class RepaymentCell:UITableViewCell{
    override func awakeFromNib() {
        super.awakeFromNib()
        //        let tap = UITapGestureRecognizer(target: self, action: #selector("emiDetailsBtn:"))
        //            let tap = UITapGestureRecognizer(target: self, action: Selector("emiDetailsBtn:"))
        let tap = UITapGestureRecognizer(target: self, action: #selector(emiDetailsBtn(_:)))
        emiDetailsView.addGestureRecognizer(tap)
        emiDetailsView.isUserInteractionEnabled = true
    }
    
    var getLoanCallback:(()->Void)?
    var emiDetailsCallback:(()->Void)?
    
    @IBOutlet weak var loanAmount: CustomUILabelBold!
    @IBOutlet weak var planDesc: CustomUILabel!
    @IBOutlet weak var planTenure: CustomUILabel!
    @IBOutlet weak var planPrincipal: CustomUILabel!
    @IBOutlet weak var planInterest: CustomUILabel!
    @IBOutlet weak var planPayable: CustomUILabel!
    @IBOutlet weak var emiDetailsView: UIView!
    
    
    @IBAction func getLoanBtn(_ sender: UIButton) {
        getLoanCallback?()
    }
    
    
    @objc func emiDetailsBtn(_ sender: UITapGestureRecognizer) {
        print("bigButtonTapped")
        emiDetailsCallback?()
    }
    
}

class Elv8ChooseRepaymentViewController: BaseLoginViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    static func getInstance(storyboard: UIStoryboard) -> Elv8ChooseRepaymentViewController{
        return storyboard.instantiateViewController(withIdentifier: String(describing: self.classForCoder())) as! Elv8ChooseRepaymentViewController
    }
    
    var planId="";
    var repaymentId=""
    var apiResponse:Data?
    var planList=[RepaymentModel]()
    var loanAmount=""
    var emiCount=0
    var emiDetailsAmount=""
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var elv8DialogView: UIView!
    @IBOutlet weak var emiDialogView: CardView!
    @IBOutlet weak var emiDetailsTableView: UITableView!
    @IBOutlet weak var emiDialogHeight: NSLayoutConstraint!
    @IBOutlet weak var elv8InfoView: UIView!
    @IBOutlet weak var showElv8InfoView: UIView!
    
    @IBOutlet weak var elv8TenureLabel: UILabel!
    @IBOutlet weak var elv8PrinicpalLabel: UILabel!
    @IBOutlet weak var elv8EmiLabel: UILabel!
    @IBOutlet weak var elv8PayableLabel: UILabel!
    @IBOutlet weak var elv8LoanLabel: UILabel!
    
    
    @IBAction func elv8DialogConfirmView(_ sender: UIButton) {
        self.showProgress()
        let params=["repayment_plan_id":repaymentId,"level_id":planId,"mode":"elv8_save_selected_plan"]
        ApiClient.getJSONResponses(route: APIRouter.v2Api(param: params)){
            result,status in
            self.hideProgress()
//            if let json = try? JSON(data:result!){
                self.changeViewController(response:result)
//            }
        }
    }
    
    @IBAction func crossDialogElv8InfoBtn(_ sender: UIButton) {
        elv8InfoView.isHidden=true
    }
    
    
    @IBAction func crossEmiBtn(_ sender: UIButton) {
        emiDialogView.isHidden=true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Log("id: \(planId)")
        // Do any additional setup after loading the view.
        updateResponse(response:apiResponse)
        emiDialogHeight.constant=(5*35)+110
         elv8InfoView.isHidden=false
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(showEmiInfoView(_:)))
        showElv8InfoView.addGestureRecognizer(tap)
        showElv8InfoView.isUserInteractionEnabled = true
    }
    
    @objc func showEmiInfoView(_ sender: UITapGestureRecognizer) {
       elv8InfoView.isHidden=false
    }
    
    private func updateResponse(response:Data?){
        self.planList.removeAll()
        if let json = try? JSON(data:response!){
            if  let  plan_details = json["plans_details"].array{
                Log("count: \(plan_details.count)")
                for i in 0..<plan_details.count{
                    
                    Log("plan_detail: \(plan_details[i])")
                    
                    if plan_details[i]["level_info"]["id"].stringValue == planId{ loanAmount=plan_details[i]["level_info"]["offered_amount"].stringValue
                        
                        if let repaymentList=plan_details[i]["repayment_plan_info"].array{
                            
                            for i1 in 0..<repaymentList.count{
                                self.planList.append(RepaymentModel(id:repaymentList[i1]["id"].stringValue,name: repaymentList[i1]["name"].stringValue, emi_tenure: repaymentList[i1]["emi_tenure"].stringValue, total_tenure: repaymentList[i1]["total_tenure"].stringValue, emi_principal: repaymentList[i1]["emi_principal"].stringValue, emi_interest: repaymentList[i1]["emi_interest"].stringValue, emi_amount: repaymentList[i1]["emi_amount"].stringValue, total_amount: repaymentList[i1]["total_amount"].stringValue, total_interest: repaymentList[i1]["total_interest"].stringValue)
                                )
                            }
                        }
                    }
                }
                Log("count db: \(self.planList.count)")
                self.tableView.reloadData()
                
            }
        }
    }
    
    @IBAction func nextBtn(_ sender: UIButton) {
        self.changeViewController(controllerName: Constants.Controllers.EL_HOME)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView==self.tableView{
            return planList.count
        }else{
            return emiCount
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView==self.emiDetailsTableView{
            let cell = tableView.dequeueReusableCell(withIdentifier: "emiDetailsCell",for: indexPath) as! EmiDetailsCell
            cell.emiAmountLabel.text=self.emiDetailsAmount
            let tenure:Int=Int(self.planList[indexPath.row].emi_tenure!)! * (indexPath.row + 1)
            cell.emiDateLabel.text=getDate(days:"\(tenure)")
            cell.emiNumberLabel.text="\(indexPath.row+1)"
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "repaymentCell",for: indexPath) as! RepaymentCell
            
            cell.loanAmount.text = loanAmount
            cell.planTenure.text="\(self.planList[indexPath.row].emi_tenure!) Days"
            cell.planPayable.text=self.planList[indexPath.row].total_amount
            cell.planPrincipal.text=loanAmount
            cell.planInterest.text=self.planList[indexPath.row].total_interest
            cell.planDesc.text=self.planList[indexPath.row].name
            
            cell.getLoanCallback={
                Log("clicked")
                //            self.showToast("row: \(indexPath.row)")
                self.repaymentId=self.planList[indexPath.row].id!
                self.elv8TenureLabel.text=self.planList[indexPath.row].emi_tenure
                self.elv8PrinicpalLabel.text=self.planList[indexPath.row].emi_principal
                self.elv8EmiLabel.text=self.planList[indexPath.row].total_interest
                self.elv8PayableLabel.text=self.planList[indexPath.row].total_amount
                self.elv8LoanLabel.text=self.loanAmount
                self.elv8DialogView.isHidden=false
            }
            
            cell.emiDetailsCallback={
                Log("clicked")
                self.emiDialogView.isHidden=false
                //            self.showToast("row: \(indexPath.row)")
                self.emiCount=(Int(self.planList[indexPath.row].total_tenure.isNilOrValue)!/Int(self.planList[indexPath.row].emi_tenure.isNilOrValue)!)
                self.emiDetailsAmount=self.planList[indexPath.row].emi_amount.isNilOrValue
                self.emiDialogHeight.constant=CGFloat((self.emiCount*35)+110)
                self.emiDetailsTableView.reloadData()
            }
            return cell
        }
    }
    
    @IBAction func crossBtn(_ sender: UIButton) {
        self.elv8DialogView.isHidden=true
    }
 
    private func getDate(days:String)->String{
        let formatterShow = DateFormatter()
        formatterShow.dateFormat = "dd-MM-yyyy"
        let date = Date()
        let calendar = Calendar.current
//        let day1 = formatterShow.string(from: date)
        let day1 = formatterShow.string(from: calendar.date(byAdding: .day, value: Int(days)!, to: date)!)
//        let day3 = formatterShow.string(from: calendar.date(byAdding: .day, value: 2, to: date)!)
//        let day4 = formatterShow.string(from: calendar.date(byAdding: .day, value: 3, to: date)!)
//        var dateList = [String]()
//        dateList.append(day1)
//        dateList.append(day2)
//        dateList.append(day3)
//        dateList.append(day4)
        return "\(day1)"
    }
    
}
