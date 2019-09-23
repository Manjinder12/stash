//
//  TransactionViewController.swift
//  StashFinDemo
//
//  Created by Macbook on 08/04/19.
//  Copyright © 2019 StashFin. All rights reserved.
//

import UIKit
import  SwiftyJSON


class TransactionModel{
    var txRef,amount,type,date,otherPartyName:String?
    
    init(txRef:String,amount:String,type:String,date:String,otherPartyName:String){
    self.txRef=txRef
    self.amount=amount
    self.type=type
        self.date=date
        self.otherPartyName=otherPartyName
    }
}

class TransactionCell: UITableViewCell{
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var trnxIdLabel: UILabel!
    @IBOutlet weak var trnxTypeLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
}

class TransactionViewController: BaseLoginViewController, UITableViewDelegate,UITableViewDataSource {
    var transactionDatas=[TransactionModel]()
    @IBOutlet weak var tranxTableView: UITableView!
    
    
    static func getInstance(storyboard: UIStoryboard) -> TransactionViewController{
        return storyboard.instantiateViewController(withIdentifier: String(describing: self.classForCoder())) as! TransactionViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        checkTranxApi()
    }

    private func checkTranxApi(){
        let params=["mode":"cardTransactions"]
        self.showProgress()
        ApiClient.getJSONResponses(route: APIRouter.stasheasyApi(param: params)){
            result, status in
            self.hideProgress()
            switch status{
            case .success:
                if let json = try? JSON(data: result!).array!, json.count>0{
                        for trx in json{
                            self.transactionDatas.append(TransactionModel(txRef: trx["txRef"].stringValue, amount: trx["amount"].stringValue, type: trx["type"].stringValue, date: trx["date"].stringValue, otherPartyName: trx["otherPartyName"].stringValue))
                        }
                    self.tranxTableView.reloadData()
                }
            case .errors(let errors):
                self.openHomePageDialog(title: "Card Transaction", message: errors)
                
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactionDatas.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath) as! TransactionCell
        let trnxModel=transactionDatas[indexPath.row]
        cell.amountLabel.text=Constants.Values.RupeeSign + (trnxModel.amount ?? "0")
        cell.trnxTypeLabel.text=trnxModel.type
        cell.companyLabel.text=trnxModel.otherPartyName
        cell.dateLabel.text=trnxModel.date
        cell.trnxIdLabel.text="Transaction ID: \( trnxModel.txRef ?? "-")"
        if trnxModel.type == "CREDIT"{
            cell.trnxTypeLabel.textColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        }else  if trnxModel.type == "DEBIT"{
            cell.trnxTypeLabel.textColor = .red
        }
        return cell
    }
}
