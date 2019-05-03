//
//  BankStatementUploadViewController.swift
//  StashFinDemo
//
//  Created by Macbook on 05/02/19.
//  Copyright © 2019 StashFin. All rights reserved.
//


import UIKit
import WebKit
import SwiftyJSON

class BankStatementUploadViewController: BaseLoginViewController {
    var webView : WKWebView!
    var url = ""
    var return_url = ""
    var response:Data?
    var popupWebView: WKWebView?
    let dropDown = DropDown()
    
    //    @IBOutlet weak var webLoadScrollView: UIScrollView!
    
    @IBOutlet weak var infoIconBtn: UIButton!
    @IBOutlet weak var introBankView: UIScrollView!
    @IBOutlet weak var webLoadView: UIView!
    @IBOutlet weak var skipButton: RCButton!
    @IBOutlet weak var uploadSalariedLabel: CustomUILabel!
    @IBOutlet weak var descritionLabel: CustomUILabel!
    
    
    var salariedType:Bool = true
    let salaried="Upload your Salary Account Bank statement"
    let business="Upload your Business Bank Statement"
    let desc="""
2,50,00+ users have submitted their bank statement securely via StashFin.
    
    Via quick net banking login you will be done within 30 seconds.
    
    Perfios is a third party that automatically connects (in a very secure manner) to your financial institution keeping your perfios account automatically updated.
    
    You will be required to login to your
"""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if salariedType{
            uploadSalariedLabel.text=salaried
            descritionLabel.text="\(desc) SALARY LINKED BANK ACCOUNT for verification."
        }else{
            uploadSalariedLabel.text=business
            descritionLabel.text="\(desc) BUSINESS LINKED BANK ACCOUNT for verification."
        }
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        preferences.javaScriptCanOpenWindowsAutomatically = true
        
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        
        // init and load request in webview.
        //        webView = WKWebView(frame: self.view.frame)
        webView = WKWebView(frame: CGRect( x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - 120 ), configuration: WKWebViewConfiguration() )
        
        webView.navigationDelegate = self
        self.webView.uiDelegate = self
        self.webLoadView.addSubview(webView)
        self.webLoadView.bringSubviewToFront(infoIconBtn)
        
        //        webView.scrollView.isScrollEnabled = false
        webLoadView.isHidden = true
        introBankView.isHidden = false
        self.skipButton.isHidden = true
        self.url = "\(Server.Urls.baseUrl)\(Server.Urls.serviceV2Url)siteBankStatement?auth_token=\(SessionManger.getInstance.getAuthToken())&device_id=\(Utilities.getDeviceIds())&mode=app"
        
        infoIconBtn.isHidden=true
        self.dropDown.anchorView = infoIconBtn
        //"Having problem? Open in External browser",
        self.dropDown.dataSource = ["Reload page"]
//        dropDown.width = 200
        dropDown.selectionAction = {  (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            switch index {
            case 0:
                self.loadUrl()
//            case 1:
//                guard let url = URL(string: self.url) else { return }
//                UIApplication.shared.open(url)
//                self.webLoadView.isHidden = true
//                self.introBankView.isHidden = false
//            case 1:
//
//                self.webLoadView.isHidden = true
//                self.introBankView.isHidden = false
            default:
                Log("no handle \(index)")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        checkBankStatus()
    }
    
    private func loadUrl(){
        let urls = NSURL(string: self.url)
        let request = NSURLRequest(url: urls! as URL)
        webView.load(request as URLRequest)
        
    }
    private func checkBankStatus(){
        self.showProgress()
        let params=["mode":"bank_statement"]
        ApiClient.getJSONResponses(route: APIRouter.v2Api(param: params)){
            result, status in
            self.hideProgress()
            switch status {
            case .success:
                if let json = try? JSON(data: result!){
                    self.response=result
                    let skip = json["skip"].intValue
                    if skip > 0{
                        self.skipButton.isHidden = false
                    }
                    self.webLoadView.isHidden = true
                    self.introBankView.isHidden = false
//                    if json["status"].stringValue == "success"{
//                        if json["message"].stringValue .contains("not uploaded"){
//
//                        }else{
//                            self.openNextPage()
//                        }
//                    }
                }
            case .errors(let errors):
//                self.showToast(errors)
                Log("Bank page: \(errors)")
            }
        }
    }
    
    
    @IBAction func skipBtn(_ sender: UIButton) {
        skipDialogBox()
    }
    
    @IBAction func infoIcon(_ sender: UIButton) {
        dropDown.show()
    }
    
    @IBAction func openWebViewBankPage(_ sender: UIButton) {
        webLoadView.isHidden = false
        introBankView.isHidden = true
        loadUrl()
    }
    
    private func bankStatementSkipApi(){
        self.showProgress()
        let params=["mode":"bank_statement_skip"]
        ApiClient.getJSONResponses(route: APIRouter.v2Api(param: params)){
            result, status in
            self.hideProgress()
            switch status {
            case .success:
                if (try? JSON(data: result!)) != nil{
                    self.response=result
                    self.openNextPage()
                }
            case .errors(let errors):
                self.showToast(errors)
            }
        }
        
    }
    private func openNextPage(){
        self.changeViewController(response: response)
    }
    
    private func skipDialogBox(){
        let alert = UIAlertController(title: "Bank Statement!", message: "Bank Statement is mandatory for faster approval.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Now", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Later", style: .default, handler: {(_) in
            self.bankStatementSkipApi();
        }))
        
        self.present(alert, animated: true)
    }
    
    // MARK: - Init
    
    // MARK: - Properties
    
    // MARK: - Handlers
}


extension BankStatementUploadViewController: WKUIDelegate {
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        popupWebView = WKWebView(frame: view.bounds, configuration: configuration)
        popupWebView!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        popupWebView!.navigationDelegate = self
        popupWebView!.uiDelegate = self
        view.addSubview(popupWebView!)
        return popupWebView!
    }
    
    func webViewDidClose(_ webView: WKWebView) {
        if webView == popupWebView {
            popupWebView?.removeFromSuperview()
            popupWebView = nil
        }
    }
}

extension BankStatementUploadViewController: WKNavigationDelegate{
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        //        self.hideProgress()
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        //        self.hideProgress()
        Log("didFailProvisionalNavigation load \(webView.url!.absoluteString) \(error.localizedDescription)")
        
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
        //        self.showProgress()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        print("Strat to load \(webView.url!.absoluteString)")
        //        self.showProgress()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("finish to load \(webView.url!.absoluteString)")
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        //        self.hideProgress()
        if let url = webView.url?.absoluteString{
            if url.contains("returnToApp"){
                checkBankStatus()
            }
        }
    }
    
    
    
}
