//
//  Utilities.swift
//  StashFinDemo
//
//  Created by Macbook on 01/02/19.
//  Copyright © 2019 StashFin. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration


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
    
    static func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        /* Only Working for WIFI
         let isReachable = flags == .reachable
         let needsConnection = flags == .connectionRequired
         
         return isReachable && !needsConnection
         */
        
        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)
        
        return ret
        
    }
    
    static func isMpinActive() -> Bool{
        //        return true
        return SessionManger.getInstance.isMpinActive()  && SessionManger.getInstance.getEmail().count != 0 && SessionManger.getInstance.getNumber().count != 0
    }
    
    static func getFormattedDate(dateString: String, formatIn : String = "yyyy-MM-dd HH:mm:ss", formatOut : String = "dd-MMM-yyyy") -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatIn //this your string date format
//        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
//        dateFormatter.locale = Locale(identifier: "your_loc_id")
       
        guard dateFormatter.date(from: dateString) != nil else {
            return dateString
        }
        let convertedDate = dateFormatter.date(from: dateString)
        
        dateFormatter.dateFormat = formatOut ///this is what you want to convert format
//        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        let timeStamp = dateFormatter.string(from: convertedDate!)
        
        return timeStamp
        
    }
}


