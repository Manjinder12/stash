//
//  BaseLoginViewController.swift
//  StashFinDemo
//
//  Created by Macbook on 01/02/19.
//  Copyright © 2019 StashFin. All rights reserved.
//

import Foundation
import UIKit
import Toast_Swift
import Foundation
import SwiftyJSON
import SideMenu
import SDWebImage

struct LandingPageResponse: Codable {
    let status, message, landingPage: String?
    
    enum CodingKeys: String, CodingKey {
        case status, message
        case landingPage = "landing_page"
    }
}

public class BaseLoginViewController: UIViewController {
    //    var responseModel:LoginResponseModel?
    var mobileNumbers:String=""
    var cardTypes:String=""
    //    var response: Data = "".data(using: .utf8)!
    let storyBoardMain:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    let storyBoadBill:UIStoryboard = UIStoryboard(name: "MainBill", bundle: nil)
    let storyBoardElv8:UIStoryboard = UIStoryboard(name: "RegistrationElv8", bundle: nil)
    let storyBoardRegister:UIStoryboard = UIStoryboard(name: "RegistrationNew", bundle: nil)
    let storyBoardOther:UIStoryboard = UIStoryboard(name: "Other",bundle: nil)
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        print("view Did Load")
    }
    
    func addMenuBarButtonItem() {
        let image = UIImage(named: "hamburger_icon")
        let backItem = UIBarButtonItem(image: image,
                                       style: UIBarButtonItem.Style.plain,
                                       target: self,
                                       action: #selector(showSideMenu))
        
        self.navigationItem.leftBarButtonItem = backItem
        
    }
    
    @objc func showSideMenu(){
        DispatchQueue.main.async {
            self.present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
        }
    }
    
    private func isVersionUpdated(requiredVersion:Int,update_required:Int)->(Bool,Bool){
        let buildNumberString = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
        
        let current_version:Int = Int(buildNumberString) ?? 0
        if current_version>2{
            Log("current \(current_version)  ****  \(requiredVersion)")
            if current_version >= requiredVersion{
                Log("current 1")
                return (true,false)
            }else if (current_version < requiredVersion && update_required == 1){
                Log("current 2")
                return (false,false)
            }else if (current_version >= requiredVersion-2 && update_required == 0){
                Log("current 3")
                return (false,true)
            }else if (current_version < requiredVersion-1){
                Log("current 4")
                return (false,false)
            }
        }
        return (true,false)
    }
    
    private func showVersionUpdateAlert(status:Bool,result: Data?){
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
            let alert = UIAlertController.init(title: "Update Available", message: "\nA newer and improved version of the Stashfin is available. Please update for better experience.", preferredStyle: .alert)
            alert.addAction(UIAlertAction.init(title: "Update Now", style: .destructive, handler: {(_) -> Void in
                self.openAppStore()
            }))
            if status{
                alert.addAction(UIAlertAction.init(title: "Update Later", style: .default, handler: {(_)->Void in
                    self.changeViewController(response:result)
                }))
            }
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func openAppStore() {
        if let url = URL(string: "itms-apps://itunes.apple.com/app/apple-store/id1276990457?mt=8"),
            UIApplication.shared.canOpenURL(url){
            UIApplication.shared.open(url, options: [:]) { (opened) in
                if(opened){
                    print("App Store Opened")
                }
            }
        } else {
            self.showToast("Failed to update from App Store!")
            print("Can't Open URL on Simulator")
        }
    }
    
    func parseResonse(result: Data?){
        if let response = try? JSON(data: result!){
            
            SessionManger.getInstance.clearAllData()
            
            let authToken = response["auth_token"].stringValue
            guard !authToken.isEmpty else{
                self.view.makeToast(Constants.Values.server_error)
                return
            }
            SessionManger.getInstance.saveCustomerId(id: response["customer_id"].stringValue)
            SessionManger.getInstance.setBillCustomer(status: response["free_loc_eligible"].boolValue)
            
            //            SessionManger.getInstance.setBillGiftIntroShowed(status: false)
            //             SessionManger.getInstance.setBillCustomer(status:true)
            
            SessionManger.getInstance.saveAuthToken(token: authToken)
            SessionManger.getInstance.saveApplicationStatus(status: response["latest_loan_details"]["current_status"].stringValue)
            SessionManger.getInstance.saveProfilePic(profile: response["profile_pic"].stringValue)
            SessionManger.getInstance.saveName(name: response["customer_name"].stringValue)
            SessionManger.getInstance.saveEmail(email: response["email"].stringValue)
            SessionManger.getInstance.saveNumber(number: response["phone"].stringValue)
            SessionManger.getInstance.saveOccupationStatus(status: response["occupation"].stringValue)
            SessionManger.getInstance.setPaybackStatus(status: response["paybackStatus"].boolValue)
            
            if response["product"].stringValue.contains("ELV"){
                SessionManger.getInstance.setUserType(value: Constants.Values.ELV8_USER)
            }else{
                SessionManger.getInstance.setUserType(value: Constants.Values.NORMAL_USER)
            }
            if !SessionManger.getInstance.getDeviceSaved(){
                ApiClient.updateAppDetails(){
                    result, status in
                    Log("saved")
                    SessionManger.getInstance.setDeviceSaved(status: true)
                }
            }
            
            let (appUpdated, optionalStatus) = self.isVersionUpdated(requiredVersion:response["app_version"].intValue,update_required:response["update_required"].intValue)
            if !appUpdated{
                showVersionUpdateAlert(status:optionalStatus,result: result)
                return
            }
            
            changeViewController(response:result)
            
            //            self.changeViewController(controllerName: Constants.Controllers.BILL_OUTGOING_EMI)
            
        }else{
            self.view.makeToast(Constants.Values.server_error)
        }
    }
    
    var personalData:String{
        get{
            return mobileNumbers
        }
        set(newValue){
            mobileNumbers=newValue
        }
    }
    
    var cardType:String{
        get{
            return cardTypes
        }
        set(newValue){
            cardTypes = newValue
        }
    }
    
    func changeViewController(controllerName: String="", response:Data?="".data(using: .utf8)) {
        
        var controller:String = controllerName
        if let json = try? JSON(data:response!){
            if let page = json["landing_page"].string{
                controller = page
            }
        }
        
        Log("controller name: \(controller)")
        
        
        switch controller {
        // MARK: registration controllers
        case Constants.Controllers.REGISTER:
            let storyBoardController = RegisterViewController.getInstance(storyboard:storyBoardRegister)
            storyBoardController.mobileNumber=personalData
            goToNextViewController(controller: storyBoardController, pushStatus: false)
            
        case Constants.Controllers.LANDING_PAGE:
            goToNextViewController(controller: SocialLoginViewController.getInstance(storyboard: storyBoardRegister),pushStatus: false)
            
        case Constants.Controllers.PERSONAL:
            let storyBoardController = PersonalViewController.getInstance(storyboard:storyBoardRegister)
            if let json = try? JSON(data:response!){
                storyBoardController.cityValue=json["city_name"].stringValue
            }
            goToNextViewController(controller: storyBoardController, pushStatus: false)
            
            
        case Constants.Controllers.PROFESSIONAL:
            let storyBoardController = ProfessionalViewController.getInstance(storyboard:storyBoardRegister)
            goToNextViewController(controller: storyBoardController, pushStatus: false)
            
        case Constants.Controllers.PROFESSIONAL_ABOVE_SALARY,Constants.Controllers.PROFESSIONAL_BUSINESS:
            let storyBoardController = ProfessionalViewController.getInstance(storyboard:storyBoardRegister)
            storyBoardController.salariedStatus=false
            goToNextViewController(controller: storyBoardController, pushStatus: false)
            
        case Constants.Controllers.PROFESSIONAL, Constants.Controllers.PROFESSIONAL_BELOW_SALARY:
            let storyBoardController = ProfessionalViewController.getInstance(storyboard:storyBoardRegister)
            storyBoardController.salariedStatus=true
            goToNextViewController(controller: storyBoardController, pushStatus: false)
            
            
        case Constants.Controllers.ENACH:
            let storyBoardController = EnachRegisterViewController.getInstance(storyboard:storyBoardRegister)
            storyBoardController.response=response
            goToNextViewController(controller: storyBoardController, pushStatus: false)
            
        case Constants.Controllers.DOCUMENTS_SALARY,Constants.Controllers.DOCUMENT:
            let storyBoardController = DocumentUploadViewController.getInstance(storyboard:storyBoardRegister)
            storyBoardController.isSalaried = true
            goToNextViewController(controller: storyBoardController, pushStatus: false)
            
        case Constants.Controllers.DOCUMENTS_BUSINESS:
            let storyBoardController = DocumentUploadViewController.getInstance(storyboard:storyBoardRegister)
            storyBoardController.isSalaried = false
            goToNextViewController(controller: storyBoardController, pushStatus: false)
            
            
        case Constants.Controllers.REJECT_PAGE:
            goToNextViewController(controller: RejectViewController.getInstance(storyboard: storyBoardRegister))
            
        case  Constants.Controllers.BANK_DETAILS_BUSINESS, Constants.Controllers.BANK_DETAILS_SALARY:
            let storyBoardController = BankDetailsViewController.getInstance(storyboard:storyBoardRegister)
            goToNextViewController(controller: storyBoardController, pushStatus: false)
            
        case Constants.Controllers.BANK_STATEMENT_SALARY:
            let storyBoardController = BankStatementUploadViewController.getInstance(storyboard:storyBoardRegister)
            storyBoardController.salariedType = true
            goToNextViewController(controller: storyBoardController, pushStatus: false)
            
        case  Constants.Controllers.BANK_STATEMENT_BUSINESS:
            let storyBoardController = BankStatementUploadViewController.getInstance(storyboard:storyBoardRegister)
            storyBoardController.salariedType = false
            goToNextViewController(controller: storyBoardController, pushStatus: false)
            
        case Constants.Controllers.THANK_YOU_PAGE:
            goToNextViewController(controller: ThankuViewController.getInstance(storyboard:storyBoardRegister))
            
        case Constants.Controllers.PICKUP:
            let storyBoardController = PickupViewController.getInstance(storyboard:storyBoardRegister)
            let pickup=getPickupAddress(response: response)
            storyBoardController.address = pickup.0
            storyBoardController.currrent_date = pickup.1
            storyBoardController.pdf_url = pickup.2
            storyBoardController.occupation_type = pickup.3
            goToNextViewController(controller: storyBoardController, pushStatus: false)
            
        case Constants.Controllers.SIGNATURE:
            let storyBoardController = SignatureViewController.getInstance(storyboard:storyBoardRegister)
            goToNextViewController(controller: storyBoardController, pushStatus: false)
            
        case Constants.Controllers.APPROVED:
            let storyBoardController = ApprovedViewController.getInstance(storyboard:storyBoardRegister)
            let details=getApprovedDetails(response: response)
            storyBoardController.amountResponse = details.0
            storyBoardController.tenureResponse = details.1
            storyBoardController.emiAmountResponse = details.2
            goToNextViewController(controller:
                storyBoardController, pushStatus: false)
            
        case Constants.Controllers.ENACH_WEBVIEW:
            let storyBoardController =  BankDetailsViewController.getInstance(storyboard: storyBoardRegister)
            goToNextViewController(controller: storyBoardController, pushStatus: false)
            
        case Constants.Controllers.REGISTRATION_LOGIN:
            goToNextViewController(controller: RegisterLoginViewController.getInstance(storyboard: storyBoardRegister),pushStatus: false)
            
        case Constants.Controllers.GET_STASHFIN_CARD:
            goToNextViewController(controller: GetCardViewController.getInstance(storyboard: storyBoardMain))
            
        case Constants.Controllers.STASHFIN_CARD:
            goToNextViewController(controller: StashFinCardViewController.getInstance(storyboard: storyBoardMain))
            
        case Constants.Controllers.ACTIVE_STASHFIN_CARD_INTRO:
            goToNextViewController(controller: ActivateCardIntroViewController.getInstance(storyboard: storyBoardMain))
            
        case Constants.Controllers.ACTIVE_STASHFIN_CARD:
            let controller = ActivateCardViewController.getInstance(storyboard: storyBoardMain)
            controller.cardTypeStatus = cardType
            goToNextViewController(controller: controller)
            
        case Constants.Controllers.CHANGE_CARD_PIN:
            goToNextViewController(controller: CardPinViewController.getInstance(storyboard: storyBoardMain))
            
        case Constants.Controllers.PROFILE_PAGE:
            goToNextViewController(controller: ProfileViewController.getInstance(storyboard: storyBoardMain))
            
        case Constants.Controllers.LOAN_STATUS_PAGE:
            goToNextViewController(controller: ApplicationStatusViewController.getInstance(storyboard: storyBoardMain))
            
        case Constants.Controllers.DASHBOARD_PAGE:
            //            if SessionManger.getInstance.isBillCustomer(){
            //                if  !SessionManger.getInstance.isBillGiftIntroShowed(){
            //                    goToNextViewController(controller: DashBoardViewController.getInstance(storyboard: storyBoardMain),pushStatus: false)
            //                }else{
            //                    goToNextViewController(controller: DashBoardViewController.getInstance(storyboard: storyBoardMain))
            //                }
            //            }else{
            goToNextViewController(controller: DashBoardViewController.getInstance(storyboard: storyBoardMain))
            //            }
            
        case Constants.Controllers.BLOCK_CARD:
            goToNextViewController(controller: BlockViewController.getInstance(storyboard: storyBoardMain))
            
        case Constants.Controllers.TRANSACTION:
            goToNextViewController(controller: TransactionViewController.getInstance(storyboard: storyBoardMain))
            
        case Constants.Controllers.PAY_NOW:
            goToNextViewController(controller: PayNowViewController.getInstance(storyBoard: storyBoardMain))
            
        case Constants.Controllers.FORGOT_PASSWORD:
            let controller = ForgotPasswordViewController(nibName: "ForgotPasswordViewController", bundle: nil)
            goToNextViewController(controller: controller)
            
            
        case Constants.Controllers.APP_LOCKER:
            let controller = AppLocker(nibName: ALConstants.nibName, bundle: nil)
            goToNextViewController(controller: controller)
            
            
        case Constants.Controllers.OUTGOING_EMI:
            goToNextViewController(controller: OutgoingEmiViewController.getInstance(storyBoard: storyBoardMain))
            
        case Constants.Controllers.BILL_OUTGOING_EMI:
            goToNextViewController(controller: OutgoingBillViewController.getInstance(storyBoard: storyBoadBill))
            
            
        case Constants.Controllers.BILL_PAY_NOW:
            goToNextViewController(controller: BillPayNowViewController.getInstance(storyBoard: storyBoadBill))
            
        case Constants.Controllers.BILL_INTRO:
            goToNextViewController(controller: BillIntroViewController.getInstance(storyboard: storyBoadBill))
            
        case Constants.Controllers.BILL_LOAD_MY_CARD:
            goToNextViewController(controller: BillLoadMyCardViewController.getInstance(storyboard: storyBoadBill))
            
        case Constants.Controllers.BILL_LOAD_MY_CARD_CONFIRM:
            let controller=BillLoadMyCardConfirmViewController.getInstance(storyboard: storyBoadBill)
            controller.locResponse = response
            goToNextViewController(controller: controller)
            
            
        case Constants.Controllers.CUSTOMER_CARE:
            goToNextViewController(controller: CustomerCareViewController
                .getInstance(storyboard: storyBoardMain))
            
        case Constants.Controllers.PAYBACK:
            goToNextViewController(controller: PayBackViewController
                .getInstance(storyboard: storyBoardMain))
            
        case Constants.Controllers.LOAN_CALCULATOR:
            goToNextViewController(controller: LoanCalculatorViewController
                .getInstance(storyboard: storyBoardMain))
            
        case Constants.Controllers.PAYMENT_HISTORY:
            goToNextViewController(controller: PaymentHistoryViewController
                .getInstance(storyboard: storyBoadBill))
            
        case Constants.Controllers.LOAD_MY_CARD:
            goToNextViewController(controller: LoadMyCardSlideViewController.getInstance(storyboard:storyBoardMain))
            
            
        case Constants.Controllers.LOAD_MY_CARD_DONE:
            let controller = LoadMyCardDoneViewController.getInstance(storyboard:storyBoardMain)
            goToNextViewController(controller: controller)
            
            
        case Constants.Controllers.LOAD_MY_CARD_CONFIRM:
            let controller = LoadMyCardConfirmViewController.getInstance(storyboard:storyBoardMain)
            controller.locResponse = response
            goToNextViewController(controller: controller)
            
            
        case Constants.Controllers.APPLICATION_STATUS:
            setApplicationStatus(response: response)
            
        //profile key
        case Constants.Controllers.DASHBOARD:
            openMainPage()
            
        case Constants.Controllers.LOGIN:
            goToNextViewController(controller: LoginViewController.getInstance(storyboard:storyBoardRegister),pushStatus: false)
            
        case Constants.Controllers.THANK_YOU:
            SessionManger.getInstance.saveApplicationStatus(status:
                Constants.ApplicationStatus.THANKU)
            openMainPage("thanku")
            
        case Constants.Controllers.REJECT:
            SessionManger.getInstance.saveApplicationStatus(status:
                Constants.ApplicationStatus.REJECTED)
            openMainPage("reject")
            
        case Constants.Controllers.MPIN:
            goToNextViewController(controller: MpinViewController.getInstance(storyboard:storyBoardOther),pushStatus: false)
            
            //elv8 pages
            
            //        case Constants.Controllers.EL_APPLY:
            //            let controller=Elv8ApplyViewController.getInstance(storyboard: storyBoardElv8)
            //            goToNextViewController(controller: controller)
            //
            //        case Constants.Controllers.EL_INTRO:
            //            let controller=Elev8IntroViewController.getInstance(storyboard: storyBoardElv8)
            //            goToNextViewController(controller: controller)
            //
            //        case Constants.Controllers.EL_PENNY_DROP:
            //            let controller=Elv8PennyDropViewController.getInstance(storyboard: storyBoardElv8)
            //            goToNextViewController(controller: controller)
            //
            //        case Constants.Controllers.EL_AADHAAR_SCAN:
            //            let controller=Elv8AadhaarViewController.getInstance(storyboard: storyBoardElv8)
            //            goToNextViewController(controller: controller)
            //
            //        case Constants.Controllers.EL_BANK:
            //            let controller=Elv8BankDetailsViewController.getInstance(storyboard: storyBoardElv8)
            //            goToNextViewController(controller: controller)
            //
            //        case Constants.Controllers.EL_DOC:
            //            let controller=DocumentUploadViewController.getInstance(storyboard: storyBoardRegister)
            //             controller.docType=Constants.Controllers.EL_DOC
            //            goToNextViewController(controller: controller)
            //
            //        case Constants.Controllers.EL_DOC_REJECT:
            //            let controller=DocumentUploadViewController.getInstance(storyboard: storyBoardRegister)
            //            controller.docType=Constants.Controllers.EL_DOC_REJECT
            //            goToNextViewController(controller: controller)
            //
            //        case Constants.Controllers.EL_REFERENCE:
            //            let controller=Elv8ReferenceViewController.getInstance(storyboard: storyBoardElv8)
            //            goToNextViewController(controller: controller)
            //
            //        case Constants.Controllers.EL_LOAN_AGREEMENT:
            //            let controller=Elv8LoanAgreementViewController.getInstance(storyboard: storyBoardElv8)
            //            goToNextViewController(controller: controller)
            //
            //        case Constants.Controllers.EL_DASHBOARD:
            //            let controller=Elv8DashboardViewController.getInstance(storyboard: storyBoardElv8)
            //            goToNextViewController(controller: controller)
            //
            //        case Constants.Controllers.EL_CHOOSE_LOAN:
            //            let controller=Elv8ChooseLoanViewController.getInstance(storyboard: storyBoardElv8)
            //            goToNextViewController(controller: controller)
            //
            //        case Constants.Controllers.EL_CHOOSE_REPAYMENT:
            //            let controller=Elv8ChooseRepaymentViewController.getInstance(storyboard: storyBoardElv8)
            //            goToNextViewController(controller: controller)
            //
            //        case Constants.Controllers.EL_LOAN_APPROVED:
            //            let controller=Elv8LoanApprovedViewController.getInstance(storyboard: storyBoardElv8)
            //            goToNextViewController(controller: controller)
            
        case Constants.Controllers.EL_APPLY,Constants.Controllers.EL_INTRO,Constants.Controllers.EL_PENNY_DROP,Constants.Controllers.EL_AADHAAR_SCAN,Constants.Controllers.EL_BANK ,Constants.Controllers.EL_DOC,Constants.Controllers.EL_DOC_REJECT,Constants.Controllers.EL_FORM,Constants.Controllers.EL_DOC_REJECT,Constants.Controllers.EL_DASHBOARD,Constants.Controllers.EL_CHOOSE_LOAN,Constants.Controllers.EL_CHOOSE_REPAYMENT,Constants.Controllers.EL_ADDRESS_ERROR,Constants.Controllers.EL_REFERENCE,Constants.Controllers.EL_LOAN_AGREEMENT,Constants.Controllers.EL_LOAN_APPROVED,Constants.Controllers.PAYMENT_PAGE,Constants.Controllers.EL_BUREAU_ERROR:
            
            print("Elv8 customer ",controllerName)
            SessionManger.getInstance.saveApplicationStatus(status:
                Constants.ApplicationStatus.THANKU)
            openMainPage("thanku")
            
        case Constants.Controllers.NO_LANDING_PAGE:
            print("no_page")
            self.view.makeToast(Constants.Values.something_went_wrong)
            
            
        default:
            SessionManger.getInstance.saveApplicationStatus(status:
                Constants.ApplicationStatus.THANKU)
            openMainPage("thanku")
            
            print("no view controller found ",controllerName)
        }
    }
    
    private func openMainPage(_ page:String=""){
        let statusViewController = MainContainerViewController.getInstance(storyboard: storyBoardMain)
        statusViewController.pageType = page
        let navigationController = UINavigationController(rootViewController: statusViewController)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    public func showLandingPage(){
        
        SessionManger.getInstance.saveAuthToken(token: "")
        
        if SessionManger.getInstance.getUserLogin(){
            //            changeViewController(controllerName: Constants.Controllers.LOGIN)
            AppDelegate.shared.rootViewController.showLoginScreen(mpinStatus: true)
        }else{
            changeViewController(controllerName: Constants.Controllers.LANDING_PAGE)
        }
    }
    
    public func showHomePage(){
        let status = SessionManger.getInstance.getApplicationStatus()
        Log("Home page: \(status)")
        switch status {
        case Constants.ApplicationStatus.THANKU:
            changeViewController(controllerName: Constants.Controllers.THANK_YOU_PAGE)
        case Constants.ApplicationStatus.REJECTED:
            changeViewController(controllerName: Constants.Controllers.REJECT_PAGE)
        case Constants.ApplicationStatus.DISBURSED, Constants.ApplicationStatus.CLOSED:
            changeViewController(controllerName: Constants.Controllers.DASHBOARD_PAGE)
        case Constants.ApplicationStatus.APPROVED,Constants.ApplicationStatus.DOCPICK,Constants.ApplicationStatus.DOCPICKDONE,Constants.ApplicationStatus.START:
            changeViewController(controllerName: Constants.Controllers.LOAN_STATUS_PAGE)
        default:
            changeViewController(controllerName: Constants.Controllers.LOGIN)
        }
    }
    
    public func openStashFinCard(){
        var physicalCardFound:Bool = false
        var virtualCardFound:Bool = false
        var physicalCardRegistered:Bool = false
        var virtualCardRegistred:Bool = false
        let response = SessionManger.getInstance.getCardResponse()
        if !response.isEmpty{
            if let json = try? JSON(data: response.data(using: .utf8, allowLossyConversion: true)!){
                
                if json["cards"]["physical"].dictionary != nil{
                    physicalCardFound = true
                    if json["cards"]["physical"]["registered"].boolValue{
                        physicalCardRegistered = true
                    }
                }
                
                if json["cards"]["virtual"].dictionary != nil{
                    virtualCardFound = true
                    if json["cards"]["virtual"]["registered"].boolValue{
                        virtualCardRegistred = true
                    }
                }
                
                if physicalCardFound || virtualCardFound{
                    if physicalCardRegistered || virtualCardRegistred {
                        if physicalCardRegistered && virtualCardRegistred {
                            changeViewController(controllerName: Constants.Controllers.CHANGE_CARD_PIN)
                        }else if virtualCardRegistred{
                            changeViewController(controllerName: Constants.Controllers.STASHFIN_CARD)
                        }else if physicalCardRegistered{
                            if virtualCardFound{
                                changeViewController(controllerName: Constants.Controllers.STASHFIN_CARD)
                            }else{
                                changeViewController(controllerName: Constants.Controllers.CHANGE_CARD_PIN)
                            }
                        }
                    }else{
                        changeViewController(controllerName: Constants.Controllers.STASHFIN_CARD)
                    }
                }else{
                    changeViewController(controllerName: Constants.Controllers.GET_STASHFIN_CARD)
                }
            }else{
                changeViewController(controllerName: Constants.Controllers.STASHFIN_CARD)
            }
        }else{
            Log("card action not found")
            //            checkCardStatusApi()
            changeViewController(controllerName: Constants.Controllers.STASHFIN_CARD)
        }
    }
    
    private func checkPhysicalCardStatus(){
        
    }
    
    public func goToNextViewController(controller:UIViewController, pushStatus:Bool = true){
        DispatchQueue.main.async {
            if pushStatus{
                if let navigator = self.navigationController {
                    navigator.pushViewController(controller, animated: true)
                }else{
                    self.present(controller, animated: true, completion: nil)
                }
            }else{
                self.present(controller, animated: true, completion: nil)
            }
            Log("present: \(controller)")
        }
    }
    
    public func onBackPressed(){
        //        First case : if you used : self.navigationController?.pushViewController(yourViewController, animated: true)
        //        in this case you need to use self.navigationController?.popViewController(animated: true)
        //        Second case : if you used : self.present(yourViewController, animated: true, completion: nil)
        //        in this case you need to use
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    public func getLoginDataApi(){
        //        ApiClient.getLoginData(){
        //            result, status in
        //            switch status {
        //            case .success:
        //                self.parseResonse(result: result)
        //            case .errors(let errors):
        //                self.showToast(errors)
        //            }
        //        }
        
        if !SessionManger.getInstance.getAuthToken().isEmpty{
            //                self.showProgress()
            ApiClient.getLoginData(){
                result, status in
                //                    self.hideProgress()
                switch status{
                case .success:
                    Log(result)
                    if let json = try? JSON(data: result!){
                        if json["landing_page"].string != nil{
                            //                              self.dismiss(animated: true, completion: nil)
                            self.parseResonse(result: result)
                        }else{
                            self.showLandingPage()
                        }
                    }else{
                        self.showLandingPage()
                    }
                    
                case .errors(let errors):
                    Log(errors)
                    self.showLandingPage()
                }
            }
        }else{
            self.showLandingPage()
        }
    }
    
    
    public func checkCardStatusApi(){
        ApiClient.getCardData(){
            result,status in
            
        }
    }
    
    public func dismissPopAllViewViewControllers() {
        
    }
    
    public func setApplicationStatus(response:Data?){
        
        if let json = try? JSON(data: response!){
            
            if json["start"].boolValue {
                SessionManger.getInstance.saveLoanStatus(status: Constants.ApplicationStatus.START)
            }
            if json["approved"].boolValue{
                SessionManger.getInstance.saveLoanStatus(status: Constants.ApplicationStatus.APPROVED)
            }
            if json["doc_pickup"].boolValue{
                SessionManger.getInstance.saveLoanStatus(status: Constants.ApplicationStatus.DOCPICK)
            }
            if json["doc_done"].boolValue{
                SessionManger.getInstance.saveLoanStatus(status: Constants.ApplicationStatus.DOCPICKDONE)
            }
        }
        
        openMainPage()
    }
    
    public func getApprovedDetails(response:Data?)->(String,String,String){
         var amount:String=""
         var tenure:String=""
         var emiAmount:String=""
        if let json = try? JSON(data: response!){
            amount =  json["approved_amount"].stringValue
            tenure = json["approved_tenure"].stringValue
            emiAmount = json["emi_amount"].stringValue
        }
        return (amount,tenure,emiAmount)
    }
    
    public func getPickupAddress(response:Data?) -> (String, String,String,String){
        var address = ""
        var current_date=""
        var pdf_url = ""
        var occupation_type = ""
        if let json = try? JSON(data: response!){
            let adrs=json["address"].stringValue.isEmpty ? "" : "\(json["address"].stringValue), "
            let city=json["city_name"].stringValue.isEmpty ? "" : "\(json["city_name"].stringValue), "
            let state=json["state_name"].stringValue.isEmpty ? "" : "\(json["state_name"].stringValue), "
            let pin=json["pincode"].stringValue.isEmpty ? "" : "\(json["pincode"].stringValue)"
            let land=json["landmark"].stringValue.isEmpty ? "" : ", (\(json["landmark"].stringValue))"
            
            address = "\(adrs)\(city)\(state)\(pin)\(land)"
            
            current_date = json["current_date"].stringValue
            occupation_type = json["occupation"].stringValue
            pdf_url = "\(json["agreement_links"]["applicant_pdf_url"].stringValue)CFAForm_\(json["loan_id"].stringValue).pdf"
            
        }
        return (address, current_date, pdf_url,occupation_type)
    }
    
    public func openLoadMyCardPage(){
        if SessionManger.getInstance.isBillCustomer(){
            self.changeViewController(controllerName: Constants.Controllers.BILL_LOAD_MY_CARD)
        }else{
            self.changeViewController(controllerName: Constants.Controllers.LOAD_MY_CARD)
        }
    }
    
    public func openPaymentPage(){
        //        if SessionManger.getInstance.isBillCustomer(){
        self.changeViewController(controllerName: Constants.Controllers.BILL_PAY_NOW)
        //        }
        //        else{
        //            self.changeViewController(controllerName: Constants.Controllers.PAY_NOW)
        //        }
    }
    
    public func downloadFile(urlString:String){
        Log("urlString :  \(urlString)")
        guard let url = URL(string: urlString) else { return }
        //        guard let url = URL(string: "https://www.tutorialspoint.com/swift/swift_tutorial.pdf") else { return }
        
        let urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
        
        let downloadTask = urlSession.downloadTask(with: url)
        downloadTask.resume()
        
        //        if let url = URL(string: urlString) {
        //            let fileName = String((url.lastPathComponent)) as NSString
        //            // Create destination URL
        //            let documentsUrl =  (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first as! URL)
        //            let destinationFileUrl = documentsUrl.appendingPathComponent("\(fileName)")
        //            //Create URL to the source file you want to download
        //            let fileURL = URL(string: urlString)
        //            let sessionConfig = URLSessionConfiguration.default
        //            let session = URLSession(configuration: sessionConfig)
        //            let request = URLRequest(url:fileURL!)
        //            let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
        //                if let tempLocalUrl = tempLocalUrl, error == nil {
        //                    // Success
        //                    if let statusCode = (response as? HTTPURLResponse)?.statusCode {
        //                        print("Successfully downloaded. Status code: \(statusCode)")
        //                    }
        //                    do {
        //                        try FileManager.default.copyItem(at: tempLocalUrl, to: destinationFileUrl)
        //                        do {
        //                            //Show UIActivityViewController to save the downloaded file
        //                            let contents  = try FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
        //                            for indexx in 0..<contents.count {
        //                                if contents[indexx].lastPathComponent == destinationFileUrl.lastPathComponent {
        //                                    let activityViewController = UIActivityViewController(activityItems: [contents[indexx]], applicationActivities: nil)
        //                                    self.present(activityViewController, animated: true, completion: nil)
        //                                }
        //                            }
        //                        }
        //                        catch (let err) {
        //                            print("error: \(err)")
        //                        }
        //                    } catch (let writeError) {
        //                        print("Error creating a file \(destinationFileUrl) : \(writeError)")
        //                    }
        //                } else {
        //                    print("Error took place while downloading a file. Error description: \(error?.localizedDescription ?? "")")
        //                }
        //            }
        //            task.resume()
        //        }
    }
    
    public func openHomePageDialog(title:String,message:String){
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            let alert = UIAlertController.init(title: title, message: "\n\(message)", preferredStyle: .alert)
            alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: {(_) -> Void in
                self.showHomePage()
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    public func pin(_ mode: ALMode) {
        
        var appearance = ALAppearance()
        appearance.image = #imageLiteral(resourceName: "app_icon_round")
        appearance.title = "StashFin"
        //        appearance.isSensorsEnabled = true
        
        if mode == .create{
            AppDelegate.shared.rootViewController.showLoginScreen(mpinStatus:false, mode:"create")
            self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        }else{
            AppLocker.present(with: mode, and: appearance)
        }
        
        //        AppLocker.present(with: mode, and: appearance)
        
        //        let locker = AppLocker(nibName: ALConstants.nibName, bundle: nil)
        //
        ////        locker.messageLabel.text = config?.title ?? ""
        ////        locker.submessageLabel.text = config?.subtitle ?? ""
        ////        locker.view.backgroundColor = config?.color ?? Colors.white
        ////        locker.mode = mode
        ////
        ////        if config?.isSensorsEnabled ?? false {
        ////            locker.checkSensors()
        ////        }
        ////
        //        //    if let image = config?.image {
        //        //      locker.photoImageView.image = image
        //        if let url = URL(string: SessionManger.getInstance.getProfilePic()) {
        //
        //            locker.photoImageView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "app_lock_icon") ,options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
        //                if let img = image{
        //                    locker.photoImageView.maskCircle(anyImage: img,number: 3)
        //                }
        //            })
        //
        //        }else{
        //            //            locker.photoImageView.image =  #imageLiteral(resourceName: "app_icon_round")
        //            locker.photoImageView.maskCircle(anyImage: #imageLiteral(resourceName: "app_lock_icon"),number: 3)
        //        }
        //
        //        //    } else {
        //        //      locker.photoImageView.isHidden = true
        //        //    }
        //
        //        DispatchQueue.main.async {
        //            //            getTopMostViewController()?.present(alertController, animated: true, completion: nil)
        //
        ////            self.present(locker,animated: true,completion: nil)
        //            self.goToNextViewController(controller: locker,pushStatus: false)
        //
        //        }
    }
}

extension BaseLoginViewController:  URLSessionDownloadDelegate {
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        Log("downloadLocation: \(location)")
        // create destination URL with the original pdf name
        guard let url = downloadTask.originalRequest?.url else { return }
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let destinationURL = documentsPath.appendingPathComponent(url.lastPathComponent)
        // delete original copy
        try? FileManager.default.removeItem(at: destinationURL)
        // copy from temp to Document
        do {
            try FileManager.default.copyItem(at: location, to: destinationURL)
            //            self.pdfURL = destinationURL
            self.showToast("File saved at location: \(destinationURL)")
        } catch let error {
            print("Copy Error: \(error.localizedDescription)")
        }
    }
}
