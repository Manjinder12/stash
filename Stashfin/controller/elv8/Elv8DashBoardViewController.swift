//
//  Elv8DashboardViewController.swift
//  Stashfin
//
//  Created by Macbook on 31/05/19.
//  Copyright © 2019 Stashfin. All rights reserved.
//

import UIKit
import SwiftyJSON

class Elv8DashboardViewController: BaseLoginViewController {
   
    static func getInstance(storyboard: UIStoryboard) -> Elv8DashboardViewController{
        return storyboard.instantiateViewController(withIdentifier: String(describing: self.classForCoder())) as! Elv8DashboardViewController
    }
    
    @IBOutlet weak var dashboardImg: UIImageView!
    @IBOutlet weak var viewEmiDetailsBtn: RCButton!
    var apiResponse:Data?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewEmiDetailsBtn.layer.borderWidth=1
        viewEmiDetailsBtn.setTitleColor(UIColor.black, for: .normal)
        dashboardImg.layer.cornerRadius=10
        // Do any additional setup after loading the view.
   

        checkStatusApi()
    }

    private func checkStatusApi(){
        let params=["mode":"elv8_home_dashboard"]
        ApiClient.getJSONResponses(route: APIRouter.v2Api(param: params)){
            result,status in
              self.apiResponse=result
            if let json = try? JSON(data:result!){
                if  let  displayPage = json["dashboard_display_page"].string{
                    self.updatePage(page:displayPage)
                }
            }
        }
    }
    
    private func updatePage(page:String){
        switch page {
        case "select_plan":
//            self.changeViewController(controllerName: Constants.Controllers.EL_CHOOSE_LOAN)
            let controller=Elv8ChooseLoanViewController.getInstance(storyboard: self.storyBoardElv8)
            controller.apiResponse=self.apiResponse
            goToNextViewController(controller: controller)
        case "approved_plan":
             Log("approved_plan")
//             congratulationsLayout.setVisibility(View.VISIBLE);
//             setHeaderTitle("Loan Approved");
//             recyclerView.setVisibility(View.GONE);
//             descTextView.setText(getString(R.string.loan_pre_approved));
//             setPlanDetails();
        case "ready_disburse_plan":
             Log("ready_disburse_plan")
//             congratulationsLayout.setVisibility(View.VISIBLE);
//             setHeaderTitle("Documents Approved");
//             descTextView.setText(getString(R.string.loan_ready_disburse));
//             kycTextView.setVisibility(View.GONE);
//             recyclerView.setVisibility(View.GONE);
//             setEmiData();
            
        case "pay_now":
             Log("pay_now")
//             payNowLayout.setVisibility(View.VISIBLE);
//             setHeaderTitle("Dashboard");
//             setPlansList(elevateDashboardPojo, false, false);
//             setDashboardData(elevateDashboardPojo);
            
        case "check_eligibility":
            // elegibility visible
            // setPlanDetails()
            Log("check_eligibility")
        case "apply_now":
             Log("apply_now")
//             setHeaderTitle("Dashboard");
//             applyNowLayout.setVisibility(View.VISIBLE);
//             if (elevateDashboardPojo != null)
//             if (!elevateDashboardPojo.getApplyNowDisable())
//             setPlansList(elevateDashboardPojo, true, false);
//             else {
//                setStaticPlans();
//            }

            
        default:
             Log("default")
        }
    }
}
