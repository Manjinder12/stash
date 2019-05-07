//
//  CustomerCareViewController.swift
//  StashFinDemo
//
//  Created by Macbook on 08/04/19.
//  Copyright © 2019 StashFin. All rights reserved.
//

import UIKit
import SwiftyJSON

class CustomerCareViewController: BaseViewController {
    
    static func getInstance(storyboard: UIStoryboard) -> CustomerCareViewController{
        return storyboard.instantiateViewController(withIdentifier: String(describing: self.classForCoder())) as! CustomerCareViewController
    }
    
    var ticketItemList=[String]()
    @IBOutlet weak var listItemBtn: DropDownBox!
    @IBOutlet weak var messageText: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listItemBtn.adjustsFontSizeToFitWidth = true
//        listItemBtn.dropDown.width=view.frame.width*0.9
        setListItem()
        checkListApi()
        listItemBtn.didSelect{
            selectedText, index in
            self.listItemBtn.text=selectedText
        }
        messageText.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        messageText.layer.borderWidth = 1.0
        messageText.layer.cornerRadius = 5
    }
    
    
    private func checkListApi(){
        let params=["mode":"tokenApiCategoryList"]
        ApiClient.getJSONResponses(route: APIRouter.androidApi(param: params) ){
            result , status in
            switch status{
            case .success:
                if let json = try? JSON(data: result!){
                    if let listItem = json["tokenApiCategoryList"].array, listItem.count>0 {
                        self.ticketItemList.removeAll()
                        for item in listItem{
                            if let itemName = item["query_type_name"].string,itemName.count>1{
                                Log(itemName)
                                self.ticketItemList.append(itemName)
                            }
                        }
                        self.listItemBtn.optionArray=self.ticketItemList
                    }
                }
            case .errors(let error):
                self.showToast(error)
            }
        }
    }
    
    
    
    @IBAction func submitTicket(_ sender: UIButton) {
        
        if listItemBtn.isEditBoxNotEmpty() {
            if messageText.text.count>3{
        let params=["mode":"Ticketapi","category":listItemBtn.text.isNilOrValue,"message":messageText.text.isNilOrValue]
                self.showProgress()
        ApiClient.getJSONResponses(route: APIRouter.androidApi(param: params)){
            result, status in
            self.hideProgress()
            switch status{
            case .success:
                
                let alert = UIAlertController.init(title: "Feedback", message: "\nThank you for your feedback. Our customer support team will contact you soon.", preferredStyle: .alert)
                alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: {(_)->Void in
                    self.showHomePage()
                }
                    
                ))
                self.present(alert,animated: true,completion: nil)
            case .errors(let error):
                self.showToast(error)
            }
                }
            }else{
                self.showToast("Message is required")
            }
        }
    }
    
    
    private func setListItem(){
        ticketItemList.append("I want to upload my Bank Statement")
        ticketItemList.append("I want to upload my Documents")
        ticketItemList.append("I want to top-up my existing loan with StashFin")
        ticketItemList.append("Email/ Phone/ Address Change")
        ticketItemList.append("Foreclose my Loan")
        ticketItemList.append("Increase LOC")
        ticketItemList.append("Reschedule My Pickup")
        ticketItemList.append("I am an existing StashFin Customer")
        ticketItemList.append("Questions about my StashFin Card")
        ticketItemList.append("I am not a StashFin customer. I want to Apply for a Loan or Card")
        ticketItemList.append("I have lost my StashFin Card")
        ticketItemList.append("I have closed my loan with StashFin and want to apply for another loan")
        ticketItemList.append("I want to register my StashFin Card")
        ticketItemList.append("I have EMI related questions")
        ticketItemList.append("Arrange callback")
        ticketItemList.append("Payment Update Status")
        ticketItemList.append("Loan status")
        ticketItemList.append("Elev8 related issues")
        ticketItemList.append("My application is under process")
        ticketItemList.append("Other issue")
        listItemBtn.optionArray=ticketItemList
    }
    
}
