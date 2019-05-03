//
//  OutgoingEmiViewController.swift
//  StashFinDemo
//
//  Created by Macbook on 09/04/19.
//  Copyright © 2019 StashFin. All rights reserved.
//

import UIKit
import SwiftyJSON


class OutgoingTableViewCell: UITableViewCell {
    @IBOutlet weak var emiTagLabel: UILabel!
    @IBOutlet weak var emiAmountLabel: UILabel!
    @IBOutlet weak var emiRoiLabel: UILabel!
    @IBOutlet weak var emiStartDateLabel: UILabel!
    @IBOutlet weak var loanAmountLabel: UILabel!
    @IBOutlet weak var emiCloseDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        //        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

class OutgoingModel{
    var emiAmount,emiStart,emiClosed,emiRoi,loanAmount:String?
    init(emiAmount:String,emiStart:String,emiClosed:String,emiRoi:String,loanAmount:String){
        self.emiAmount=emiAmount
        self.emiStart=emiStart
        self.emiClosed=emiClosed
        self.emiRoi=emiRoi
        self.loanAmount=loanAmount
        
    }
}


class OutgoingEmiViewController: BaseLoginViewController, UITableViewDataSource, UITableViewDelegate {
    
    static func getInstance(storyBoard: UIStoryboard)->OutgoingEmiViewController{
        return storyBoard.instantiateViewController(withIdentifier: String(describing: self.classForCoder())) as! OutgoingEmiViewController
    }

    
    var outgoingData = [OutgoingModel]()
    @IBOutlet weak var amount1Label: UILabel!
    @IBOutlet weak var date1Label: UILabel!
    @IBOutlet weak var amount2Label: UILabel!
    @IBOutlet weak var date2Label: UILabel!
    @IBOutlet weak var amount3Label: UILabel!
    @IBOutlet weak var date3Label: UILabel!
    @IBOutlet weak var amount4Label: UILabel!
    @IBOutlet weak var date4Label: UILabel!
    @IBOutlet weak var amount5Label: UILabel!
    @IBOutlet weak var date5Label: UILabel!
    @IBOutlet weak var amount6Label: UILabel!
    @IBOutlet weak var date6Label: UILabel!
    @IBOutlet weak var outgoingTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="EMIs"
        setEmiDetailsApi()
    }
    
    private func setEmiDetailsApi(){
        self.showProgress()
        let params:[String:String]=["mode":"consolidatedEmisDetails"]
        ApiClient.getJSONResponses(route: APIRouter.stasheasyApi(param: params)){
            
            result,status in
            self.hideProgress()
            switch status {
            case .success:
                if let json = try? JSON(data: result!){
                    self.amount1Label.text =  Constants.Values.RupeeSign + json["total"]["first"]["amount"].stringValue
                    
                    self.amount2Label.text = Constants.Values.RupeeSign +  json["total"]["second"]["amount"].stringValue
                    self.amount3Label.text = Constants.Values.RupeeSign +  json["total"]["third"]["amount"].stringValue
                    self.amount4Label.text = Constants.Values.RupeeSign +  json["total"]["fourth"]["amount"].stringValue
                    self.amount5Label.text = Constants.Values.RupeeSign +  json["total"]["fifth"]["amount"].stringValue
                    self.amount6Label.text = Constants.Values.RupeeSign +  json["total"]["sixth"]["amount"].stringValue
                    
                    self.date1Label.text = json["total"]["first"]["date"].stringValue
                    self.date2Label.text = json["total"]["second"]["date"].stringValue
                    self.date3Label.text =  json["total"]["third"]["date"].stringValue
                    self.date4Label.text =  json["total"]["fourth"]["date"].stringValue
                    self.date5Label.text =  json["total"]["fifth"]["date"].stringValue
                    self.date6Label.text =  json["total"]["sixth"]["date"].stringValue
                    
                    if let loans = json["loans"].array{
                        for loan in loans { self.outgoingData.append(OutgoingModel(emiAmount: loan["emi_amount"].stringValue, emiStart: loan["emi_start_date"].stringValue, emiClosed: loan["emi_end_date"].stringValue, emiRoi: loan["approved_rate"].stringValue, loanAmount: loan["approved_amount"].stringValue))
                            
                        }
                    }
                    self.outgoingTable.reloadData()
                }
                
            case .errors(let errors):
                self.openHomePageDialog(title: "EMI Details", message: errors)
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return outgoingData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 10.0
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "OutgoingCell", for: indexPath) as? OutgoingTableViewCell else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: "OutgoingCell", for: indexPath) as! OutgoingTableViewCell
        let outgoingModel = outgoingData[indexPath.row]
        cell.emiAmountLabel.text = Constants.Values.RupeeSign + outgoingModel.emiAmount.isNilOrValue
        cell.emiRoiLabel.text = "Rate of interest:  "+outgoingModel.emiRoi.isNilOrValue
        cell.emiTagLabel.text = "Loan: \(indexPath.row+1)"
        cell.emiCloseDateLabel.text = outgoingModel.emiClosed.isNilOrValue
        cell.emiStartDateLabel.text = outgoingModel.emiStart.isNilOrValue
        cell.loanAmountLabel.text = Constants.Values.RupeeSign + outgoingModel.loanAmount.isNilOrValue

        return cell
    }

}
