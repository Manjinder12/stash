//
//  PickupViewController.swift
//  StashFinDemo
//
//  Created by Macbook on 05/02/19.
//  Copyright © 2019 StashFin. All rights reserved.
//


import UIKit

class PickupViewController: BaseLoginViewController {
    
    @IBOutlet weak var pickupAddressLabel: CustomUILabel!
    @IBOutlet weak var instructionField: UITextField!
    @IBOutlet weak var shedulePickupBtn: DropDownButton!
    @IBOutlet weak var scheduleTimeBtn: DropDownButton!
    
    @IBOutlet weak var pickupConfirmDialogView: UIView!
    @IBOutlet weak var pickupDate: UILabel!
    @IBOutlet weak var pickupAddress: CustomUILabel!
    @IBOutlet weak var pickupTime: CustomUILabelBold!
    @IBOutlet weak var pickupItem1: CustomUILabel!
    @IBOutlet weak var pickupItem2: CustomUILabel!
    @IBOutlet weak var pickupItem3: CustomUILabel!
    
    
    var timeList = [String]()
    var dropDownDate = DropDown()
    var dropDownTime = DropDown()
    let formatter = DateFormatter()
    let formatterShow = DateFormatter()
    
    public var address = ""
    public var currrent_date = ""
    public var pdf_url = ""
    public var occupation_type = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        pickupAddressLabel.text = address
        pickupAddressLabel.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        pickupAddressLabel.layer.borderWidth = 0.5
        pickupAddressLabel.layer.cornerRadius = 5
        pickupAddressLabel.layer.masksToBounds = true
        
        pickupAddress.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        pickupAddress.layer.borderWidth = 0.5
        pickupAddress.layer.cornerRadius = 5
        pickupAddress.layer.masksToBounds = true
        
        // Do any additional setup after loading the view.
        formatter.dateFormat = "yyyy-MM-dd"
        formatterShow.dateFormat = "dd-MM-yyyy"
        
//        timeList.append("6 AM-10 PM")
       
        if (occupation_type == "self employed"){
            pickupItem3.text = "Bank Account Cheque"
        }else{
            pickupItem3.text = "Salary Account Cheque"
        }
        
        let date = Date()
        let calendar = Calendar.current
        let day1 = formatterShow.string(from: date)
        let day2 = formatterShow.string(from: calendar.date(byAdding: .day, value: 1, to: date)!)
        let day3 = formatterShow.string(from: calendar.date(byAdding: .day, value: 2, to: date)!)
        let day4 = formatterShow.string(from: calendar.date(byAdding: .day, value: 3, to: date)!)
        var dateList = [String]()
        dateList.append(day1)
        dateList.append(day2)
        dateList.append(day3)
        dateList.append(day4)
        
        self.dropDownDate.anchorView = shedulePickupBtn
        self.dropDownDate.dataSource = dateList
        dropDownDate.selectionAction = {  (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.shedulePickupBtn.setTitle(item,for: .normal)
            DispatchQueue.main.async {
                self.setTimeDropMenu()
            }
        }
        
        self.dropDownTime.anchorView = scheduleTimeBtn
        dropDownTime.selectionAction = {  (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.scheduleTimeBtn.setTitle(item, for: .normal)
        }
    }
    
    @IBAction func submitpickup(_ sender: UIButton) {
        
        let date = shedulePickupBtn.titleLabel?.text ?? ""
        let time = scheduleTimeBtn.titleLabel?.text ?? ""
        if !date.isEmpty && !time.isEmpty {
            pickupDate.text = self.shedulePickupBtn.currentTitle
            pickupTime.text = self.scheduleTimeBtn.currentTitle
            pickupAddress.text =  pickupAddressLabel.text.isNilOrValue
            pickupConfirmDialogView.isHidden=false
            
            self.downloadFile(urlString: pdf_url)
        }else{
            self.showToast("Please select pickup date and time")
        }
    }
    
    @IBAction func scheduleTime(_ sender: DropDownButton) {
       
        dropDownTime.show()
    }
    
    private func setTimeDropMenu(){
        
        timeList.removeAll()
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        
        let currentDate = self.formatterShow.string(from: date)
        
        if let pickupDate = shedulePickupBtn.titleLabel?.text, pickupDate == currentDate  {
            
            if hour <= 6 {
                timeList.append("10 AM-1 PM")
                timeList.append("1 PM-4 PM")
                timeList.append("4 PM-7 PM")
            }else if hour > 6 && hour < 10{
                timeList.append("1 PM-4 PM")
                timeList.append("4 PM-7 PM")
            }else if hour >= 10 && hour < 13{
                timeList.append("4 PM-7 PM")
            }else{
                self.showToast("No slots available today, Please select future date")
            }
        }else{
            timeList.append("10 AM-1 PM")
            timeList.append("1 PM-4 PM")
            timeList.append("4 PM-7 PM")
        }
//        if timeList.count>0{
//            scheduleTimeBtn.setTitle(timeList[0], for: .normal)
//
//        }else{
            scheduleTimeBtn.setTitle("", for: .normal)
//        }
        self.dropDownTime.dataSource = timeList
    }
    
    
    @IBAction func scheduleDate(_ sender: DropDownButton) {
        dropDownDate.show()
    }
    
    @IBAction func pickupConfirm(_ sender: UIButton) {
        
        let myDate = self.formatterShow.date(from: pickupDate.text.isNilOrValue)!
        let date = self.formatter.string(from: myDate)
       
        let params = ["mode":"pickup_details","date":date,"time_slot":pickupTime.text.isNilOrValue,"instruction":instructionField.text.isNilOrValue]
        ApiClient.getJSONResponses(route: APIRouter.v2Api(param: params))
        {
            result, status in
                switch status {
                case .success:
                    self.changeViewController(response: result)
                case .errors(let error):
                    self.showToast(error)
                }
        }
    }
    
    
    @IBAction func closeBtn(_ sender: UIButton) {
    pickupConfirmDialogView.isHidden=true
    }
    
    // MARK: - Init
    
    // MARK: - Properties
    
    // MARK: - Handlers
   
    
}
