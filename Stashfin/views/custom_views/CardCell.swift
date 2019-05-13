//
//  CardCell.swift
//  StashFinDemo
//
//  Created by Macbook on 16/04/19.
//  Copyright © 2019 StashFin. All rights reserved.
//

import UIKit
import FSPagerView

class CardCell: FSPagerViewCell{
    
    @IBOutlet weak var cellCardImage: UIImageView!
    @IBOutlet weak var cellCardNumber: UILabel!
    @IBOutlet weak var cellCardName: UILabel!
    @IBOutlet weak var cellCardValidity: UILabel!
    @IBOutlet weak var cvvStack: UIStackView!
    @IBOutlet weak var cvvLabel: UIView!
    @IBOutlet weak var bannerView: UIView!
    @IBOutlet weak var bannerImg: UIImageView!
    @IBOutlet weak var bannerLabel: UILabel!
    @IBOutlet weak var mm_yy_label: UILabel!
    @IBOutlet weak var valid_upto_label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func configure(with model: CardDataModel){
        
        
        if let img = model.cardImage{
            self.cellCardImage.image = img
        }
        if model.cardRegitster! {
            self.cellCardNumber.text = model.cardNumber
//            self.cellCardNumber.text = "xxxx   xxxx   xxxx   1234"
            self.cellCardName.text = model.cardName?.uppercased()
            self.cellCardValidity.text = model.cardValidity
        }
        if (cellCardImage.image==#imageLiteral(resourceName: "new_lock_img")){
            mm_yy_label.isHidden=true
            valid_upto_label.isHidden=true
            cellCardNumber.isHidden=true
            cellCardName.isHidden=true
            cellCardValidity.isHidden=true
        }
        
        if model.cardType!.contains("physical"){
             bannerImg.image = #imageLiteral(resourceName: "banner_physical")
        }else if model.cardType!.contains("virtual"){
            bannerImg.image = #imageLiteral(resourceName: "banner_virtual")
        }
        
        switch model.cardType {
        case "physicalRegisterError", "virtualRegisterError":
             bannerLabel.text = "Activation ERROR!"
        case "physicalNotRegister", "virtualNotRegister":
            bannerLabel.text = "Activate Card"
        case "physical":
            bannerLabel.text = "Physical Card"
        case "virtual":
            bannerLabel.text = "Virtual Card"
            if let cvvValue = model.cvv, cvvValue.count>2{
                enableCvv(cvv: cvvValue)
            }else{
                cvvStack.isHidden = true
            }
        default:
            Log("No card type \(String(describing: model.cardType))")
        }
        
    }
    
    private func enableCvv(cvv:String){
        let ls = LabelSwitchConfig(text: "Text1",
                                   textColor: .black,
                                   font: UIFont(name: Fonts.avenirNextRegular, size: 9) ?? UIFont.boldSystemFont(ofSize: 9) ,
                                   backgroundColor: .green)
        
        let rs = LabelSwitchConfig(text: "",
                                   textColor: .white,
                                   font: UIFont(name: Fonts.avenirNextRegular, size: 8) ?? UIFont.boldSystemFont(ofSize: 9),
                                   backgroundColor: .black)
        
        // Set the default state of the switch,
        let labelSwitch = LabelSwitch(center: .zero, leftConfig: ls, rightConfig: rs)
        
        // Set the appearance of the circle button
        labelSwitch.circleShadow = false
        labelSwitch.circleColor = .gray
        labelSwitch.fullSizeTapEnabled=true
        self.cvvLabel.bounds = labelSwitch.frame
        cvvLabel.addSubview(labelSwitch)
       
        cvvStack.isHidden = false
        labelSwitch.lText = cvv
        
    }
    
}
