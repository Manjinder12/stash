//
//  WebViewViewController.swift
//  StashFinDemo
//
//  Created by Macbook on 11/04/19.
//  Copyright © 2019 StashFin. All rights reserved.
//

import UIKit
import WebKit
import SwiftyJSON

class PaymentAmountModel{
    var amount, mode, paymentCode:String?
    init(amount:String, mode:String, paymentCode:String) {
        self.amount=amount
        self.mode=mode
        self.paymentCode=paymentCode
    }
}

class WebViewViewController: BaseLoginViewController {
    
    static func getInstance(storyBoard: UIStoryboard) -> WebViewViewController{
        return storyBoard.instantiateViewController(withIdentifier: String(describing: self.classForCoder())) as! WebViewViewController
    }
    
    //left bar button item.
    private var leftBarButtonItem : UIBarButtonItem!
    
    //left button.
    private var navigationLeftButton : UIButton!
    var url = ""
    var urlType = ""
    var paymentModel: PaymentAmountModel?
    var webView: WKWebView!
    var popupWebView: WKWebView?
    var return_url = "returnToApp"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        // init and load request in webview.
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        preferences.javaScriptCanOpenWindowsAutomatically = true
        
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        
//        webView = WKWebView(frame: self.view.frame)
        webView = WKWebView(frame: self.view.frame)
        webView.navigationDelegate = self
        self.webView.uiDelegate = self
        self.webView.autoresizesSubviews = true;
        self.webView.autoresizingMask = [.flexibleHeight , .flexibleWidth];
        
        self.view.addSubview(webView)
        self.view.sendSubviewToBack(webView)
        
        switch urlType {
            
        case "chat":
            url = Server.Urls.chatUrl
            loadUrl()
            self.title = "Chat"
            self.addMenuBarButtonItem()
        case "faqs":
             url = Server.Urls.faqsUrl
            loadUrl()
            self.title = "FAQs"
            self.addMenuBarButtonItem()
        case "enach":
            loadUrl()
            self.title = "E-NACH"
            self.addMenuBarButtonItem()
        case "payment":
            checkPaymentApi()
            self.title = "Payment"
        default:
            Log("default \(urlType)")
        }
        self.webView.backgroundColor = .white
        if let popup = popupWebView{
            popup.backgroundColor = .white
        }
    }

    private func loadUrl(){
        Log("urlWebView:  \(self.url)")
        guard let urls = URL(string: self.url) else {
            self.showToast("Path is not valid")
            goToNextPage()
            return }
        //        let url = NSURL(string: urls)
        let request = NSURLRequest(url: urls as URL)
        webView.load(request as URLRequest)
        
    }
   
    private func checkPaymentApi(){
        self.showProgress()
        let params=["amount":paymentModel?.amount ?? "0","paymentCode":paymentModel?.paymentCode ?? "","flag":paymentModel?.mode ?? "","mode":"razorPayAmount"]
        ApiClient.getJSONResponses(route: APIRouter.stasheasyApi(param: params)){
            result, status in
            self.hideProgress()
            switch status{
            case .success:
                if let json = try? JSON(data: result!){
                    if let sts = json["payment_status"].string, sts == "success" {
                        self.url = json["url"].stringValue
                        self.loadUrl()
                        self.return_url = json["return_url"].stringValue
                    }
                }
            case .errors(let error):
                self.goToNextPage(msg: error)
                
            }
        }
    }
    
    func goToNextPage(msg:String=""){
        DispatchQueue.main.async {
            switch self.urlType {
            case "chat":
                self.onBackPressed()
            case "faqs":
                self.onBackPressed()
            case "enach":
                  self.getLoginDataApi()
            case "payment":
                self.showProgress()
                SessionManger.getInstance.saveLocResponse(locResponse: "")

                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5) , execute: {
                    self.hideProgress()
                    self.showHomePage()
                })
            default:
                Log("default \(self.urlType)")
            }
        }
    }
}

extension WebViewViewController: WKUIDelegate {
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        popupWebView = WKWebView(frame: view.bounds, configuration: configuration)
        
        popupWebView!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        popupWebView!.navigationDelegate = self
        popupWebView!.uiDelegate = self
        popupWebView!.backgroundColor = .white
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

extension WebViewViewController: WKNavigationDelegate {
    open func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
//        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        self.showProgress()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        self.hideProgress()
        if let url = webView.url?.absoluteString{
            if url.contains(return_url){
                self.goToNextPage()
            }
        }
    }
}
