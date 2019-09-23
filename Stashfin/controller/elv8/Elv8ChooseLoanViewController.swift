//
//  Elv8ChooseLoanViewController.swift
//  Stashfin
//
//  Created by Macbook on 31/05/19.
//  Copyright © 2019 Stashfin. All rights reserved.
//

import UIKit
import SwiftyJSON

class PlanModel{
    var planAmount,planType,planId:String?
    init(planId:String,planAmount:String,planType:String) {
        self.planType=planType
        self.planAmount=planAmount
        self.planId=planId
    }
}

class ChooseLoanCell : UITableViewCell{
    @IBOutlet weak var loanAmount: UILabel!
    @IBOutlet weak var planImg: UIImageView!
    @IBOutlet weak var loanName: CustomUILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        
    }
}

class Elv8ChooseLoanViewController: BaseLoginViewController,UITableViewDataSource,UITableViewDelegate {
    
    static func getInstance(storyboard: UIStoryboard) -> Elv8ChooseLoanViewController{
        return storyboard.instantiateViewController(withIdentifier: String(describing: self.classForCoder())) as! Elv8ChooseLoanViewController
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var planImg: UIImageView!
    @IBOutlet weak var planDetailsDesc: CustomUILabel!
    var planList=[PlanModel]()
    var apiResponse:Data?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateResponse(response:apiResponse);
        //        checkStatusApi()
    }
    
    
    private func checkStatusApi(){
        let params=["mode":"elv8_home_dashboard"]
        ApiClient.getJSONResponses(route: APIRouter.v2Api(param: params)){
            result,status in
            //            if let json = try? JSON(data:result!){
            self.updateResponse(response:result);
            //            }
        }
    }
    
    private func updateResponse(response:Data?){
        if let json = try? JSON(data:response!){
            
            if  let  plan_details = json["plans_details"].array{
                Log("count: \(plan_details.count)")
                self.setPlanTypes(planName: json["plans_details"][plan_details.count-1]["level_info"]["level_name"].stringValue)
                for i in 0..<plan_details.count{
                    
                    Log("plan_detail: \(plan_details[i])")
                    
                    self.planList.append(PlanModel(planId:plan_details[i]["level_info"]["id"].stringValue,planAmount: plan_details[i]["level_info"]["offered_amount"].stringValue, planType: plan_details[i]["level_info"]["level_name"].stringValue))
                    
                }
                Log("count db: \(self.planList.count)")
                self.tableView.reloadData()
            }
        }
    }
    
    //    String colorBronze = "#f3960c";
    //    String colorSilver = "#787878";
    //    String colorGold = "#F8C700";
    //    String colorPlatinum = "#736EA3";
    //    String colorDiamond = "#5A79E3";
    
    
    
    private func setPlanTypes(planName:String){
        var name:String="";
        Log("name:- \(planName)")
        var textColor:UIColor=#colorLiteral(red: 0.9529411765, green: 0.5882352941, blue: 0.04705882353, alpha: 1)
        switch(planName){
            
        case "Bronze":
            Log("")
            planImg.image=#imageLiteral(resourceName: "bronze_approved")
            name="Bronze"
            textColor=#colorLiteral(red: 0.9529411765, green: 0.5882352941, blue: 0.04705882353, alpha: 1)
        case "Silver":
            Log("")
            planImg.image=#imageLiteral(resourceName: "silver_approved")
            name="Silver"
            textColor=#colorLiteral(red: 0.4705882353, green: 0.4705882353, blue: 0.4705882353, alpha: 1)
        case "Gold":
            Log("")
            planImg.image=#imageLiteral(resourceName: "gold_approved")
            name="Gold"
            textColor=#colorLiteral(red: 0.9725490196, green: 0.7803921569, blue: 0, alpha: 1)
        case "Platinum":
            Log("")
            planImg.image=#imageLiteral(resourceName: "platinum_approved")
            name="Plantinum"
            textColor=#colorLiteral(red: 0.4509803922, green: 0.431372549, blue: 0.6392156863, alpha: 1)
        case "Diamond":
            Log("")
            planImg.image=#imageLiteral(resourceName: "diamond_approved")
            name="Diamond"
            textColor=#colorLiteral(red: 0.3529411765, green: 0.4745098039, blue: 0.8901960784, alpha: 1)
        default:
            Log("")
            planImg.image=#imageLiteral(resourceName: "bronze_approved")
            name="Bronze"
            textColor=#colorLiteral(red: 0.9529411765, green: 0.5882352941, blue: 0.04705882353, alpha: 1)
        }
        
        planDetailsDesc.attributedText = "You are now a \(name) level StashFin Elv8 member".attributedStringForPartiallyColoredText("\(name)", with: textColor)
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let plan=planList[indexPath.row]
        
        let controller=Elv8ChooseRepaymentViewController.getInstance(storyboard: self.storyBoardElv8)
        controller.planId=plan.planId!
        controller.apiResponse=self.apiResponse
        goToNextViewController(controller: controller)
        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.planList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "choose_loan",for: indexPath) as! ChooseLoanCell
        cell.loanAmount.text=self.planList[indexPath.row].planAmount
        cell.loanName.text=self.planList[indexPath.row].planType
        
        switch(self.planList[indexPath.row].planType){
            
        case "Bronze":
            cell.planImg.image=#imageLiteral(resourceName: "bronze_dashboard")
        case "Silver":
            cell.planImg.image=#imageLiteral(resourceName: "silver_dashboard")
        case "Gold":
            cell.planImg.image=#imageLiteral(resourceName: "gold_dashboard")
        case "Platinum":
            cell.planImg.image=#imageLiteral(resourceName: "platinum_dashboard")
        case "Diamond":
            cell.planImg.image=#imageLiteral(resourceName: "diamond_dashboard")
        default:
            cell.planImg.image=#imageLiteral(resourceName: "bronze_dashboard")
        }
        
        return cell
    }
    
}


extension String {
    
    func attributedStringForPartiallyColoredText(_ textToFind: String, with color: UIColor) -> NSMutableAttributedString {
        let mutableAttributedstring = NSMutableAttributedString(string: self)
        let range = mutableAttributedstring.mutableString.range(of: textToFind, options: .caseInsensitive)
        if range.location != NSNotFound {
            mutableAttributedstring.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        }
        return mutableAttributedstring
    }
}
