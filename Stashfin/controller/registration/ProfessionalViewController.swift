//
//  ProfessionalLowSalaryViewController.swift
//  StashFinDemo
//
//  Created by Macbook on 05/02/19.
//  Copyright © 2019 StashFin. All rights reserved.
//


import UIKit
import SwiftyJSON

class ProfessionalViewController: BaseLoginViewController {
    
    static func getInstance(storyboard: UIStoryboard) -> ProfessionalViewController{
        return storyboard.instantiateViewController(withIdentifier: String(describing: self.classForCoder())) as! ProfessionalViewController
    }
    
    //salaried
    @IBOutlet weak var companyName: UITextField!
    @IBOutlet weak var officialEmail: UITextField!
    @IBOutlet weak var modeOfIncome: DropDownBox!
    @IBOutlet weak var totalExperiance: DropDownBox!
    @IBOutlet weak var officeAddress: UITextField!
    @IBOutlet weak var landmark: CustomUITextField!
    @IBOutlet weak var pinCode: CustomUITextField!
    @IBOutlet weak var stateBoxMenu: DropDownBox!
    @IBOutlet weak var cityBoxMenu: DropDownBox!
    
    //business
    @IBOutlet weak var businessNameLabel: CustomUITextField!
    @IBOutlet weak var incomeITR: DropDownBox!
    @IBOutlet weak var numberOfEmployees: DropDownBox!
    @IBOutlet weak var businessSince: DropDownBox!
    @IBOutlet weak var natureSince: DropDownBox!
    @IBOutlet weak var officePremisse: DropDownBox!
    @IBOutlet weak var businessSwitch: UISwitch!
    @IBOutlet weak var businessStack: UIStackView!
    @IBOutlet weak var businessAddress: CustomUITextField!
    @IBOutlet weak var businessState: DropDownBox!
    @IBOutlet weak var businessPin: CustomUITextField!
    @IBOutlet weak var businessCity: DropDownBox!
    @IBOutlet weak var businessLandmark: CustomUITextField!
    
    @IBOutlet weak var twoYearITRSwitch: UISwitch!
    @IBOutlet weak var gstSwitch: UISwitch!
    
    @IBOutlet weak var salariedScrollView: UIScrollView!
    @IBOutlet weak var businessScrollView: UIScrollView!
    
    
    var stateList:[String] = []
    var stateListIds:[Int] = []
    var cityList:[String]=[]
    var salariedStatus=true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if salariedStatus{
            salariedScrollView.alpha=1
            businessScrollView.alpha=0
        }else{
            businessScrollView.alpha=1
            salariedScrollView.alpha=0
            
        }
        businessSwitch.addTarget(self, action: #selector(stateChanged), for: .valueChanged)
        businessSwitch.setOn(true, animated: false)
        businessStack.isHidden=true
        
        // Do any additional setup after loading the view.
        modeOfIncome.optionArray = ["In Bank","By Cheque","In Cash"]
        
        
        incomeITR.optionArray=["1 Lakh - 10 Lakh","10 Lakh - 25 Lakh","25 Lakh - 50 Lakh","50 Lakh - 1 Cr","1 Cr and above"]
        
        incomeITR.didSelect{(selectedText,ids) in
            self.incomeITR.text = selectedText
        }
        
        numberOfEmployees.optionArray=["0-5","5-10","10-20"," >20"]
        
        numberOfEmployees.didSelect{(selectedText,ids) in
            self.numberOfEmployees.text = selectedText
        }
        let currentYear = Calendar.current.component(.year, from: Date())
        var year:Int = currentYear
        while year > 1988 {
            businessSince.optionArray.append("\(year)")
            year = year-1
        }
        
        businessSince.didSelect{(selectedText,ids) in
            self.businessSince.text = selectedText
        }
        
        natureSince.optionArray=["Service","Financial Service","Banking","Retails store stand alone","Retails store stand Market","Retails store stand Mall","Details store Online","Outsourcing company","Import/Export business","Wholesale consumer product","Wholesale commodity","Manufacturing","Catering","Freelancing","Handyman services","Education","Legal Consulting","Consulting Other","Medical Practicing","Transportation Company","Restaurant & Cafe"]
        
        natureSince.didSelect{(selectedText,ids) in
            self.natureSince.text = selectedText
        }
        
//        officePremisse.optionArray=["Metro","Non-Metro"]
        officePremisse.optionArray=["Owned","Rented"]

        officePremisse.didSelect{(selectedText,ids) in
            self.officePremisse.text = selectedText
        }
        
        var exp:Int = 1
        while exp < 50 {
            totalExperiance.optionArray.append("\(exp)")
            exp=exp+1
        }
        
        modeOfIncome.didSelect{(selectedText,ids) in
            self.modeOfIncome.text = selectedText
        }
        
        totalExperiance.didSelect{(selectedText,ids) in
            self.totalExperiance.text = selectedText
        }
        
        checkStateListApi()
        pinCode.addTarget(self, action: #selector(pinCodeValidation(field:)), for: .editingChanged)
        
    }
    
    @objc func pinCodeValidation(field: UITextField){
        let MAX_LENGHT = 6
        if let text = field.text, text.count >= MAX_LENGHT {
            field.text = String(text.dropLast(text.count - MAX_LENGHT))
            return
        }
    }
    
    @IBAction func submitButton
        (_ sender: UIButton) {
        
        if SessionManger.getInstance.isTester(){
            if salariedStatus{
                self.changeViewController(controllerName: Constants.Controllers.BANK_STATEMENT_SALARY)
            }else{
                self.changeViewController(controllerName: Constants.Controllers.BANK_DETAILS_BUSINESS)
            }
        }else{
            submitDetails()
        }
    }
    
    private func submitDetails(){
        
        if salariedStatus{
            if companyName.isEditBoxNotEmpty() && modeOfIncome.isEditBoxNotEmpty() && totalExperiance.isEditBoxNotEmpty() && officeAddress.isEditBoxNotEmpty() && landmark.isEditBoxNotEmpty() && pinCode.isEditBoxNotEmpty() && stateBoxMenu.isEditBoxNotEmpty() && cityBoxMenu.isEditBoxNotEmpty(){
                
                if officeAddress.text.isNilOrValue.count>5{
                    if landmark.text.isNilOrValue.count>5{
                        if pinCode.text.isNilOrValue.count==6{
                           
                            self.submitApi(salaried: true)
                        }else{
                            pinCode.becomeFirstResponder()
                            self.showToast("Pin code is not valid")
                        }
                    }else{
                        landmark.becomeFirstResponder()
                        self.showToast("Landmark is too short")
                    }
                }else{
                    officeAddress.becomeFirstResponder()
                    self.showToast("Address is too short")
                }
            }
        }else{
            if businessNameLabel.isEditBoxNotEmpty() && incomeITR.isEditBoxNotEmpty() && numberOfEmployees.isEditBoxNotEmpty() && businessSince.isEditBoxNotEmpty() && natureSince.isEditBoxNotEmpty() && officePremisse.isEditBoxNotEmpty(){
                
                if !businessStack.isHidden{
                    if businessAddress.isEditBoxNotEmpty() && businessLandmark.isEditBoxNotEmpty() && businessCity.isEditBoxNotEmpty() && businessPin.isEditBoxNotEmpty(){
                        if businessAddress.text.isNilOrValue.count>5{
                            if businessLandmark.text.isNilOrValue.count>5{
                                if businessPin.text.isNilOrValue.count==6{
                                    self.submitApi(salaried: false)
                                }else{
                                    businessPin.becomeFirstResponder()
                                    self.showToast("Pin code is not valid")
                                }
                            }else{
                                businessLandmark.becomeFirstResponder()
                                self.showToast("Landmark is too short")
                            }
                        }else{
                            businessAddress.becomeFirstResponder()
                            self.showToast("Address is too short")
                        }
                    }
                }else{
                    self.submitApi(salaried: false)
                
                }
            }
        }
    }
    
    func submitApi(salaried:Bool){
       var params:[String:String] = ["":""]
        if salaried{
            params = ["mode":"professional_details_l40k","company_name":companyName.text.isNilOrValue,"office_email":officialEmail.text.isNilOrValue,"experience":totalExperiance.text.isNilOrValue,"salary_mode":modeOfIncome.text.isNilOrValue,"office_address":officeAddress.text.isNilOrValue,"landmark":landmark.text.isNilOrValue,"pincode":pinCode.text.isNilOrValue,"city_name":cityBoxMenu.text.isNilOrValue]
            
        }else{
            params = ["mode":"business_details","business_name":businessNameLabel.text.isNilOrValue,"annual_turnover":incomeITR.text.isNilOrValue,"no_of_employees":numberOfEmployees.text.isNilOrValue,"working_since":businessSince.text.isNilOrValue,"business_type":natureSince.text.isNilOrValue,"itr_flag":(twoYearITRSwitch.isOn ? "1" : "0"),"gst_flag":(gstSwitch.isOn ? "1" : "0"),"offc_home_flag":(businessSwitch.isOn ? "1" : "0"),"ownership_type":officePremisse.text.isNilOrValue,"office_address":businessAddress.text.isNilOrValue,"city_name":businessCity.text.isNilOrValue,"landmark":businessLandmark.text.isNilOrValue,"pincode":businessPin.text.isNilOrValue]
            
        }
        ApiClient.getJSONResponses(route: APIRouter.v2Api(param: params)){
            result, status in
            switch status{
            case .success:
                self.changeViewController(response: result)
            case .errors(let error):
                self.showToast(error)
            }
        }
    }
    
    // MARK: - Init
    
    // MARK: - Properties
    
    // MARK: - Handlers
    
    
    // MARK: - Handlers
    func checkStateListApi(){
        
        ApiClient.getStateList(){
            result, status in
            self.stateList.removeAll()
            switch(status){
            case .success:
                if let response = try? JSON(data: result!){
                    if  let states = response["states"].array{
                        for state in states { self.stateList.append(state["state_name"].stringValue)
                            self.stateListIds.append(state["id"].intValue)
                        }
                    }
                    self.stateBoxMenu.optionArray = self.stateList
                    self.stateBoxMenu.optionIds=self.stateListIds
                    
                    self.businessState.optionArray = self.stateList
                    self.businessState.optionIds=self.stateListIds
                }
                
            case .errors(let error):
                self.showToast(error)
            }
        }
        stateBoxMenu.didSelect{(selectedText,index) in
            self.checkCityListApi(state_id: self.stateListIds[index])
            self.stateBoxMenu.text = selectedText
            
        }
        businessState.didSelect{(selectedText,index) in
            self.checkCityListApi(state_id: self.stateListIds[index])
            self.businessState.text = selectedText
            
        }
        
        cityBoxMenu.didSelect{(selectedText,index) in
            self.cityBoxMenu.text = selectedText
        }
        
        businessCity.didSelect{(selectedText,index) in
            self.businessCity.text = selectedText
        }
        
    }
    
    private func checkCityListApi(state_id:Int){
        self.showProgress()
        ApiClient.getCityList(state_id){
            result, status in
            self.hideProgress()
            switch status{
            case .success:
                self.cityList.removeAll()
                if let response = try? JSON(data: result!){
                    if let cityLists = response["cities"].array{
                        for city in cityLists{
                            self.cityList.append(city["city_name"].stringValue)
                            
                        }
                    }
                    self.cityBoxMenu.optionArray = self.cityList
                    self.businessCity.optionArray = self.cityList
                }
                
            case .errors(let error):
                self.showToast(error)
            }
        }
    }
    
    
    @objc func stateChanged(switchState: UISwitch) {
        if businessSwitch.isOn {
            UIView.transition(with: businessStack, duration: 0.3, options: .showHideTransitionViews, animations: { self.businessStack.isHidden = true
            })
        }
        else {
            UIView.transition(with: businessStack, duration: 0.3, options: .showHideTransitionViews, animations: {
                self.businessStack.isHidden = false
            })
        }
    }
}
