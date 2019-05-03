//
//  Utilities.swift
//  StashFinDemo
//
//  Created by Macbook on 01/02/19.
//  Copyright © 2019 StashFin. All rights reserved.
//

import Foundation
import UIKit


class Utilities {
    func isEmptyCheck(value:String)->Bool{
        return (value.isEmpty)
    }
    
//    static func getCurrentViewController(controller: UIViewController, storyBoard: String) -> UIViewController{
//        let storyboard = UIStoryboard(name:  storyBoard, bundle: nil)
//        return storyboard.instantiateInitialViewController() as? controller
//    }
    
//    static func pushCurrentViewController(controller:UIViewController, storyBoard:String){
//        let storyboard = UIStoryboard(name:  storyBoard, bundle: nil)
//        let statusViewController = storyBoardMain.instantiateViewController(withIdentifier: "LoadMyCardSlideViewController") as! LoadMyCardSlideViewController
//        if let navigator = navigationController {
//            navigator.pushViewController(statusViewController, animated: true)
//        }
//    }
//
    
    static  func displayTheAlert(targetVC: UIViewController, title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction((UIAlertAction(title: "OK", style: .default, handler: {(action) -> Void in
        })))
        targetVC.present(alert, animated: true, completion: nil)
    }
    
    static func getDeviceIds()-> String{
        return UIDevice.current.identifierForVendor?.uuidString ?? "nil"
    }
    
    static func isEmailValid(email:String) -> Bool {
        do {
            if try NSRegularExpression(pattern: "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$", options: .caseInsensitive).firstMatch(in: email, options: [], range: NSRange(location: 0, length: email.count)) == nil {
                return false
            }
        } catch {
            return false
        }
        return true
    }
    
    static func isPhoneNumberValid(value: String) -> Bool {
            var returnValue = true
            //        let mobileRegEx = "^[789][0-9]{9,11}$"
            let mobileRegEx = "^[0-9]{10}$"
            
            do {
                let regex = try NSRegularExpression(pattern: mobileRegEx)
                let nsString = value as NSString
                let results = regex.matches(in: value, range: NSRange(location: 0, length: nsString.length))
                
                if results.count == 0
                {
                    returnValue = false
                }
                
            } catch let error as NSError {
                print("invalid regex: \(error.localizedDescription)")
                returnValue = false
            }
            
            return  returnValue
        }
    
    
    static func getAppInfo()->String {
        let dictionary = Bundle.main.infoDictionary!
        let version = dictionary["CFBundleShortVersionString"] as! String
        let build = dictionary["CFBundleVersion"] as! String
        return version + "(" + build + ")"
    }
    
    static func getAppName()->String {
        if let appName:String = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String {
        return appName
        
        }
        return ""
    }
    
    static func getModelName()->String {
        if let modelName = ProcessInfo.processInfo.environment["SIMULATOR_MODEL_IDENTIFIER"] { return modelName }
        var info = utsname()
        uname(&info)
        return String(String.UnicodeScalarView(
            Mirror(reflecting: info.machine)
                .children
                .compactMap {
                    guard let value = $0.value as? Int8 else { return nil }
                    let unicode = UnicodeScalar(UInt8(value))
                    return unicode.isASCII ? unicode : nil
        }))
    }
        static func getOSInfo()->String {
        let os = ProcessInfo().operatingSystemVersion
        return String(os.majorVersion) + "." + String(os.minorVersion) + "." + String(os.patchVersion)
    }
}


