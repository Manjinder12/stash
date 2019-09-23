//
//  MenuViewController.swift
//  StashFinDemo
//
//  Created by Macbook on 08/04/19.
//  Copyright © 2019 StashFin. All rights reserved.
//

import UIKit
import SideMenu
import SDWebImage

class MenuModel{
    var itemName,itemImg:String
    
    init(itemName:String,itemImg:String) {
        self.itemName=itemName
        self.itemImg=itemImg
    }
}

class MenuCell: UITableViewVibrantCell{
    
    @IBOutlet weak var menuImg: UIImageView!
    @IBOutlet weak var menuItem: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

class DownMenuCell: UITableViewVibrantCell{
    
    @IBOutlet weak var menuName: UILabel!
    @IBOutlet weak var menuImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

class MenuViewController: BaseLoginViewController,UITableViewDataSource,UITableViewDelegate {
    var menus=[MenuModel]()
    var downMenus=[MenuModel]()
    
    @IBOutlet weak var topMenuTable: UITableView!
    @IBOutlet weak var downMenuTable: UITableView!
    
    @IBOutlet weak var profilePicImg: UIImageView!
    @IBOutlet weak var customerName: UILabel!
    @IBOutlet weak var coverPicImg: UIImageView!
    @IBOutlet weak var customerEmail: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        downMenus.append(MenuModel(itemName: "Help",itemImg: "help"))
        downMenus.append(MenuModel(itemName: "Logout",itemImg: "logout_dark"))
        
        // Do any additional setup after loading the view.
        customerName.text=SessionManger.getInstance.getName().uppercased()
        customerEmail.text=SessionManger.getInstance.getEmail().lowercased()
        
        setImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        menus.removeAll()
        setMenu()
    }
    
    private func setImage(){
        if let url = URL(string: SessionManger.getInstance.getProfilePic()) {
            
            profilePicImg.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "user-1"),options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
                if let img = image{
                    self.profilePicImg.maskCircle(anyImage: img,number: 3)
                    
                    //                    self.coverPicImg.image=img
                    //                    let darkBlur = UIBlurEffect(style: UIBlurEffect.Style.dark)
                    //                    let blurView = UIVisualEffectView(effect: darkBlur)
                    //                    blurView.frame =  self.coverPicImg.frame
                    //                    blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                    //                    blurView.alpha=0.9
                    //                    self.coverPicImg.addSubview(blurView)
                }
            })
            
        }
        
    }
    
    private func setMenu(){
        let applicationStatus = SessionManger.getInstance.getApplicationStatus()
        Log("menu status : \(applicationStatus)")
        switch applicationStatus {
        case Constants.ApplicationStatus.REJECTED:
            initMenu(menuType: Constants.ApplicationStatus.REJECTED)
        case Constants.ApplicationStatus.DOCPICK,Constants.ApplicationStatus.DOCPICKDONE,Constants.ApplicationStatus.START,Constants.ApplicationStatus.THANKU,Constants.ApplicationStatus.APPROVED:
            initMenu(menuType:"preApproved")
            //        case Constants.ApplicationStatus.APPROVED:
        //            initMenu(menuType:"status")
        case Constants.ApplicationStatus.DISBURSED,Constants.ApplicationStatus.CLOSED:
            initMenu(menuType:"loc")
        case "sa":
            initMenu(menuType:"elv8")
        default:
            initMenu()
            break
        }
    }
    
    private func initMenu(menuType:String=""){
        menus.append(MenuModel(itemName: "Home",itemImg: "home_dark"))
        //        menus.append(MenuModel(itemName: "Pay Now",itemImg: "home"))
        
        
        //        switch menuType {
        //        case "preApproved":
        //            menus.append(MenuModel(itemName: "Document",itemImg: "doc_up"))
        //
        //        case Constants.ApplicationStatus.REJECTED:
        //             menus.append(MenuModel(itemName: "Rejected",itemImg: "payment_history_grey"))
        ////        case "loc":
        //        case "elv8":
        //            menus.append(MenuModel(itemName: "Pay Now",itemImg: "payment_history_grey"))
        //        default:
        //            Log(menuType)
        //        }
        
        
        // card condition
        
        /*
         GET_STASHFIN_CARD
         CARD_PIN
         BLOCK_CARD
         ACTIVATE_CARD
         */
        
        //        menus.append(MenuModel(itemName: "Payment History",itemImg: "payment_history_grey"))
        menus.append(MenuModel(itemName: "StashFin Card",itemImg: "card_grey"))
        
        menus.append(MenuModel(itemName: "Payment History",itemImg: "payment_history_grey"))
        
        if SessionManger.getInstance.getTranxHideStatus(){
            menus.append(MenuModel(itemName: "Card Transcation",itemImg: "view_tnx"))
        }
        
        menus.append(MenuModel(itemName: "Profile",itemImg: "profile-1"))
        if menuType=="preApproved"{
            menus.append(MenuModel(itemName: "Documents",itemImg: "doc_up"))
        }
        //        menus.append(MenuModel(itemName: "Loan Calculator",itemImg: "loan_calc_2"))
        //        menus.append(MenuModel(itemName: "Payback",itemImg: "payback_logo_white"))
        
        if SessionManger.getInstance.getPaybackStatus(){
            menus.append(MenuModel(itemName: "Payback",itemImg: "payback_logo_white"))
        }
        
        menus.append(MenuModel(itemName: "Contact Us",itemImg: "customer_care"))
        menus.append(MenuModel(itemName: "Chats",itemImg: "chat_dark"))
        menus.append(MenuModel(itemName: "FAQs",itemImg: "faq_icon"))
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == downMenuTable{
            return downMenus.count
        }else{
            return menus.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:DownMenuCell!
        if tableView == downMenuTable{
            cell = (tableView.dequeueReusableCell(withIdentifier: "downMenu",for: indexPath) as! DownMenuCell)
            cell.menuName.text = downMenus[indexPath.row].itemName
            if let img = UIImage(named: downMenus[indexPath.row].itemImg){
                cell.menuImg.image = img
            }
            //            cell.selectionStyle = .none
            
            //            cell.selectionStyle = .none
            //            let backgroundView = UIView()
            //            backgroundView.backgroundColor = UIColor.red
            //            if cell.isSelected{
            //
            //                cell.backgroundColor = .gray
            //            }else{
            //                cell.selectedBackgroundView = backgroundView
            //            }
            
            return cell
        } else {
            let   cell = tableView.dequeueReusableCell(withIdentifier: "menu",for: indexPath) as! MenuCell
            cell.menuItem.text = menus[indexPath.row].itemName
            if let img = UIImage(named: menus[indexPath.row].itemImg){
                cell.menuImg.image = img
            }
            
            //            cell.selectionStyle = .none
            //            let backgroundView = UIView()
            //            backgroundView.backgroundColor = UIColor.red
            //            cell.selectedBackgroundView = backgroundView
            
            return cell
        }
        //        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var item:String = ""
        if tableView == downMenuTable {
            item = self.downMenus[indexPath.row].itemName;
        }else{
            item = self.menus[indexPath.row].itemName;
        }
        Log("menu clicked: \(item)")
        switch item {
        case "Home":
            self.showHomePage()
        case "Rejected":
            self.changeViewController(controllerName: Constants.Controllers.REJECT)
        case "StashFin Card":
            self.openStashFinCard()
        case "Profile":
            self.changeViewController(controllerName: Constants.Controllers.PROFILE_PAGE)
            
        case "Loan Calculator":
            self.changeViewController(controllerName: Constants.Controllers.LOAN_CALCULATOR)
        case "Card Transcation":
            self.changeViewController(controllerName: Constants.Controllers.TRANSACTION)
        case "Payback":
            self.changeViewController(controllerName: Constants.Controllers.PAYBACK)
            
        case "Payment History":
            self.changeViewController(controllerName: Constants.Controllers.PAYMENT_HISTORY)
            
        case "Documents":
            //            self.changeViewController(controllerName: Constants.Controllers.PAYBACK)
            let controller = DocumentUploadViewController.getInstance(storyboard: self.storyBoardRegister)
            controller.pageType = "profile"
            self.goToNextViewController(controller:controller)
        case "Contact Us":
            self.changeViewController(controllerName: Constants.Controllers.CUSTOMER_CARE)
        case "FAQs":
            let controller = WebViewViewController.getInstance(storyBoard: self.storyBoardMain)
            controller.urlType = "faqs"
            self.goToNextViewController(controller:controller)
        case "Chats":
            let controller = WebViewViewController.getInstance(storyBoard: self.storyBoardMain)
            controller.urlType = "chat"
            self.goToNextViewController(controller:controller)
        case "Logout":
            SessionManger.getInstance.clearAllData()
            self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
            
            //            AppDelegate.shared.rootViewController.showLoginScreen()
            
            //            self.changeViewController(controllerName: Constants.Controllers.LOGIN)
            
            //            SideMenuManager.default.menuLeftNavigationController!.dismiss(animated: true, completion: nil)
            //
            //            Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (timer) in
            //
            //            AppDelegate.shared.rootViewController.switchToLogout()
            //
            //           }
            
            
            
        default:
            self.showToast("default \(item) page not found")
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView == downMenuTable {
            return 50
        }
        let tableHeight = tableView.bounds.height
        let menusCount = menus.count+1
        let requiredItemHeight = menusCount*50
        
        if requiredItemHeight > Int(tableHeight){
            Log("menus.height : \(menus.count)")
            return tableHeight / CGFloat(menusCount)
        }else{
            return 50
        }
        
    }
}
