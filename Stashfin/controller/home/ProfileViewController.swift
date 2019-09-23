//
//  ProfileViewController.swift
//  StashFinDemo
//
//  Created by Macbook on 08/04/19.
//  Copyright © 2019 StashFin. All rights reserved.
//

import UIKit
import SwiftyJSON
import SDWebImage

//downarrow

struct DataName {
    var key,value:String
}

struct DocumentModel{
    var opened = Bool()
    var title = String()
    var cellData = [DataName]()
}

class DocumentCell:UITableViewCell{
    
    @IBOutlet weak var valueName: UILabel!
    @IBOutlet weak var keyName: CustomUILabel!
    
}


class ProfileViewController: BaseViewController{
    
    static func getInstance(storyboard: UIStoryboard) -> ProfileViewController{
        return storyboard.instantiateViewController(withIdentifier: String(describing: self.classForCoder())) as! ProfileViewController
    }
    
    @IBOutlet weak var profilePicImg: UIImageView!
    @IBOutlet weak var coverPicImg: UIImageView!
    @IBOutlet weak var profileTableView: UITableView!
    var tableData=[DocumentModel]()
    
    var personalCellData=[DataName]()
    var professionalCellData=[DataName]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="Profile"
        
        setUpMenuButton()
        
        profileTableView.register(UINib(nibName: "KeyValueTableViewCell", bundle: nil), forCellReuseIdentifier: "KeyValueTableViewCell")

        
        self.personalCellData = [DataName(key: "Name",value: ""),DataName(key: "Email",value: ""),DataName(key: "Phone",value: ""),DataName(key: "DOB",value: "")]
        
        self.professionalCellData = [DataName(key: "Company Name",value: ""),DataName(key: "Designation",value: ""),DataName(key: "Working Since",value: ""),DataName(key: "Office Email",value: "")]
        
        self.tableData = [DocumentModel(opened: false, title: "Personal", cellData: self.personalCellData), DocumentModel(opened: false, title: "Professional", cellData: self.professionalCellData)]
        
        setImage()
        checkProfileApi()
        
    }
    
    @IBAction func changeProfilePic(_ sender: UIButton) {
        AttachmentHandler.shared.showAttachmentActionSheet(vc: self,title: "Profile Pic",captureType: "camera")
        AttachmentHandler.shared.imagePickedBlock = { (image) in
           
            self.showProgress()
            if let baseStringImage:String = image.base64(format: ImageFormat.jpeg(0.6)){
              
                var params:[String:String]=["mode":"updateProfilePic","image":baseStringImage]
               
            
                ApiClient.getJSONResponses(route: APIRouter.stasheasyApi(param: params)){
                    result,status in
                    self.hideProgress()
                    switch status{
                    case .success:
                        print("Successfully uploaded")
                        if let response = try? JSON(data: result!){
                            params=["":""]
                            self.showToast("Successfully changed")
                            let url = response["file_url"].stringValue
                            SessionManger.getInstance.saveProfilePic(profile: url)
                        self.setImage()
                        }else{
                            self.showToast("Something went wrong, Please try again later")
                        }
                        
                    case .errors(let error):
                        self.showToast(error)
                    }
                }
                
            }else{
                self.showToast("Invalid image, please try again")
            }
        }
        
    }
    
    
    private func setImage(){
        if let url = URL(string: SessionManger.getInstance.getProfilePic()) {
            
            profilePicImg.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "user-1"),options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
                if let img = image{
                    self.profilePicImg.maskCircle(anyImage: img,number: 3)
                    self.coverPicImg.image=img
                    
                    let darkBlur = UIBlurEffect(style: UIBlurEffect.Style.light)
                    let blurView = UIVisualEffectView(effect: darkBlur)
                    blurView.frame =  self.coverPicImg.frame
                    blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                    blurView.alpha=0.8
                    self.coverPicImg.addSubview(blurView)
                }
            })
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        if   let bar:UINavigationBar =  self.navigationController?.navigationBar{
        //        self.title = "Whatever..."
        bar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        bar.shadowImage = UIImage()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if  let bar:UINavigationBar =  self.navigationController?.navigationBar{
        //        self.title = "Whatever..."
        bar.setBackgroundImage(UIImage(named: "UINavigationBarBackground.png"),
                               for: .default)
        //        bar.shadowImage =
        }
    }
    
    func setUpMenuButton(){
        let menuBtn = UIButton(type: .custom)
        menuBtn.frame = CGRect(x: 0.0, y: 0.0, width: 20, height: 20)
        menuBtn.setImage(UIImage(named:"doc_up"), for: .normal)
        menuBtn.addTarget(self, action: #selector(onDocMenuButtonPressed), for: UIControl.Event.touchUpInside)
        
        let menuBarItem = UIBarButtonItem(customView: menuBtn)
        let currWidth = menuBarItem.customView?.widthAnchor.constraint(equalToConstant: 24)
        currWidth?.isActive = true
        let currHeight = menuBarItem.customView?.heightAnchor.constraint(equalToConstant: 24)
        currHeight?.isActive = true
        self.navigationItem.rightBarButtonItem = menuBarItem
    }
    
    @objc func onDocMenuButtonPressed(){
        let controller = DocumentUploadViewController.getInstance(storyboard: self.storyBoardRegister)
        controller.pageType = "profile"
        self.goToNextViewController(controller:controller)
        
    }
    
    private func checkProfileApi(){
        let params=["mode":"getProfileDetails"]
        ApiClient.getJSONResponses(route: APIRouter.androidApi(param: params)){
            result, status in
            
            switch status{
            case .success:
                Log(result)
                
                if let json = try? JSON(data:result!){
                    self.tableData.removeAll()
                    
                    let name = json["customer_details"]["customer_name"].stringValue
                    let email = json["customer_details"]["email"].stringValue
                    let phone = json["customer_details"]["phone"].stringValue
                    let address = json["current_address"].stringValue
                    //                    let pan_number = json["customer_details"]["pan_number"].stringValue
                    //                    let aadhar_number = json["customer_details"]["aadhar_number"].stringValue
                    
                    self.personalCellData = [DataName(key: "Name",value: name),DataName(key: "Email",value: email),DataName(key: "Phone",value: phone),DataName(key: "Address",value: address)]
                    
                    let company_name = json["professional_details"]["company_name"].stringValue
                    let office_address = json["office_address"].stringValue
                    let workExp = "\(json["professional_details"]["workExp"].intValue) years"
                    let officeEmail = json["professional_details"]["officeEmail"].stringValue
                    
                    self.professionalCellData = [DataName(key: "Company Name",value: company_name), DataName(key: "Office Email",value: officeEmail), DataName(key: "Work Experience",value: workExp), DataName(key: "Office Address",value: office_address)]
                    
                    self.tableData = [DocumentModel(opened: false, title: "Personal", cellData: self.personalCellData), DocumentModel(opened: false, title: "Professional", cellData: self.professionalCellData)]
                    
                    self.profileTableView.reloadData()
                    
                }
                
            case .errors(let errors):
                self.showToast(errors)
            }
        }
    }
}

extension ProfileViewController:  UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData[section].cellData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        let cell = tableView.dequeueReusableCell(withIdentifier: "DocumentCell", for: indexPath) as! DocumentCell
                let cell = tableView.dequeueReusableCell(withIdentifier: "KeyValueTableViewCell", for: indexPath) as! KeyValueTableViewCell

        cell.keyLabel.text = tableData[indexPath.section].cellData[indexPath.row].key
        cell.valueLabel.text = tableData[indexPath.section].cellData[indexPath.row].value
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tableData[section].title
    }
    
}
