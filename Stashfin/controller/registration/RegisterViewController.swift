//
//  PersonalViewController.swift
//  StashFinDemo
//
//  Created by Macbook on 05/02/19.
//  Copyright © 2019 StashFin. All rights reserved.
//

import UIKit
import Toast_Swift
import SwiftyJSON

class RegisterViewController: BaseLoginViewController{
    
    static func getInstance(storyboard: UIStoryboard) -> RegisterViewController{
        return storyboard.instantiateViewController(withIdentifier: String(describing: self.classForCoder())) as! RegisterViewController
    }
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var nameET: UITextField!
    @IBOutlet weak var mobileET: UITextField!
    @IBOutlet weak var cityET: DropDownBox!
    @IBOutlet weak var stateET: DropDownBox!
    @IBOutlet weak var monthlyET: UITextField!
    @IBOutlet weak var referralET: UITextField!
    @IBOutlet weak var cardNameLabel: UILabel!
    @IBOutlet weak var monthlyEmiStack: UIStackView!
    @IBOutlet weak var monthlyEmiField: CustomUITextField!
    
    
    var mobileNumber:String=""
    var stateList:[String] = []
    var stateListIds:[Int] = []
    var cityList:[String]=[]
    var profile_pic_base64 = ""
     var active_loan_status="0"
    
    @IBAction func backBtn(_ sender: UIButton) {
        onBackPressed()
    }
    
    @IBAction func personalBtn(_ sender: UIButton) {
        if(nameET.isEditBoxNotEmpty()&&mobileET.isEditBoxNotEmpty()&&stateET.isEditBoxNotEmpty()&&cityET.isEditBoxNotEmpty()&&monthlyET.isEditBoxNotEmpty()){
            if !profile_pic_base64.isEmpty{
                //            outgoingEMIs:2000
                //            profile_pic:base64
                Log("success personal")
                if active_loan_status=="1"{
                    if !monthlyEmiField.isEditBoxNotEmpty(){
                        return
                    }
                }
                let param:[String:String]=["mode":Constants.Modes.REGISTER,"name":nameET.text.isNilOrValue,"phone":mobileET.text.isNilOrValue,"city":cityET.text.isNilOrValue,"salary":monthlyET.text.isNilOrValue,"activeLoan":active_loan_status,"outgoingEMIs":monthlyEmiField.text.isNilOrValue,"profile_pic":profile_pic_base64,"referral_code":referralET.text.isNilOrValue,Constants.Values.device_id: Utilities.getDeviceIds()]
                self.showProgress()
                ApiClient.getJSONResponses(route: APIRouter.v2Api(param: param)){
                    result, code in
                    self.hideProgress()
                    switch code{
                    case .success:
                        print("result....\(String(describing: result!))");
                        if let json = try? JSON(data: result!){
                            SessionManger.getInstance.saveAuthToken(token: json[Constants.Key.AUTH_TOKEN].stringValue)
                            self.changeViewController(controllerName: json[Constants.Key.LANDING_PAGE].stringValue)
                        }
                    case .errors(let error):
                        print(error)
                        self.showToast(error)
                    }
                }
            }else{
                self.showToast("Please take a nice selfie")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mobileET.text=mobileNumber
        checkStateListApi()
        if mobileET.text?.count==10{
            mobileET.isUserInteractionEnabled = false
        }
        nameET.addTarget(self, action: #selector(cardName(field:)), for: .editingChanged)
        monthlyET.addTarget(self, action: #selector(checkValidAmount(field:)), for: .editingChanged)
        monthlyEmiField.addTarget(self, action: #selector(checkValidAmount(field:)), for: .editingChanged)

    }
    
    @objc func checkValidAmount(field: UITextField){
        let MAX_LENGHT = 8
        if let text = field.text, text.count >= MAX_LENGHT {
            field.text = String(text.dropLast(text.count - MAX_LENGHT))
            return
        }
    }
    
    @objc func cardName(field: UITextField){
        cardNameLabel.text = field.text?.uppercased()
    }
    
    // MARK: - Init
    
    // MARK: - Properties
    
    // MARK: - Handlers
    private func submitApiDetails(){
        if (nameET.text.isNilOrEmpty ){
            //            submitStatus=true
        }
        
    }
    
    
    @IBAction func activeLoanSwitch(_ sender: UISwitch) {
        if sender.isOn{
            monthlyEmiStack.isHidden=false
            active_loan_status="1"
        }else{
            monthlyEmiStack.isHidden=true
            active_loan_status="0"
        }
    }
    
    @IBAction func captureProfilePic(_ sender: UIButton) {
        AttachmentHandler.shared.showAttachmentActionSheet(vc: self,title: "Profile Pic",captureType: "camera")
//        AttachmentHandler.shared.showAttachmentActionSheet(vc: self,title: "Profile Pic")
        AttachmentHandler.shared.imagePickedBlock = { (image) in
            /* get your image here */
            //            self.profileImg.image = image
            self.profileImg.maskCircle(anyImage:image)
            if let base:String = image.base64(format: ImageFormat.jpeg(0.6)){
                self.profile_pic_base64 = base
            }else{
                self.showToast("Invalid image, please try again")
            }
        }
    }
    
    private func checkStateListApi(){
        ApiClient.getStateList(){
            result, status in
            self.stateList.removeAll()
            switch(status){
            case .success:
                if let response = try? JSON(data: result!){
                    if  let states = response["states"].array{
                        for state in states {
                            self.stateList.append(state["state_name"].stringValue)
                            self.stateListIds.append(state["id"].intValue)
                        }
                    }
                    self.stateET.optionArray = self.stateList
                    self.stateET.optionIds=self.stateListIds
                }
                
            case .errors(let error):
                self.showToast(error)
            }
        }
        stateET.didSelect{(selectedText,index) in
            self.checkCityListApi(state_id: self.stateListIds[index])
            self.stateET.text = selectedText
            
        }
        
        cityET.didSelect{(selectedText,index) in
            self.cityET.text = selectedText
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
                    self.cityET.optionArray = self.cityList
                }
                
            case .errors(let error):
                self.showToast(error)
            }
        }
    }
    
}
