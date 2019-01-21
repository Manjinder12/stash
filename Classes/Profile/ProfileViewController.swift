//
//  ProfileViewController.swift
//  StashFin
//
//  Created by sachin khard on 09/09/18.
//  Copyright © 2018 StashFin. All rights reserved.
//

import UIKit
import SDWebImage
import SnapKit
import ParallaxHeader

@objc class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var serverResponse: NSDictionary!
    var cellStates: NSMutableArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cellStates = [0,0,0,0]
        self.perform(#selector(getProfileDetailFromServer), with: nil, afterDelay: 0.1)
        
        setupParallaxHeader()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Profile"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.title = ""
    }
    
    //MARK: private
    
    private func setupParallaxHeader() {

        let dic : NSDictionary = AppDelegate.instance().loginData as! NSDictionary
        let imageURL : String = ApplicationUtils.validateStringData(dic["profile_pic"])
        
        let imageView = UIImageView()
        imageView.sd_setImage(with: URL(string: imageURL))
        imageView.contentMode = .scaleAspectFill
        
        //setup bur view
        imageView.blurView.setup(style: UIBlurEffectStyle.dark, alpha: 0).enable()
        
        tableView.parallaxHeader.view = imageView
        tableView.parallaxHeader.height = 250
        tableView.parallaxHeader.minimumHeight = 120
        tableView.parallaxHeader.mode = .centerFill
        tableView.parallaxHeader.parallaxHeaderDidScrollHandler = { parallaxHeader in
            //update alpha of blur view on top of image view
            parallaxHeader.view.blurView.alpha = 1 - parallaxHeader.progress
        }
        
        let roundIcon = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        roundIcon.sd_setImage(with: URL(string: imageURL))
        roundIcon.contentMode = .scaleAspectFill
        roundIcon.layer.borderColor = UIColor.white.cgColor
        roundIcon.layer.borderWidth = 2
        roundIcon.layer.cornerRadius = roundIcon.frame.width / 2
        roundIcon.clipsToBounds = true
        
        //add round image view to blur content view
        //do not use vibrancyContentView to prevent vibrant effect
        imageView.blurView.blurContentView?.addSubview(roundIcon)
        //add constraints using SnpaKit library
        roundIcon.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(100)
        }
    }
    
    
    //MARK: table view data source/delegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 20
        }
        else {
            let state = cellStates[indexPath.row] as! Int
            if state == 1  {
                return 280
            }
            return 80
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellStates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = UITableViewCell()
            cell.selectionStyle = .none
            cell.accessoryType = .none
            cell.backgroundColor = .clear
            cell.backgroundView = nil
            return cell
        }
        else {
            let cell : ProfileCell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell") as! ProfileCell
            cell.selectionStyle = .none
            cell.accessoryType = .none
            cell.backgroundColor = .clear
            cell.backgroundView = nil
            
            cell.bgView!.layer.cornerRadius = 5
            cell.bgView!.layer.borderColor = UIColor.lightGray.cgColor
            cell.bgView!.layer.borderWidth = 0.5
            
            cell.button!.titleLabel?.font = ApplicationUtils.getfont_MEDIUM(19)
            cell.button!.setTitleColor(.darkGray, for: .normal)
            cell.button!.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0)
            cell.button!.isUserInteractionEnabled = false
            
            
            if indexPath.row == 3 {
                cell.arrowImageView?.image = #imageLiteral(resourceName: "arrow")
            }
            else {
                let state = cellStates[indexPath.row] as! Int
                if state == 1  {
                    cell.arrowImageView?.image = #imageLiteral(resourceName: "uparrow")
                }
                else {
                    cell.arrowImageView?.image = #imageLiteral(resourceName: "downarrow")
                }
            }
            
            switch indexPath.row {
            case 1:
                cell.button!.setImage(UIImage.init(named: "basic"), for: .normal)
                cell.button!.setTitle("Basic Info", for: .normal)
                
                if self.serverResponse != nil {
                    let dic2 = self.serverResponse["customer_details"] as! NSDictionary
                    
                    let text = "Phone : "+(ApplicationUtils.validateStringData(dic2["phone"]!))+"\nPAN : "+(ApplicationUtils.validateStringData(dic2["pan_number"]!))+"\nAadhar : "+(ApplicationUtils.validateStringData(dic2["aadhar_number"]!))+"\nAddress : "+(ApplicationUtils.validateStringData(self.serverResponse["current_address"]!))
                    
                    
                    cell.detailLabel?.textInsets = UIEdgeInsetsMake(-8, 15, 0, 0)
                    cell.detailLabel?.font = ApplicationUtils.getfont_REGULAR(18)
                    
                    cell.detailLabel?.setText(text, afterInheritingLabelAttributesAndConfiguringWith: { (mutableAttributedString)  -> NSMutableAttributedString? in
                        
                        mutableAttributedString?.addAttributes([kCTFontAttributeName as NSAttributedStringKey : ApplicationUtils.getfont_MEDIUM(18)], range: (text as NSString).range(of: "Phone :"))
                        
                        mutableAttributedString?.addAttributes([kCTFontAttributeName as NSAttributedStringKey : ApplicationUtils.getfont_MEDIUM(18)], range: (text as NSString).range(of: "PAN :"))
                        
                        mutableAttributedString?.addAttributes([kCTFontAttributeName as NSAttributedStringKey : ApplicationUtils.getfont_MEDIUM(18)], range: (text as NSString).range(of: "Aadhar :"))
                        
                        mutableAttributedString?.addAttributes([kCTFontAttributeName as NSAttributedStringKey : ApplicationUtils.getfont_MEDIUM(18)], range: (text as NSString).range(of: "Address :"))
                        
                        return mutableAttributedString
                    })
                }
                
            case 2:
                cell.button!.setImage(UIImage.init(named: "professional"), for: .normal)
                cell.button!.setTitle("Professional Info", for: .normal)
                
                if self.serverResponse != nil {
                    let dic2 = self.serverResponse["professional_details"] as! NSDictionary
                    
                    let text = "Company Name : "+(ApplicationUtils.validateStringData(dic2["company_name"]!))+"\nDesignation : "+(ApplicationUtils.validateStringData(dic2["designation"]!))+"\nOffice Email : "+(ApplicationUtils.validateStringData(dic2["officeEmail"]!))+"\nOffice Address : "+(ApplicationUtils.validateStringData(self.serverResponse["office_address"]!))
                    
                    
                    cell.detailLabel?.textInsets = UIEdgeInsetsMake(-8, 15, 0, 0)
                    cell.detailLabel?.font = ApplicationUtils.getfont_REGULAR(18)
                    
                    cell.detailLabel?.setText(text, afterInheritingLabelAttributesAndConfiguringWith: { (mutableAttributedString)  -> NSMutableAttributedString? in
                        
                        mutableAttributedString?.addAttributes([kCTFontAttributeName as NSAttributedStringKey : ApplicationUtils.getfont_MEDIUM(18)], range: (text as NSString).range(of: "Company Name :"))
                        
                        mutableAttributedString?.addAttributes([kCTFontAttributeName as NSAttributedStringKey : ApplicationUtils.getfont_MEDIUM(18)], range: (text as NSString).range(of: "Designation :"))
                        
                        mutableAttributedString?.addAttributes([kCTFontAttributeName as NSAttributedStringKey : ApplicationUtils.getfont_MEDIUM(18)], range: (text as NSString).range(of: "Office Email :"))
                        
                        mutableAttributedString?.addAttributes([kCTFontAttributeName as NSAttributedStringKey : ApplicationUtils.getfont_MEDIUM(18)], range: (text as NSString).range(of: "Office Address :"))
                        
                        return mutableAttributedString
                    })
                }
                
            case 3:
                cell.button!.setImage(UIImage.init(named: "doc_up"), for: .normal)
                cell.button!.setTitle("Documents", for: .normal)
                
            default:
                cell.button!.setImage(UIImage.init(named: ""), for: .normal)
                cell.button!.setTitle("", for: .normal)
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 1 || indexPath.row == 2 {
            for (index, state) in cellStates.enumerated() {
                if indexPath.row == index && state as! Int == 0 {
                    cellStates.replaceObject(at: index, with: 1)
                }
                else {
                    cellStates.replaceObject(at: index, with: 0)
                }
            }
            
            self.tableView.reloadData()
        }
        else if indexPath.row == 3
        {
            self.performSegue(withIdentifier: "DocumentsViewController", sender: nil)
        }
    }
    
    //MARK: service
    
    @objc func getProfileDetailFromServer() {
       
        let dictParam = ["mode":"getProfileDetails"]
        
        ServerCall.getServerResponse(withParameters: dictParam, withHUD: true, withHudBgView: self.view) { (response) in
            if let res = response as? String{
                ApplicationUtils.showAlert(withTitle: "", andMessage: res)
            }
            else {
                if let res = response as? NSDictionary {
                    self.serverResponse = res
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc : DocumentsViewController = segue.destination as! DocumentsViewController
        vc.userInfoDic = self.serverResponse as! [AnyHashable : Any]
    }
}
