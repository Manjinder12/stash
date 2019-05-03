//
//  CardDetailsViewController.swift
//  StashFinDemo
//
//  Created by Macbook on 09/04/19.
//  Copyright © 2019 StashFin. All rights reserved.
//

import UIKit
import FSPagerView
import SwiftyJSON

struct CardDataModel{
    let cardImage:UIImage?
    let cardNumber, cardName, cardValidity, cvv, cardType: String?
    let cardRegitster:Bool?
    
    init(image:UIImage, cardNo:String="xxxx   xxxx   xxxx   0000", cardName:String="Name", cardValidity:String="00 / 00", cvv:String="", cardType:String, cardRegister:Bool=false) {
        self.cardImage=image
        self.cardNumber=cardNo
        self.cardName=cardName
        self.cardValidity=cardValidity
        self.cvv=cvv
        self.cardType=cardType
        self.cardRegitster=cardRegister
    }
}

class CardDetailsViewController: BaseLoginViewController, FSPagerViewDataSource,FSPagerViewDelegate {
    
    @IBOutlet weak var cardPagerView: FSPagerView!{
        didSet {
            let nib = UINib(nibName: "CardCell", bundle: nil)
            self.cardPagerView.register(nib,forCellWithReuseIdentifier: "CardCell")
            
            self.cardPagerView.itemSize = FSPagerView.automaticSize
            
        }
    }
    
    @IBOutlet weak var pageControl: FSPageControl! {
        didSet {
            self.pageControl.contentHorizontalAlignment = .center
            self.pageControl.contentInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            
            pageControl.setStrokeColor(.red, for: .normal)
            pageControl.setStrokeColor(.red, for: .selected)
            
            pageControl.setFillColor(.white, for: .normal)
            pageControl.setFillColor(.red, for: .selected)
        }
    }
    
    private var cardResponse:String = ""
    var cardData = [CardDataModel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        cardResponse = SessionManger.getInstance.getCardResponse()
        
        if !cardResponse.isEmpty{
            updateCardResponse()
        }else{
            checkCardApi()
        }
    }
    
    private func updateCardResponse(){
        let json = JSON(parseJSON: SessionManger.getInstance.getCardResponse())
        
        if json["cards"]["physical"].dictionary != nil{
            let otp_verified = json["cards"]["physical"]["otp_verified"].boolValue
            let card_registred = json["cards"]["physical"]["registered"].boolValue
            
            if card_registred {
                
                let card_no = getCardNumber(number: json["cards"]["physical"]["card_no"].stringValue)
                
                saveCardDetailsList(image: getCardImage(type:json["cards"]["physical"]["vendor_code"].stringValue), cardNo: card_no, cardName: json["card_details"]["name"].stringValue, cardValidity: "\(json["cards"]["physical"]["expiry_month"].stringValue) / \(json["cards"]["physical"]["expiry_year"].stringValue)",  cardType: "physical", cardRegister: true)
                
            }
            else if otp_verified{
                saveCardDetailsList(image: getCardImage(type: "not_register"), cardType: "physicalRegisterError")
            }
            else{
                saveCardDetailsList(image: getCardImage(type: "not_register"), cardType: "physicalNotRegister")
            }
        }
        else{
            saveCardDetailsList(image: getCardImage(type: ""), cardType: "physical")
        }
        
        if json["cards"]["virtual"].dictionary != nil{
            let otp_verified = json["cards"]["virtual"]["otp_verified"].boolValue
            let card_registred = json["cards"]["virtual"]["registered"].boolValue
            
            if card_registred{
                
                let card_no = getCardNumber(number: json["cards"]["virtual"]["card_no"].stringValue)
                
                saveCardDetailsList(image: getCardImage(type:json["cards"]["virtual"]["vendor_code"].stringValue), cardNo: card_no, cardName: json["card_details"]["name"].stringValue, cardValidity: "\(json["cards"]["virtual"]["expiry_month"].stringValue) / \(json["cards"]["virtual"]["expiry_year"].stringValue)", cvv: json["cards"]["virtual"]["cvv"].stringValue, cardType: "virtual", cardRegister: true)
            } else if otp_verified {
                saveCardDetailsList(image: getCardImage(type: "not_register"), cardType: "virtualRegisterError")
            }else{
                saveCardDetailsList(image: getCardImage(type: "not_register"), cardType: "virtualNotRegister")
            }
        }
        
        updateCardNumber()
    }
    
    private func updateCardNumber(){
        if cardData.count>1{
            self.pageControl.numberOfPages = cardData.count
            self.cardPagerView.isInfinite = true
        }
        cardPagerView.reloadData()
    }
    
    public func numberOfItems(in pagerView: FSPagerView) -> Int {
        return self.cardData.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "CardCell", at: index) as! CardCell
        if cardData.count>0{
            if cardData.count>1{
                cell.bannerView.isHidden=false
            }else{
                cell.bannerView.isHidden=true
            }
            cell.configure(with: cardData[index])
        }
        return cell
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        cardPagerView.deselectItem(at: index, animated: true)
        cardPagerView.scrollToItem(at: index, animated: true)
        if cardData.count>0{
            if cardData[index].cardType!.contains("NotRegister"){
                self.changeViewController(controllerName: Constants.Controllers.STASHFIN_CARD)
            }
        }
    }
    
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        self.pageControl.currentPage = targetIndex
    }
    
    func pagerViewDidEndScrollAnimation(_ pagerView: FSPagerView) {
        self.pageControl.currentPage = pagerView.currentIndex
    }
    
    private func checkCardApi() {
        ApiClient.getCardData(){
            result, status in
            switch status{
            case .success:
                self.updateCardResponse()
            case .errors(let errors):
                Log(errors)
                self.updateCardResponse()
            }
        }
    }
    
    private func getCardNumber(number:String)->String{
        let spaces="   "
        var card_no=""
        for i in number{
            if card_no.count>2 && (card_no.replacingOccurrences(of: " ", with: "").count)%4 == 0{
                card_no = card_no + ("\(spaces)\(i)")
            }else{
                card_no = card_no + ("\(i)")
            }
        }
        return card_no
    }
    
    private func saveCardDetailsList(image:UIImage, cardNo:String="xxxx   xxxx   xxxx   0000", cardName:String="Name", cardValidity:String="00 / 00", cvv:String="", cardType:String, cardRegister:Bool=false){
        
        cardData.append(CardDataModel(image: image, cardNo: cardNo, cardName: cardName, cardValidity: cardValidity, cvv: cvv, cardType: cardType, cardRegister: cardRegister))
    }
    
    private func getCardImage(type:String) -> UIImage{
        let M2P_DCB = "m2p_dcb";
        let M2P_FEDERAL = "m2p_federal";
        let MATCHMOVE_FEDERAL = "matchmove_federal";
        let NOT_REGISTER = "not_register";
        switch type {
        case M2P_DCB:
            return #imageLiteral(resourceName: "card_gray")
        case M2P_FEDERAL:
            return #imageLiteral(resourceName: "card_gray")
        case MATCHMOVE_FEDERAL:
            return #imageLiteral(resourceName: "card_blue")
        case NOT_REGISTER:
            return #imageLiteral(resourceName: "new_lock_img")
        default:
            return #imageLiteral(resourceName: "card_gray")
            
        }
    }
    
}
