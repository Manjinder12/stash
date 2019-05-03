//
//  BasicViewController.swift
//  StashFinDemo
//
//  Created by Macbook on 05/02/19.
//  Copyright © 2019 StashFin. All rights reserved.
//


import UIKit
import SwiftyJSON


class PersonalViewController: BaseLoginViewController {
    //    weak var delegate:BaseViewdelagate?
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var occupiedStackView: UIStackView!
    @IBOutlet weak var emailBox: UITextField!
    @IBOutlet weak var dobBox: UIButton!
    
    @IBOutlet weak var stateLabel: CustomUILabel!
    @IBOutlet weak var marritalMenu: DropDownBox!
    @IBOutlet weak var panBox: UITextField!
    @IBOutlet weak var aadhaarBox: UITextField!
    @IBOutlet weak var cityBox: DropDownBox!
//    @IBOutlet weak var stateLabel: CustomUILabel!
    @IBOutlet weak var stateListMenu: DropDownBox!
    @IBOutlet weak var pinCodeBox: UITextField!
    @IBOutlet weak var employmentBox: DropDownBox!
    @IBOutlet weak var residenceTypeMenu: DropDownBox!
    @IBOutlet weak var currentAddressBox: UITextField!
    @IBOutlet weak var landmarkBox: UITextField!
    @IBOutlet weak var occupiedSinceMonth: DropDownBox!
    @IBOutlet weak var occupiedSinceYear: DropDownBox!
    @IBOutlet weak var permanentAddressSwitch: UISwitch!
    
    @IBOutlet weak var permanentAddressStackView: UIStackView!
    @IBOutlet weak var permanentAddressBox: UITextField!
    @IBOutlet weak var permanentLandmarkBox: UITextField!
    @IBOutlet weak var permanentCityMenu: DropDownBox!
    @IBOutlet weak var permanenetStatemenu: DropDownBox!
    @IBOutlet weak var permanentPinCodeBox: UITextField!
    @IBOutlet weak var femaleBtn: UIButton!
    @IBOutlet weak var maleBtn: UIButton!
    @IBOutlet weak var checkBoxBtn: UIButton!
    
    
    var stateList:[String] = []
    var stateListIds:[Int] = []
    var cityList:[String]=[]
    var cityListPermanent:[String]=[]
    var genderValue:String=""
    var cityValue=""
    var checked=false
    
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if cityValue.count>2{
            cityBox.text=cityValue
            stateListMenu.isHidden=true
            stateLabel.isHidden=true
            cityBox.arrow.isHidden=true
            cityBox.isUserInteractionEnabled=false
        }
        
        setDropDownMenu()
        checkStateListApi()
        permanentAddressSwitch.addTarget(self, action: #selector(stateChanged), for: .valueChanged)
        
        panBox.addTarget(self, action: #selector(checkValidNumber(field:)), for: .editingChanged)
        aadhaarBox.addTarget(self, action: #selector(checkAadhaarValidation(field:)), for: .editingChanged)
        pinCodeBox.addTarget(self, action: #selector(pinCodeValidation(field:)), for: .editingChanged)
        permanentPinCodeBox.addTarget(self, action: #selector(pinCodeValidation(field:)), for: .editingChanged)

    }
    
    @objc func pinCodeValidation(field: UITextField){
        let MAX_LENGHT = 6
        if let text = field.text, text.count >= MAX_LENGHT {
            field.text = String(text.dropLast(text.count - MAX_LENGHT))
            return
        }
    }
    
    @objc func checkValidNumber(field: UITextField){
        let MAX_LENGHT = 10
        if let text = field.text, text.count >= MAX_LENGHT {
            field.text = String(text.dropLast(text.count - MAX_LENGHT))
            return
        }
    }
    
    @objc func checkAadhaarValidation(field: UITextField){
        let MAX_LENGHT = 12
        if let text = field.text, text.count >= MAX_LENGHT {
            field.text = String(text.dropLast(text.count - MAX_LENGHT))
            return
        }
    }
    
    @objc func stateChanged(switchState: UISwitch) {
        if switchState.isOn {
            UIView.transition(with: permanentAddressStackView, duration: 0.3, options: .showHideTransitionViews, animations: { self.permanentAddressStackView.isHidden = true
            })
            
        }
        else {
            UIView.transition(with: permanentAddressStackView, duration: 0.3, options: .showHideTransitionViews, animations: {
                self.permanentAddressStackView.isHidden = false
            })
        }
    }
    
    
    // MARK: - Init
    
    // MARK: - Properties
    
    private func setDropDownMenu(){
        marritalMenu.optionArray = ["Married","Unmarried"]
        employmentBox.optionArray = ["Salaried","Self Employed"]
        var month:Int = 1
        while month < 13
        {
            occupiedSinceMonth.optionArray.append("\(month)")
            month = month+1
        }
        let currentYear = Calendar.current.component(.year, from: Date())
        var year:Int = currentYear
        while year > 1970 {
            occupiedSinceYear.optionArray.append("\(year)")
            year = year-1
        }
        
        residenceTypeMenu.optionArray = ["Self Owned","Owned By Family","Rented with Family","Rented with Friends"]
        
        marritalMenu.didSelect{(selectTedText,index) in
            self.marritalMenu.text = selectTedText
            
        }
        occupiedSinceYear.didSelect{(selectedText,index) in
            self.occupiedSinceYear.text = selectedText
        }
        employmentBox.didSelect{(selectedText,index) in
            self.employmentBox.text = selectedText
        }
        
        occupiedSinceMonth.didSelect{(selectedText,index) in
            self.occupiedSinceMonth.text = selectedText
        }
        residenceTypeMenu.didSelect{(selectedText,index) in
            self.residenceTypeMenu.text = selectedText
        }
        
        
        self.permanentAddressStackView.isHidden = true
    }
    
    
    
    // MARK: - Handlers
    private func checkStateListApi(){
        
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
                    self.stateListMenu.optionArray = self.stateList
                    self.stateListMenu.optionIds=self.stateListIds
                    self.permanenetStatemenu.optionArray = self.stateList
                    self.permanenetStatemenu.optionIds=self.stateListIds
                }
                
            case .errors(let error):
                self.showToast(error)
            }
        }
        stateListMenu.didSelect{(selectedText,index) in
            self.checkCityListApi(state_id: self.stateListIds[index],type: "current")
            self.stateListMenu.text = selectedText
            
        }
        permanenetStatemenu.didSelect{(selectedText,index) in
            self.checkCityListApi(state_id: self.stateListIds[index],type:"permanent")
            self.permanenetStatemenu.text = selectedText
        }
        
        cityBox.didSelect{(selectedText,index) in
            self.cityBox.text = selectedText
        }
        
        permanentCityMenu.didSelect{(selectedText,index) in
            self.permanentCityMenu.text = selectedText
        }
    }
    
    private func checkCityListApi(state_id:Int,type:String){
        self.showProgress()
        ApiClient.getCityList(state_id){
            result, status in
            self.hideProgress()
            switch status{
            case .success:
                if type == "permanent"{
                    self.cityListPermanent.removeAll()
                }else{
                    self.cityList.removeAll()
                }
                if let response = try? JSON(data: result!){
                    if let cityLists = response["cities"].array{
                        for city in cityLists{
                            if type == "permanent"{
                                self.cityListPermanent.append(city["city_name"].stringValue)
                            }else{
                                self.cityList.append(city["city_name"].stringValue)
                            }
                        }
                    }
                    if type == "permanent"{
                        self.permanentCityMenu.optionArray = self.cityListPermanent
                    }else{
                        self.cityBox.optionArray = self.cityList
                    }
                }
                
            case .errors(let error):
                self.showToast(error)
            }
        }
    }
    
    
    
    
    //MARK: - Actions
    
    @IBAction func datePicker(_ sender: UIButton) {
        
        let currentDate: Date = Date()
        var calendar: Calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        calendar.timeZone = TimeZone(identifier: "UTC")!
        var components: DateComponents = DateComponents()
        components.calendar = calendar
        components.year = -18
        let maxDate: Date = calendar.date(byAdding: components, to: currentDate)!
        components.year = -65
        let minDate: Date = calendar.date(byAdding: components, to: currentDate)!
        
        DatePickerDialog().show("Date of birth", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", minimumDate: minDate, maximumDate: maxDate, datePickerMode: .date) {
            (date) -> Void in
            if let dt = date {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                sender.setTitle(formatter.string(from: dt),for: .normal)
                
            }
        }
    }
    @IBAction func maleTap(_ sender: UIButton) {
        //        sender.isSelected = !sender.isSelected
        
        //        if let image  = UIImage(named: "male") {
        sender.setBackgroundImage(#imageLiteral(resourceName: "male"), for: .normal)
        //        sender.setTitleColor(.white, for: .normal)
        genderValue="M"
        self.femaleBtn.setBackgroundImage(#imageLiteral(resourceName: "female"), for: .normal)
        //        }
    }
    
    @IBAction func femaleTap(_ sender: UIButton) {
        //        sender.isSelected = !sender.isSelected
        
        //        if let image = UIImage(named: "female_2"){
        sender.setBackgroundImage(#imageLiteral(resourceName: "female_2"), for: .normal)
        //        sender.setTitleColor(.white, for: .normal)
        
        genderValue="F"
        self.maleBtn.setBackgroundImage(#imageLiteral(resourceName: "male_2"), for: .normal)
        //        }
    }
    
    
    @IBAction func backBtn(_ sender: UIButton) {
        onBackPressed()
    }
    
    @IBAction func openProfessionalBtn(_ sender: UIButton) {
        
        if emailBox.isEditBoxNotEmpty() && marritalMenu.isEditBoxNotEmpty() && panBox.isEditBoxNotEmpty() && aadhaarBox.isEditBoxNotEmpty() && employmentBox.isEditBoxNotEmpty() && residenceTypeMenu.isEditBoxNotEmpty() && cityBox.isEditBoxNotEmpty() && currentAddressBox.isEditBoxNotEmpty() && landmarkBox.isEditBoxNotEmpty() && pinCodeBox.isEditBoxNotEmpty() && occupiedSinceMonth.isEditBoxNotEmpty() && occupiedSinceYear.isEditBoxNotEmpty() {
            if let dob = dobBox.titleLabel?.text{
                if !genderValue.isEmpty{
                    if Utilities.isEmailValid(email: emailBox.text.isNilOrValue){
                        if panBox.text?.count == 10 {
                            if aadhaarBox.text?.count == 12{
                                if currentAddressBox.text.isNilOrValue.count>5{
                                    if landmarkBox.text.isNilOrValue.count>5{
                                        if pinCodeBox.text.isNilOrValue.count==6{
                                            if !permanentAddressStackView.isHidden{
                                                if permanentAddressBox.isEditBoxNotEmpty() && permanentCityMenu.isEditBoxNotEmpty() && permanentLandmarkBox.isEditBoxNotEmpty() && permanentPinCodeBox.isEditBoxNotEmpty(){
                                                    if permanentAddressBox.text.isNilOrValue.count>5{
                                                        if permanentLandmarkBox.text.isNilOrValue.count>5{
                                                            if permanentPinCodeBox.text.isNilOrValue.count==6{
                                                                hitPersonalApi(dob)
                                                            }else{
                                                                permanentPinCodeBox.becomeFirstResponder()
                                                                self.showToast("Pin code is not valid")
                                                            }
                                                        }else{
                                                            permanentPinCodeBox.becomeFirstResponder()
                                                            self.showToast("Landmark is too short")
                                                        }
                                                    }else{
                                                        permanentAddressBox.becomeFirstResponder()
                                                        self.showToast("Address is too short")
                                                    }
                                                }
                                            }else{
                                                hitPersonalApi(dob)
                                            }
                                        }else{
                                            pinCodeBox.becomeFirstResponder()
                                            self.showToast("Pin code is not valid")
                                        }
                                    }else{
                                        landmarkBox.becomeFirstResponder()
                                        self.showToast("Landmark is too short")
                                    }
                                }else{
                                    currentAddressBox.becomeFirstResponder()
                                    self.showToast("Address is too short")
                                }
                            }else{
                                aadhaarBox.becomeFirstResponder()
                                self.showToast("Aadhaar is not valid")
                            }
                        }else{
                            panBox.becomeFirstResponder()
                            self.showToast("Pan number is not valid")
                        }
                    }else{
                        emailBox.becomeFirstResponder()
                        self.showToast("Email is not valid")
                    }
                }else{
                    self.showToast("Please select gender")
                }
            }else{
                self.showToast("Please select DOB")
            }
        }
    }
    
    private func hitPersonalApi(_ dob:String){
        if self.checkBoxBtn.currentBackgroundImage != #imageLiteral(resourceName: "check_box") {
            self.showToast("Please select terms and condition.")
            return
        }
        let param:[String:String]=["mode":"personal_details","email":emailBox.text.isNilOrValue,"dob":dob,"pan_number":panBox.text.isNilOrValue,"aadhaar_number":aadhaarBox.text.isNilOrValue,"employement_type":employmentBox.text.isNilOrValue,"residence_type":residenceTypeMenu.text.isNilOrValue,"pincode":pinCodeBox.text.isNilOrValue,"address":currentAddressBox.text.isNilOrValue,"city_name":cityBox.text.isNilOrValue,"permanent_address":permanentAddressBox.text.isNilOrValue,"permanent_city_name":permanentCityMenu.text.isNilOrValue,"permanent_pincode":permanentPinCodeBox.text.isNilOrValue,"permanentAddressCheck":(permanentAddressStackView.isHidden ? "1" : "0"),"gender":genderValue,"month":occupiedSinceMonth.text.isNilOrValue,"year":occupiedSinceYear.text.isNilOrValue,"matital_status":marritalMenu.text.isNilOrValue,"landmark":landmarkBox.text.isNilOrValue,"permanent_landmark":permanentLandmarkBox.text.isNilOrValue]
        self.showProgress()
        ApiClient.getJSONResponses(route: APIRouter.v2Api(param: param)){
            result, code in
            self.hideProgress()
            switch code{
            case .success:
                self.changeViewController(response: result)
            case .errors(let error):
                print(error)
                self.showToast(error)
                
            }
        }
    }
    
    @IBAction func checkBoxBtn(_ sender: UIButton) {
        if checked{
            checkBoxBtn.setBackgroundImage(#imageLiteral(resourceName: "box"), for: .normal)
            checked=false
        }else{
            checkBoxBtn.setBackgroundImage(#imageLiteral(resourceName: "check_box"), for: .normal)
            checked=true
            
        }
    }
    
}

