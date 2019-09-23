//
//  LocSelectViewController.swift
//  StashFinDemo
//
//  Created by Macbook on 14/03/19.
//  Copyright © 2019 StashFin. All rights reserved.
//

import Foundation
import UIKit

class LoadMyCardDoneViewController: BaseViewController {
    
    static func getInstance(storyboard: UIStoryboard) -> LoadMyCardDoneViewController{
        return storyboard.instantiateViewController(withIdentifier: String(describing: self.classForCoder())) as! LoadMyCardDoneViewController
    }
    
    @IBOutlet weak var loanAmountLabel: UILabel!
    @IBOutlet weak var disburseAmountLabel: UILabel!
    @IBOutlet weak var emiAmountLabel: UILabel!
    @IBOutlet weak var emiDateLabel: UILabel!
    @IBOutlet weak var emiAmountTitle: CustomUILabel!
    @IBOutlet weak var emiDateTitle: CustomUILabel!
    @IBOutlet weak var doneBtn: UIButton!
    public var loan_amount=""
    public var disburse_amount=""
    public var emi_date=""
    public var emi_amount:Int=0
    public var bill_amount:Int = 0
    
    override func viewDidLoad() {
        loanAmountLabel.text=loan_amount
        disburseAmountLabel.text=disburse_amount
        
        emiDateLabel.text=emi_date
        if bill_amount > 0 {
            emiAmountLabel.text="0%"
            emiDateTitle.text = "Bill Date"
            emiAmountTitle.text = "ROI"
        }else{
            emiAmountLabel.text="\(emi_amount)"
            emiDateTitle.text = "Next EMI date"
            emiAmountTitle.text = "EMI Amount"
        }
    }
    
    @IBAction func goToHomeBtn(_ sender: UIButton) {
        self.showHomePage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}
