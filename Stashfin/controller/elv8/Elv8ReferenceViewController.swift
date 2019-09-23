//
//  Elv8ReferenceViewController.swift
//  Stashfin
//
//  Created by Macbook on 31/05/19.
//  Copyright © 2019 Stashfin. All rights reserved.
//

import UIKit

class Elv8ReferenceViewController: BaseLoginViewController {
    
    @IBOutlet weak var relativeView: UIView!
    @IBOutlet weak var friendView: UIView!
    
    @IBOutlet weak var relativeRelationBox: DropDownBox!
    @IBOutlet weak var relativeName: UITextField!
    @IBOutlet weak var relativeNumber: UITextField!
    @IBOutlet weak var friendRelationBox: DropDownBox!
    @IBOutlet weak var friendName: UITextField!
    @IBOutlet weak var friendNumber: UITextField!
    
    
    
    static func getInstance(storyboard: UIStoryboard) -> Elv8ReferenceViewController{
        return storyboard.instantiateViewController(withIdentifier: String(describing: self.classForCoder())) as! Elv8ReferenceViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        friendView.roundCorners([.topLeft,.bottomRight], radius: 10)
        relativeView.roundCorners([.topLeft,.bottomRight], radius: 10)
        // Do any additional setup after loading the view.
        friendNumber.addTarget(self, action: #selector(numberValidate(field:)), for: .editingChanged)
        relativeNumber.addTarget(self, action: #selector(numberValidate(field:)), for: .editingChanged)

        setDropDownBoxValue()
    }
    
    @objc func numberValidate(field: UITextField){
        let MAX_LENGHT = 10
        if let text = field.text, text.count >= MAX_LENGHT {
            field.text = String(text.dropLast(text.count - MAX_LENGHT))
            return
        }
    }
    
    private func setDropDownBoxValue(){
        relativeRelationBox.optionArray=["Spouse","Sibling","Parent","Child"]
        relativeRelationBox.didSelect(){
            item,index in
            self.relativeRelationBox.text=item
        }
        
        friendRelationBox.optionArray=["Friend","Spouse","Sibling","Parent","Child"]
        friendRelationBox.didSelect(){
            item,index in
            self.friendRelationBox.text=item
        }
    }
    
    @IBAction func nextBtn(_ sender: UIButton) {
        if relativeRelationBox.isEditBoxNotEmpty() && relativeName.isEditBoxNotEmpty() && relativeNumber.isEditBoxNotEmpty() &&
            friendRelationBox.isEditBoxNotEmpty() &&
            friendName.isEditBoxNotEmpty() && friendNumber.isEditBoxNotEmpty(){
            submitApi()
        }
    }
    
    private func submitApi(){
        
        let params = ["mode":"ele8_references","relation1":relativeRelationBox.text.isNilOrValue,"name1":relativeName.text.isNilOrValue,"phone1":relativeNumber.text.isNilOrValue,"reference_id1":"1","relation2":friendRelationBox.text.isNilOrValue,"name2":friendName.text.isNilOrValue,"phone2":friendNumber.text.isNilOrValue,"reference_id2":"2"]
        self.showProgress()
        ApiClient.getJSONResponses(route: APIRouter.v2Api(param: params)){
            result, status in
            self.hideProgress()
            switch status{
            case .success:
                self.changeViewController( response: result)
            case .errors(let error):
                self.showToast(error)
            }
        }
    }
    
    
}
