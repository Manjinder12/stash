//
//  DocumentUploadViewController.swift
//  StashFinDemo
//
//  Created by Macbook on 05/02/19.
//  Copyright © 2019 StashFin. All rights reserved.
//


import UIKit
import Alamofire
import SDWebImage
import SwiftyJSON

class DocumentUploadModel{
    var  documentName, documentTitleName, documentId, documentImg :String
    var reset,status,isRequired:Bool
    init(documentName:String,documentTitleName:String,documentId:String,documentImg:String="",status:Bool=false,reset:Bool=false,isRequired:Bool=false) {
        self.documentName=documentName
        self.documentTitleName=documentTitleName
        self.documentId=documentId
        self.status=status
        self.reset=reset
        self.documentImg=documentImg
        self.isRequired=isRequired
    }
    
    init(uploadModel:DocumentUploadModel , isRequired: Bool=false) {
        self.documentName=uploadModel.documentName
        self.documentTitleName=uploadModel.documentTitleName
        self.documentId=uploadModel.documentId
        self.status=uploadModel.status
        self.reset=uploadModel.reset
        self.documentImg=uploadModel.documentImg
        self.isRequired=isRequired
    }
}

class documentViewTableViewCell:UITableViewCell{
    @IBOutlet weak var documentImage: UIImageView!
    @IBOutlet weak var documentName: UILabel!
    @IBOutlet weak var docIconStatus: UIImageView!
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}


class DocumentUploadViewController: BaseLoginViewController,UITableViewDataSource,UITableViewDelegate {
    //    weak var delegate:BaseViewdelagate?
    
    static func getInstance(storyboard: UIStoryboard) -> DocumentUploadViewController{
        return storyboard.instantiateViewController(withIdentifier: String(describing: self.classForCoder())) as! DocumentUploadViewController
    }
    
    
    @IBOutlet weak var tableViewHeros: UITableView!
    @IBOutlet weak var viewHeight: UIView!
    @IBOutlet weak var viewHeightConst: NSLayoutConstraint!
    
    var pageType=""
    
    
    @IBOutlet weak var nextButtonHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var nextButton: UIButton!
    
    var ovdValue:String = ""
    let successDefaultIcon = "https://lh5.googleusercontent.com/hX0gs4xnLSl3TMwXjKP_8Qt_ltDGa7Cf8az2gockJs-DNEh9f5Z-ZvUkLHY=w2400"
    var documentList=[DocumentUploadModel]()
    var otherDocumentList=[DocumentUploadModel]()
    let dropDown = DropDown()
    
    @IBAction func nextDocBtn(_ sender: UIButton) {
        var requiredDocStatus = false
        for doc in documentList{
            if doc.isRequired, doc.documentImg.isEmpty{
                requiredDocStatus = true
            }
        }
        
        if requiredDocStatus {
            showAlertDialog()
        }else{
            self.showProgress()
            let params:[String:String] = ["mode":"submitDocumentUpload"]
            
            ApiClient.getJSONResponses(route: APIRouter.v2Api(param: params)){
                result, status in
                self.hideProgress()
                switch status{
                case .success:
                    self.changeViewController(response: result)
                case .errors(let errors):
                    self.showToast(errors)
                }
            }
        }
    }
    
    private func showAlertDialog(){
        let alert = UIAlertController(title: "Document Upload!", message: "\nAll * documents are mandatory. Please upload all documents to get faster approval.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Upload Now", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Close App", style: .cancel, handler: {(_) in
            exit(0)
        }))
        
        self.present(alert, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if pageType == "profile"{
            viewHeight.isHidden = true
            let topBarHeight = UIApplication.shared.statusBarFrame.size.height +
                (self.navigationController?.navigationBar.frame.height ?? 0.0)
            viewHeightConst.constant = topBarHeight

            self.title = "Documents"
            nextButton.isHidden=true
            nextButtonHeightConstraint.constant=1
        }
        
        self.showProgress()
        let params:[String:String] = ["mode":"uploaded_document_list"]
        ApiClient.getJSONResponses(route: APIRouter.v2Api(param:params)){
            result, status in
            self.hideProgress()
            switch status {
            case .success:
                if  let json = try? JSON(data: result!){
                    if let otherDocs = json["other_selected_docs"].array{
                        for doc in otherDocs{
                            self.otherDocumentList.append(DocumentUploadModel(documentName: "other", documentTitleName: doc["document_name"].stringValue, documentId: doc["id"].stringValue,documentImg:doc["document_path"].stringValue, status: !doc["document_path"].stringValue.isEmpty, reset: doc["document_status"].stringValue=="0"))
                        }
                    }
                    
                    let bankStatementChoice = json["bank_statement_status"].intValue;
                    let gstChoice = json["gst_status"].intValue;
                    let itrChoice = json["itr_status"].intValue;
                    let permanentChoice = json["permanent_status"].intValue;
                
                    self.documentList.append(DocumentUploadModel(documentName: "pan_proof", documentTitleName: "PAN Card", documentId: "pan_proof",documentImg:json["docs"]["pan_proof"].stringValue, status: !json["docs"]["pan_proof"].stringValue.isEmpty, reset: json["docs"]["pan_status"].stringValue=="0",isRequired:true))
                    
                    self.documentList.append(DocumentUploadModel(documentName: "id_proof", documentTitleName: "Aadhaar Card Front", documentId: "id_proof", documentImg:json["docs"]["id_proof"].stringValue,status: !json["docs"]["id_proof"].stringValue.isEmpty, reset: json["docs"]["id_proof_status"].stringValue=="0",isRequired:true))
                    
                    // self.documentList.append(DocumentUploadModel(documentName: "other", documentTitleName: "Aadhaar Card Back", documentId: "other", status: docsList[i]["id_proof"].stringValue.isEmpty, reset: docsList[i]["pan_status"].stringValue=="1"))
                    
                    self.documentList.append(DocumentUploadModel(documentName: "address_proof", documentTitleName: "Current Address Proof 1", documentId: "address_proof", documentImg:json["docs"]["address_proof"].stringValue,status: !json["docs"]["address_proof"].stringValue.isEmpty, reset: json["docs"]["address_status"].stringValue=="0",isRequired:true))
                    
                   
                   
                    if bankStatementChoice == 1{ self.documentList.append(DocumentUploadModel(uploadModel: self.getDocItem(itemName:"Bank Statement"),isRequired:true))
                    }
                    
                    if permanentChoice == 1{
                        self.documentList.append(DocumentUploadModel(uploadModel: self.getDocItem(itemName:"Permanent Address"),isRequired:true))
                    }
                    
                    if itrChoice == 1{
                        
                        self.documentList.append(DocumentUploadModel(documentName: "income_tax_return", documentTitleName: "ITR 1", documentId: "income_tax_return", status: !json["docs"]["income_tax_return"].stringValue.isEmpty, reset: (json["docs"]["income_tax_return_status"].stringValue=="0"),isRequired:true))
                        
                        self.documentList.append(DocumentUploadModel(documentName: "income_tax_return2", documentTitleName: "ITR 2", documentId: "income_tax_return2", status: !json["docs"]["income_tax_return2"].stringValue.isEmpty, reset: (json["docs"]["income_tax_return2_status"].stringValue=="0"),isRequired:false))
                    }
                    
                    if gstChoice == 1{
                        self.documentList.append(DocumentUploadModel(uploadModel: self.getDocItem(itemName:"GST"),isRequired:true))
                    }
                    
                    self.documentList.append(self.getDocItem(itemName:"Officially Valid ID Proof"))
                    
                    self.documentList.append(self.getDocItem(itemName:"Current Address Proof 2"))
                    
                    self.documentList.append(self.getDocItem(itemName:"Business Address Proof"))
                    
                    self.documentList.append(DocumentUploadModel(documentName: "salary_slip1", documentTitleName: "Salary Slip 1", documentId: "salary_slip1", status: !json["docs"]["salary_slip1"].stringValue.isEmpty, reset: (json["docs"]["salary_slip1_status"].stringValue=="0"),isRequired:false))
                    
                    self.documentList.append(DocumentUploadModel(documentName: "salary_slip2", documentTitleName: "Salary Slip 2", documentId: "salary_slip2", status: !json["docs"]["salary_slip2"].stringValue.isEmpty, reset: (json["docs"]["salary_slip2_status"].stringValue=="0"),isRequired:false))
                    
                    self.documentList.append(DocumentUploadModel(documentName: "salary_slip3", documentTitleName: "Salary Slip 3", documentId: "salary_slip3", status: !json["docs"]["salary_slip3"].stringValue.isEmpty, reset: (json["docs"]["salary_slip3_status"].stringValue=="0"),isRequired:false))
                    
                    for doc in self.otherDocumentList{
                        self.documentList.append(doc)
                    }
                    
                    self.addOtherDocument()
                }
                self.tableViewHeros.reloadData()
            case .errors(let error):
                self.showToast(error)
            }
        }
    }
    
    private func addOtherDocument(){
        self.documentList.append(DocumentUploadModel(documentName: "other", documentTitleName: "Add other document", documentId: ""))
    }
    
    func getDocItem(itemName:String)->DocumentUploadModel{
        // "Officially Valid ID Proof", "Driving Licence","Passport","Voter Id Card"
        var docModel:DocumentUploadModel
        if let docPosition = self.otherDocumentList.firstIndex(where: {$0.documentTitleName == itemName}){
            docModel = otherDocumentList[docPosition]
            otherDocumentList.remove(at: docPosition)
        }else{
            docModel = DocumentUploadModel(documentName: "other", documentTitleName: itemName, documentId: "")
        }
        return docModel
    }

    // MARK: - Init
    
    // MARK: - Properties
    
    
    func openCamera(position:IndexPath,document:DocumentUploadModel){
        AttachmentHandler.shared.showAttachmentActionSheet(vc: self, title: document.documentTitleName)
        AttachmentHandler.shared.imagePickedBlock = { (image) in
            /* get your image here */
            Log("\(image) *** \(String(describing: image.pngData()?.count)) *** \(image.size)")
            self.showProgress()
            if let base:String = image.base64(format: ImageFormat.jpeg(0.6)){
                self.hideProgress()
                self.uploadDocumentApi(document:document,docString: base, uploadedImage:image,index: position)
            }else{
                self.hideProgress()
                self.showToast("Invalid image, please try again")
            }
        }
        
        AttachmentHandler.shared.filePickedBlock = {(filePath) in
            /* get your file path url here */
            Log("\(filePath)")
            let img = UIImage(named:"uploadBtn")
            self.uploadDocumentApi(document:document,docString: "params", uploadedImage: img!,index: position)
        }
    }
    
    func uploadDocumentApi(document:DocumentUploadModel,docString:String,uploadedImage:UIImage, index:IndexPath){
        let cell:documentViewTableViewCell=self.tableViewHeros.cellForRow(at: index) as! documentViewTableViewCell
        cell.documentImage.image = uploadedImage
        document.reset = true
        documentList[index.row] = document
        
        var params:[String:String]=["mode":"document_upload","document_field":document.documentName,"document_name":document.documentTitleName,"document_string":docString]
        if !document.documentId.isEmpty{
            params["other_doc_id"] = document.documentId
        }
        if  !self.ovdValue.isEmpty {
            params["ovd_id"] = self.ovdValue
        }
//
        ApiClient.getJSONResponses(route: APIRouter.v2Api(param: params)){
            result,status in
            self.hideProgress()
            switch status{
            case .success:
                print("Successfully uploaded")
                if let response = try? JSON(data: result!){
                    params=["":""]
                    self.showToast(response["message"].stringValue)
                    document.documentId = response["otherDocId"].stringValue
                    document.status = true
                    document.reset = true
                    document.documentImg = self.successDefaultIcon
                    self.documentList[index.row] = document
                    self.tableViewHeros.reloadData()
                }else{
                    self.showToast("Something went wrong, Please try again later")
                }

            case .errors(let error):
                self.showToast(error)
            }
        }
    }
    
    // MARK: - Handlers
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let doc = documentList[indexPath.row]
        if doc.documentImg.isEmpty || doc.reset{
            if doc.documentTitleName == "Officially Valid ID Proof" ||  doc.documentTitleName == "Driving Licence" ||  doc.documentTitleName == "Passport"  ||  doc.documentTitleName == "Voter Id Card"{
                openValidIdProofDialog(position: indexPath,document:doc)
            }else if doc.documentTitleName == "Add other document"{
                showSigninForm(position: indexPath,document:doc,type: "new")
            }
            else{
                openCamera(position: indexPath, document:doc)
            }
        }
        print("\(indexPath.row)")
    }
    
    // method returning size of the list
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return documentList.count
    }
    
    //method returning each cell of the list
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "cell",for:indexPath) as! documentViewTableViewCell
        let document:DocumentUploadModel
        document = documentList[indexPath.row]
        cell.documentImage.contentMode = .scaleAspectFit
        
        if document.isRequired {
            cell.documentName.text = document.documentTitleName+" * "
        }else{
            cell.documentName.text =  document.documentTitleName
        }
        
        if  !document.documentImg.isEmpty{
        cell.documentImage.sd_setImage(with: URL(string: document.documentImg), placeholderImage: UIImage(named: "gallery.png"))
            
            cell.docIconStatus.isHidden = false
            if document.reset {
                cell.docIconStatus.image = #imageLiteral(resourceName: "uploadBtn")
            }else{
                cell.docIconStatus.image = #imageLiteral(resourceName: "select")
            }
            
        }else{
            cell.documentImage.image = #imageLiteral(resourceName: "cam_icon")
            cell.docIconStatus.isHidden = true
        }
        
        if document.documentTitleName == "Add other document"{
            cell.docIconStatus.image = #imageLiteral(resourceName: "add_new_icon")
            cell.docIconStatus.isHidden = false
        }
        
        return cell
    }
    
    func openValidIdProofDialog(position:IndexPath, document:DocumentUploadModel){
        let cell:documentViewTableViewCell = tableViewHeros.cellForRow(at: position) as! documentViewTableViewCell
        dropDown.anchorView = cell
        dropDown.dataSource = ["Driving Licence","Passport","Voter Id Card"]
        dropDown.show()
        dropDown.selectionAction={(index:Int,item:String) in
            document.documentTitleName = item
            self.showSigninForm(position: position,document:document,type: "ovd")
        }
    }
    
    
    func openAddOtherDocumentDialog(position: IndexPath){
       
    }
    
    weak var actionToEnable : UIAlertAction?

    // Sign in form
    private func showSigninForm(position: IndexPath,document:DocumentUploadModel,type:String) {
        let titleStr:String
        let placeHolder:String
        if type == "new"{
            titleStr = "Add new dcoument"
            placeHolder = "Document Name"
        }else{
            titleStr = "Enter \(document.documentTitleName) number"
            placeHolder = "\(document.documentTitleName) number"
        }
        let alert = UIAlertController(title: titleStr, message: "", preferredStyle: UIAlertController.Style.alert)
        
        
        alert.addTextField(configurationHandler: {(textField: UITextField) in
            textField.placeholder = placeHolder
//            textField.borderStyle = .roundedRect
            textField.addTarget(self, action: #selector(self.textChanged), for: .editingChanged)
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { (_) -> Void in
            
        })
        
        let action = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { (_) -> Void in
            let text = alert.textFields!.first!
            if type == "new"{
                document.documentTitleName = text.text.isNilOrValue
                self.documentList[position.row] = document
                self.openCamera(position: position, document:document)
                self.addOtherDocument()
                self.tableViewHeros.reloadData()
            }else if type == "ovd" {
                self.ovdValue = text.text.isNilOrValue
                self.openCamera(position:position, document:document)
            }else{
                self.openCamera(position:position, document:document)
            }
            //Do what you want with the textfield!
        })
        
        alert.addAction(cancel)
        alert.addAction(action)
        
        self.actionToEnable = action
        action.isEnabled = false
        self.present(alert, animated: true, completion: nil)
    }
    
   @objc func textChanged(sender:UITextField) {
        self.actionToEnable?.isEnabled = (sender.text!.count > 0)
    }
}

