//
//  OutgoingBillViewController.swift
//  Stashfin
//
//  Created by Macbook on 03/07/19.
//  Copyright © 2019 Stashfin. All rights reserved.
//

import UIKit
import SwiftyJSON

class BillModel{
    var amount,date:String?
    var status:Int
    
    init(amount:String,date:String,status:Int=0){
        self.amount=amount
        self.date=date
        self.status=status
    }
}

class OutgoingCell: UITableViewCell{
    @IBOutlet weak var dateTitle: CustomUILabelBold!
    @IBOutlet weak var amountTitle: CustomUILabelBold!
    @IBOutlet weak var dateFeild: CustomUILabel!
    @IBOutlet weak var amountFeild: CustomUILabel!
    @IBOutlet weak var outgoingCellView: UIView!
    
}

class OutgoingBillViewController: BaseLoginViewController,UITableViewDataSource,UITableViewDelegate {
    
    static func getInstance(storyBoard: UIStoryboard)->OutgoingBillViewController{
        return storyBoard.instantiateViewController(withIdentifier: String(describing: self.classForCoder())) as! OutgoingBillViewController
    }
    
    
    @IBOutlet weak var allBills: UIButton!
    @IBOutlet weak var consolBtn: UIButton!
    @IBOutlet weak var loansBtn: UIButton!
    var typeList="bills"
    @IBOutlet weak var listTableView: UITableView!
    var billsList=[BillModel]()
    var loansList=[BillModel]()
    var consolidatedList=[BillModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title="Future Payments"
        if #available(iOS 11.0, *) {
            loansBtn.clipsToBounds = true
            loansBtn.layer.cornerRadius = 20
            loansBtn.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
            
            if SessionManger.getInstance.isBillCustomer(){
                allBills.clipsToBounds = true
                allBills.layer.cornerRadius = 20
                allBills.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
                allBills.sendActions(for: .touchUpInside)
            }else{
                allBills.isHidden=true
                consolBtn.clipsToBounds = true
                consolBtn.layer.cornerRadius = 20
                consolBtn.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
                consolBtn.sendActions(for: .touchUpInside)
            }
        } else {
            // Fallback on earlier versions
            consolBtn.layer.cornerRadius = 20
            loansBtn.layer.cornerRadius = 20
            allBills.layer.cornerRadius = 20
            allBills.sendActions(for: .touchUpInside)
        }
    }
    
    @IBAction func allBillsBtn(_ sender: UIButton) {
        typeList="bills"
        sender.backgroundColor=#colorLiteral(red: 0.7136766911, green: 0.1980024874, blue: 0.1905406117, alpha: 1)
        loansBtn.backgroundColor=#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        consolBtn.backgroundColor=#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        allBills.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        loansBtn.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        consolBtn.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        
        if billsList.count == 0 {
            allBillsApi()
        }else{
            reloadTableView()
        }
    }
    
    @IBAction func consolidatedBtn(_ sender: UIButton) {
        typeList="consol"
        sender.backgroundColor=#colorLiteral(red: 0.7136766911, green: 0.1980024874, blue: 0.1905406117, alpha: 1)
        loansBtn.backgroundColor=#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        allBills.backgroundColor=#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        allBills.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        loansBtn.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        consolBtn.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        
        if consolidatedList.count == 0 {
            consolidatedApi()
        }else{
            reloadTableView()
        }
    }
    
    @IBAction func allLoansBtn(_ sender: UIButton) {
        typeList="loan"
        sender.backgroundColor=#colorLiteral(red: 0.7136766911, green: 0.1980024874, blue: 0.1905406117, alpha: 1)
        allBills.backgroundColor=#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        consolBtn.backgroundColor=#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        allBills.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        loansBtn.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        consolBtn.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        
        if loansList.count == 0 {
            allLoansApi()
        }else{
            reloadTableView()
        }
    }
    
    private func reloadTableView(){
        UIView.transition(with: self.listTableView,
                          duration: 0.35,
                          options: .transitionCurlUp,
                          animations: { self.listTableView.reloadData()})
    }
    
    private func allLoansApi(){
        self.showProgress()
        self.loansList.removeAll()
        let params=["mode":"consolidatedEmisDetails"]
        ApiClient.getJSONResponses(route: APIRouter.stasheasyApi(param: params)){
            result, status in
            self.hideProgress()
            switch status {
            case .success:
                Log("success \(result!)")
                if let json = try? JSON(data: result!){
                    if let loans = json["loans"].array{
                        for loan in loans{
                            self.loansList.append(BillModel(amount: loan["approved_amount"].stringValue, date: loan["id"].stringValue,status: loan["status"].intValue))
                        }
                    }
                    self.reloadTableView()                }
            case .errors(let error):
                Log(error)
                self.reloadTableView()
            }
        }
    }
    
    private func allBillsApi(){
        self.showProgress()
        self.billsList.removeAll()
        let params=["mode":"allBills"]
        ApiClient.getJSONResponses(route: APIRouter.v2Api(param: params)){
            result, status in
            self.hideProgress()
            switch status {
            case .success:
                Log("success \(result!)")
                if let json = try? JSON(data: result!){
                    if let loans = json["bills"].array{
                        for loan in loans{
                            self.billsList.append(BillModel(amount: loan["amount"].stringValue, date: loan["date"].stringValue,status: loan["status"].intValue))
                        }
                    }
                    self.reloadTableView()
                    
                }
            case .errors(let error):
                Log(error)
                self.reloadTableView()
            }
        }
    }
    
    private func consolidatedApi(){
        self.showProgress()
        self.consolidatedList.removeAll()
        let params=["mode":"outgoingEmis"]
        ApiClient.getJSONResponses(route: APIRouter.v2Api(param: params)){
            result, status in
            self.hideProgress()
            switch status {
            case .success:
                Log("success \(result!)")
                if let json = try? JSON(data: result!){
                    if let loans = json["statement"].array{
                        for loan in loans{
                            self.consolidatedList.append(BillModel(amount: loan["amount"].stringValue, date: loan["emi_date"].stringValue,status: loan["status"].intValue))
                        }
                    }
                    self.consolidatedList=self.consolidatedList.reversed()
                    self.reloadTableView()
                }
            case .errors(let error):
                Log(error)
                self.reloadTableView()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch typeList {
        case "bills":
            return billsList.count
            
        case "consol":
            return consolidatedList.count
            
        case "loan":
            return loansList.count
            
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "outgoingCell") as! OutgoingCell
        
        
        switch typeList {
            
        case "bills":
            
            cell.amountTitle.text="BILL AMOUNT"
            cell.dateTitle.text="BILL DATE"
            
            if billsList.count == 0{
                cell.amountFeild.text="0"
                cell.dateFeild.text=""
                Log("empty feild bills \(indexPath.row)")
            }else{
                cell.amountFeild.text=billsList[indexPath.row].amount ?? ""
                cell.dateFeild.text=billsList[indexPath.row].date ?? ""
                
                if billsList[indexPath.row].status==0{
                    cell.dateTitle.textColors=#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                    cell.amountTitle.textColors = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                    cell.amountFeild.textColors=#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                    cell.dateFeild.textColors=#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                }else{
                    cell.dateTitle.textColors=#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                    cell.amountTitle.textColors = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                    cell.amountFeild.textColors=#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                    cell.dateFeild.textColors=#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                }
            }
            
        case "consol":
            
            cell.amountTitle.text="EMI AMOUNT"
            cell.dateTitle.text="EMI DATE"
            
            if consolidatedList.count == 0{
                cell.amountFeild.text="0"
                cell.dateFeild.text=""
                Log("empty feild consolidatedList \(indexPath.row)")
            }else{
                cell.amountFeild.text=consolidatedList[indexPath.row].amount ?? ""
                cell.dateFeild.text=consolidatedList[indexPath.row].date ?? ""
                if consolidatedList[indexPath.row].status==0{
                    cell.dateTitle.textColors=#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                    cell.amountTitle.textColors = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                    cell.amountFeild.textColors=#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                    cell.dateFeild.textColors=#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                }else{
                    cell.dateTitle.textColors=#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                    cell.amountTitle.textColors = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                    cell.amountFeild.textColors=#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                    cell.dateFeild.textColors=#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                }
            }
            
        case "loan":
            
            cell.amountTitle.text="LOAN AMOUNT"
            cell.dateTitle.text="LOAN ID"
            
            if loansList.count == 0{
                cell.amountFeild.text="0"
                cell.dateFeild.text=""
                Log("empty feild consolidatedList \(indexPath.row)")
                
            }else{
                cell.amountFeild.text=loansList[indexPath.row].amount ?? ""
                cell.dateFeild.text=loansList[indexPath.row].date ?? ""
                
                cell.dateTitle.textColors=#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                cell.amountTitle.textColors = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                cell.amountFeild.textColors=#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                cell.dateFeild.textColors=#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            }
            
        default:
            cell.amountTitle.text="BILL AMOUNT"
            cell.dateTitle.text="BILL DATE"
            
            cell.amountFeild.text="0"
            cell.dateFeild.text=""
            
        }
        
        
        return cell
    }
}
