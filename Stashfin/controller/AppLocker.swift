
//
//  AppALConstants.swift
//  AppLocker
//
//  Created by Oleg Ryasnoy on 07.07.17.
//  Copyright © 2017 Oleg Ryasnoy. All rights reserved.
//

import UIKit
import AudioToolbox
import LocalAuthentication
import Valet
import SDWebImage
import SwiftyJSON

public enum ALConstants {
    static let nibName = "AppLocker"
    static let kPincode = SessionManger.getInstance.getEmail() // Key for saving pincode to keychain
    static let kLocalizedReason = "Unlock with sensor" // Your message when sensors must be shown
    static let duration = 0.3 // Duration of indicator filling
    static let maxPinLength = 4
    
    enum button: Int {
        case delete = 1000
        case cancel = 1001
    }
}

public struct ALAppearance { // The structure used to display the controller
    public var title: String?
    public var subtitle: String?
    public var image: UIImage?
    public var color: UIColor?
    public var isSensorsEnabled: Bool?
    public init() {}
}

public enum ALMode { // Modes for AppLocker
    case validate
    case change
    case deactive
    case create
}

public class AppLocker: BaseLoginViewController,UIPopoverPresentationControllerDelegate {
    
    // MARK: - Top view
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var submessageLabel: UILabel!
    @IBOutlet var pinIndicators: [Indicator]!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var forgotMpinButton: UIButton!
    
    static let valet = Valet.valet(with: Identifier(nonEmpty: "Druidia")!, accessibility: .whenUnlockedThisDeviceOnly)
    // MARK: - Pincode
    private let context = LAContext()
    private let mPIN="mPIN"
    private var pin = "" // Entered pincode
    private var reservedPin = "" // Reserve pincode for confirm
    private var isFirstCreationStep = true
    private var savedPin: String? {
        get {
            return AppLocker.valet.string(forKey: ALConstants.kPincode)
        }
        set {
            guard let newValue = newValue else { return }
            AppLocker.valet.set(string: newValue, forKey: ALConstants.kPincode)
        }
    }
    
    fileprivate var mode: ALMode? {
        didSet {
            let mode = self.mode ?? .validate
            switch mode {
            case .create:
                submessageLabel.text = "Create your \(mPIN)" // Your submessage for create mode
            case .change:
                submessageLabel.text = "Enter your \(mPIN)" // Your submessage for change mode
            case .deactive:
                submessageLabel.text = "Enter your \(mPIN)" // Your submessage for deactive mode
            case .validate:
                submessageLabel.text = "Enter your \(mPIN)" // Your submessage for validate mode
                cancelButton.isHidden = true
                isFirstCreationStep = false
            }
        }
    }
    
    private func precreateSettings () { // Precreate settings for change mode
        mode = .create
        clearView()
    }
    
    private func drawing(isNeedClear: Bool, tag: Int? = nil) { // Fill or cancel fill for indicators
        let results = pinIndicators.filter { $0.isNeedClear == isNeedClear }
        let pinView = isNeedClear ? results.last : results.first
        pinView?.isNeedClear = !isNeedClear
        
        UIView.animate(withDuration: ALConstants.duration, animations: {
            pinView?.backgroundColor = isNeedClear ? .clear : .black
        }) { _ in
            isNeedClear ? self.pin = String(self.pin.dropLast()) : self.pincodeChecker(tag ?? 0)
        }
    }
    
    private func pincodeChecker(_ pinNumber: Int) {
        if pin.count < ALConstants.maxPinLength {
            pin.append("\(pinNumber)")
            if pin.count == ALConstants.maxPinLength {
                switch mode ?? .validate {
                case .create:
                    createModeAction()
                case .change:
                    changeModeAction()
                case .deactive:
                    deactiveModeAction()
                case .validate:
                    validateModeAction()
                }
            }
        }
    }
    
    // MARK: - Modes
    private func createModeAction() {
        if isFirstCreationStep {
            isFirstCreationStep = false
            reservedPin = pin
            clearView()
            submessageLabel.text = "Confirm your \(mPIN)"
        } else {
            confirmPin()
        }
    }
    
    private func changeModeAction() {
        pin == savedPin ? precreateSettings() : incorrectPinAnimation()
    }
    
    private func deactiveModeAction() {
        pin == savedPin ? removePin() : incorrectPinAnimation()
    }
    
    private func validateModeAction() {
        validateMpinApi(pin: pin)
    }
    
    private func removePin() {
        AppLocker.valet.removeObject(forKey: ALConstants.kPincode)
        dismiss(animated: true, completion: nil)
    }
    
    private func confirmPin() {
        if pin == reservedPin {
            updateMpinApi(pin: pin)
        } else {
            incorrectPinAnimation()
        }
    }
    
    private func incorrectPinAnimation() {
        pinIndicators.forEach { view in
            view.shake(delegate: self)
            view.backgroundColor = .clear
        }
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
    
    fileprivate func clearView() {
        pin = ""
        pinIndicators.forEach { view in
            view.isNeedClear = false
            UIView.animate(withDuration: ALConstants.duration, animations: {
                view.backgroundColor = .clear
            })
        }
    }
    
    // MARK: - Touch ID / Face ID
    fileprivate func checkSensors() {
        guard mode == .validate else {return}
        
        var policy: LAPolicy = .deviceOwnerAuthenticationWithBiometrics // iOS 8+ users with Biometric and Custom (Fallback button) verification
        
        // Depending the iOS version we'll need to choose the policy we are able to use
        if #available(iOS 9.0, *) {
            // iOS 9+ users with Biometric and Passcode verification
            policy = .deviceOwnerAuthentication
        }
        
        var err: NSError?
        // Check if the user is able to use the policy we've selected previously
        guard context.canEvaluatePolicy(policy, error: &err) else {return}
        
        // The user is able to use his/her Touch ID / Face ID 👍
        context.evaluatePolicy(policy, localizedReason: ALConstants.kLocalizedReason, reply: {  success, error in
            if success {
                self.dismiss(animated: true, completion: nil)
            }
        })
    }
    
    @IBAction func forgotMpinBtn(_ sender: UIButton) {
        
        checkMobileNumberDialog()
    }
    
    private func checkMobileNumberDialog(){
        let alert = UIAlertController(title: "Forgot \(mPIN)!", message: "\nPlease enter your registered mobile number", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Mobile number"
            textField.keyboardType = .numberPad
        })
        
        alert.addAction(UIAlertAction(title: "Submit", style: .default, handler: { action in
            
            if let number = alert.textFields?.first?.text {
                //                print("Your name: \(name)")
                if SessionManger.getInstance.getNumber() == number{
                    self.sendOtp(phone:number)
                }else{
                    self.showToast("Invalid registered mobile number.")
                }
                
            }
        }))
        
        self.present(alert, animated: true)
    }
    
    
    private func sendOtp(phone:String){
        let param:[String:String] = ["phone":phone, "mode":"generate_otp"]
        self.showProgress()
        ApiClient.getJSONResponses(route: APIRouter.v2Api(param: param)){
            result, code in
            self.hideProgress()
            switch code{
            case .success:
                self.showToast("OTP sent!")
                self.verifyOtpDialog(phone: phone)
            case .errors(let error):
                self.showToast(error)
            }
        }
    }
    
    private func verifyOtpDialog(phone :String){
        let alert = UIAlertController(title: "Forgot \(mPIN)!", message: "\nWe sent an OTP to your registered mobile number", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "OTP"
            textField.keyboardType = .numberPad
            textField.isSecureTextEntry.toggle()
        })
        
        alert.addAction(UIAlertAction(title: "Verify", style: .default, handler: { action in
            if let otp = alert.textFields?.first?.text {
                self.verifyNumberApi(otp: otp,number: phone)
            }
        }))
        
        self.present(alert, animated: true)
    }
    
    private func verifyNumberApi(otp:String,number:String){
        let   param = ["phone":number,"otp":otp,"mode":"login","source":Constants.Values.ios,"device_id":Utilities.getDeviceIds(),"status":"1"]
        
        self.showProgress()
        ApiClient.getJSONResponses(route: APIRouter.v2Api(param: param)){
            result,code in
            self.hideProgress()
            switch code{
            case .success:
                print("result....\(String(describing: result!))");
                if let response = try? JSON(data: result!){
                    
                    SessionManger.getInstance.clearAllData()
                    
                    let authToken = response["auth_token"].stringValue
                    SessionManger.getInstance.saveAuthToken(token: authToken)
                }
                self.dismiss(animated: true, completion: nil)
                self.pin(.create)
            case .errors(let error):
                self.showToast(error)
            }
        }
    }
    
    @IBAction func settingIconBtn(_ sender: UIButton) {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let loginAction = UIAlertAction(title: "Login", style: .destructive, handler: { (alert: UIAlertAction!) -> Void in
            AppDelegate.shared.rootViewController.showLoginScreen(mpinStatus:false)
            self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        })
        
        let contactUsAction = UIAlertAction(title: "Contact Us", style: .default, handler: { (alert: UIAlertAction!) -> Void in
            
            guard let url = URL(string: "https://www.stashfin.com/contact-us") else {
                return
            }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        })
        
        let faqsAction = UIAlertAction(title: "FAQs", style: .default, handler: { (alert: UIAlertAction!) -> Void in
            
            guard let url = URL(string: "https://www.stashfin.com/faqs") else {
                return
            }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (alert: UIAlertAction!) -> Void in
            //  Do something here upon cancellation.
            
        })
        
        alertController.addAction(loginAction)
        alertController.addAction(contactUsAction)
        alertController.addAction(faqsAction)
        alertController.addAction(cancelAction)
        
        if let popoverController = alertController.popoverPresentationController {
            //            popoverController.barButtonItem = sender
            popoverController.sourceView = sender
            popoverController.sourceRect = CGRect(x: sender.bounds.midX, y: sender.bounds.midY, width: 0, height: 0)
            
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    // MARK: - Keyboard
    @IBAction func keyboardPressed(_ sender: UIButton) {
        switch sender.tag {
        case ALConstants.button.delete.rawValue:
            drawing(isNeedClear: true)
        case ALConstants.button.cancel.rawValue:
            clearView()
            dismiss(animated: true, completion: nil)
        default:
            drawing(isNeedClear: false, tag: sender.tag)
        }
    }
    
}

// MARK: - CAAnimationDelegate
extension AppLocker: CAAnimationDelegate {
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        clearView()
    }
}

// MARK: - Present
public extension AppLocker {
    // Present AppLocker
    class func present(with mode: ALMode, and config: ALAppearance? = nil) {
        guard let root = UIApplication.shared.keyWindow?.rootViewController,
            
            let locker = Bundle(for: self.classForCoder()).loadNibNamed(ALConstants.nibName, owner: self, options: nil)?.first as? AppLocker else {
                Log("error in applocker open page returned")
                return
        }
        //        let root
        //        ********
        //            let locker = AppLocker(nibName: ALConstants.nibName, bundle: nil)
        
        locker.messageLabel.text = config?.title ?? ""
        locker.submessageLabel.text = config?.subtitle ?? ""
        locker.view.backgroundColor = config?.color ?? Colors.white
        locker.mode = mode
        
        if config?.isSensorsEnabled ?? false {
            locker.checkSensors()
        }
        
        //    if let image = config?.image {
        //      locker.photoImageView.image = image
        if let url = URL(string: SessionManger.getInstance.getProfilePic()) {
            
            locker.photoImageView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "app_lock_icon") ,options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
                if let img = image{
                    locker.photoImageView.maskCircle(anyImage: img,number: 3)
                }
            })
            
        }else{
            //            locker.photoImageView.image =  #imageLiteral(resourceName: "app_icon_round")
            locker.photoImageView.maskCircle(anyImage: #imageLiteral(resourceName: "app_lock_icon"),number: 3)
        }
        
        //    } else {
        //      locker.photoImageView.isHidden = true
        //    }
        
        DispatchQueue.main.async {
            //            getTopMostViewController()?.present(alertController, animated: true, completion: nil)
            
            root.present(locker,animated: true,completion: nil)
            //            self.goToNextViewController(self.locker)
            
        }
    }
    
    private func updateMpinApi(pin:String){
        //        change_mpin  -change
        //        validate_mpin -verify
        //        change_mpinstatus -disable
        //        mpin_status  -status
        
        //        mpin - key
        let mPin = "\(SessionManger.getInstance.getEmail())\(pin)\(SessionManger.getInstance.getNumber())"
        let mpinEnc=mPin.sha1()
        let param:[String:String] = ["mpin":mpinEnc, "mode":"set_mpin"]
        self.showProgress()
        ApiClient.getJSONResponses(route: APIRouter.stasheasyApi(param: param)){
            result, code in
            self.hideProgress()
            switch code{
            case .success:
                //                if let json = try? JSON(data: result!){
                self.savedPin = pin
                SessionManger.getInstance.setMpinActive(status: true)
                
                DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                    let alert = UIAlertController.init(title: "mPIN", message: "\nmPIN activated successfully, verify mPIN to continue", preferredStyle: .alert)
                    alert.addAction(UIAlertAction.init(title: "Verify", style: .default, handler: {(_) -> Void in
                        
                        self.dismiss(animated: false, completion: nil)
                        self.pin(.validate)
                        
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
                
                //                }
                
            case .errors(let error):
                self.showToast(error)
                self.clearView()
            }
        }
    }
    
    private func validateMpinApi(pin:String){
        
        //          pin == savedPin ? dismiss(animated: true, completion: nil) :
        let mPin = "\(SessionManger.getInstance.getEmail())\(pin)\(SessionManger.getInstance.getNumber())"
        let mpinEnc=mPin.sha1()
        Log("pin \(mPin)  ****   \(mpinEnc)")
        let param:[String:String] = ["mpin":mpinEnc, "mode":"validate_mpin","device_type":Constants.Values.ios,"email":SessionManger.getInstance.getEmail(),"device_id":Utilities.getDeviceIds()]
        self.showProgress()
        ApiClient.getJSONResponses(route: APIRouter.v2Api(param: param)){
            result,code in
            self.hideProgress()
            self.clearView()
            switch code{
            case .success:
                
                self.savedPin = mpinEnc
                SessionManger.getInstance.setMpinActive(status: true)
                self.parseResonse(result: result)
                
            case .errors(let error):
                Log(error)
                self.forgotMpinButton.isHidden=false
                if error.contains("disable"){
                    SessionManger.getInstance.setMpinActive(status: false)
                    SessionManger.getInstance.saveEmail(email: "")
                    SessionManger.getInstance.clearAllData()
                    self.showToast("Session expired, please login to continue")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                        AppDelegate.shared.rootViewController.showLoginScreen(mpinStatus:false)
                        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
                    }
                }else{
                    self.incorrectPinAnimation()
                }
            }
        }
    }
    
    //    private func showLoader(status:Bool){
    //        if status{
    //            pinIndicators.forEach { view in
    //                view.shake(delegate: self)
    //                view.backgroundColor = .clear
    //            }
    //        }else{
    //            clearView()
    //        }
    //
    //    }
}
