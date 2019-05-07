//
//  SignatureViewController.swift
//  StashFinDemo
//
//  Created by Macbook on 05/02/19.
//  Copyright © 2019 StashFin. All rights reserved.
//


import UIKit
import SDWebImage
import SwiftyGif
import CropViewController

class SignatureViewController: BaseLoginViewController, UIScrollViewDelegate, CropViewControllerDelegate{
    
    static func getInstance(storyboard: UIStoryboard) -> SignatureViewController{
        return storyboard.instantiateViewController(withIdentifier: String(describing: self.classForCoder())) as! SignatureViewController
    }
    
    @IBOutlet weak var pageController: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    var timer:Timer!
    
    var slides:[SignatureIntroView] = [];
    private let imageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate=self
        
        slides = createSlides()
        setupSlideScrollView(slides: slides)
        
        pageController.numberOfPages = slides.count
        pageController.currentPage = 0
        view.bringSubviewToFront(pageController)
        
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: true)
        
        
    }
    // MARK: - Init
    @objc private func runTimedCode(){
        
        if pageController.currentPage < slides.count-1{
            
            let width: CGFloat = scrollView.frame.size.width
            let newPosition: CGFloat = scrollView.contentOffset.x + width
            //        let currentHorizontalOffset: CGFloat = scrollView.contentOffset.x
            scrollView.setContentOffset(CGPoint(x: newPosition, y: 0), animated: true)
            
        }else{
            timer.invalidate()
        }
    }
  
    
    // MARK: - Properties
    
    @IBAction func signBtn(_ sender: UIButton) {
        if SessionManger.getInstance.isTester(){
            self.changeViewController(controllerName: Constants.Controllers.LOGIN)
        }else{
            submitDetails()
        }
    }
    
    private func submitDetails(){
        openCamera( )
      
    }
    
    func openCamera(){
        AttachmentHandler.shared.showAttachmentActionSheet(vc: self, title: "Signature")
        AttachmentHandler.shared.imagePickedBlock = { (image) in
//            self.showProgress()
            
//            if let base:String = image.base64(format: ImageFormat.jpeg(0.5)){
//                Log("base count *** \(base.count)")
//                //                self.hideProgress()
//                self.uploadSignatureApi(docString: base)
//            }else{
//                //                self.hideProgress()
//                self.showToast("Invalid image, please try again")
//            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1) , execute: {
                let cropViewController = CropViewController(image: image)
                cropViewController.title = "Crop Signature"
                cropViewController.delegate = self
                self.present(cropViewController, animated: true, completion: nil)
            })
        }
    }
    
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        // 'image' is the newly cropped version of the original image
        if let base:String = image.base64(format: ImageFormat.jpeg(0.5)){
            Log("base count *** \(base.count)")
            //                self.hideProgress()
            self.uploadSignatureApi(docString: base)
        }else{
            //                self.hideProgress()
            self.showToast("Invalid image, please try again")
        }
        cropViewController.dismiss(animated: true, completion: nil)

    }
    
    private func uploadSignatureApi(docString:String){
        var params:[String:String]=["mode":"uploadCustomerSignature","image":docString,"image_progess":"70"]
        self.showProgress()
        ApiClient.getJSONResponses(route: APIRouter.stasheasyApi(param: params)){
            result,status in
            self.hideProgress()
            switch status{
            case .success:
                params=["":""]
                print("Successfully uploaded")
                //                 self.changeViewController(response: result)
                self.getLoginDataApi()
            case .errors(let error):
                self.showToast(error)
                
            }
        }
    }
    
    
    // MARK: - Handlers
    
    func setupSlideScrollView(slides : [SignatureIntroView]) {
        scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(slides.count), height: 0)
        
        scrollView.isPagingEnabled = true
        
        for i in 0 ..< slides.count {
            slides[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: view.frame.height)
            scrollView.addSubview(slides[i])
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
        pageController.currentPage = Int(pageIndex)
        
    }
    
    
    func createSlides() -> [SignatureIntroView] {
        let gifManager = SwiftyGifManager(memoryLimit:100)
        let gif = UIImage(gifName: "sign")
        
        let slide1:SignatureIntroView = Bundle.main.loadNibNamed("SignatureIntroView", owner: self, options: nil)?.first as! SignatureIntroView
        
        slide1.introIcon.image = UIImage(named: "signature_1")
        slide1.label.text = "Signature"
        slide1.introDesc.text = "Please sign on a blank white paper. Your signature should match with the signature hat you have submitted on your banking documents."
        
        let slide2:SignatureIntroView = Bundle.main.loadNibNamed("SignatureIntroView", owner: self, options: nil)?.first as! SignatureIntroView
        
        //        slide2.introIcon.setGifImage(gif, manager: gifManager, loopCount: -1)
        slide2.introIcon.image = UIImage(named: "signature_2")
        slide2.label.text = "Click Photo"
        slide2.introDesc.text = "Capture the signature clearly with your phone camera"
        
        let slide3:SignatureIntroView = Bundle.main.loadNibNamed("SignatureIntroView", owner: self, options: nil)?.first as! SignatureIntroView
        slide3.introIcon.image = UIImage(named: "signature_3")
        slide3.label.text = "Upload Photo"
        slide3.introDesc.text = "Crop and adjust image of signature before uploading"
        
        let slide4:SignatureIntroView = Bundle.main.loadNibNamed("SignatureIntroView", owner: self, options: nil)?.first as! SignatureIntroView
        slide4.introIcon.setGifImage(gif, manager: gifManager, loopCount: -1)
        slide4.label.text = "Signature"
        slide4.introDesc.text = "I verify the information I have entered and agree that my signature will be used on these documents."
        
        return [slide1, slide2, slide3, slide4]
    }
}

extension UIApplication {
    class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}
