//
//  ApiClient.swift
//  StashFinDemo
//
//  Created by Macbook on 22/01/19.
//  Copyright © 2019 StashFin. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import SystemConfiguration
import UIKit

//struct Connectivity {
//    static let sharedInstance = NetworkReachabilityManager()!
//    static var isConnectedToInternet:Bool {
//        return self.sharedInstance.isReachable
//    }
//}

public enum ApiHandler {
    case success
    case errors(error:String)
}


public class ApiClient{
    
    //    @discardableResult
    //    private static func performRequest<T:Decodable>(route:APIRouter,
    //                                                    decoder: JSONDecoder = JSONDecoder(),
    //                                                    completion:@escaping (Result<T>,_ statusCode:Int)->Void
    //        ) -> DataRequest {
    //        //        -> DataRequest
    //        return  AF.request(route)
    //            .responseDecodable (decoder: decoder){ (response: DataResponse<T>) in
    //                print(response.response);
    //                print(response.result.value);
    //                let encoder = JSONEncoder()
    //                encoder.outputFormatting = .prettyPrinted; completion(response.result,response.response?.statusCode ?? 500)
    //        }
    //    }
    //
    //
    //    static func login(email: String, password: String, completion:@escaping (Result<LoginResponseModel>,_:Int)->Void) {
    //        performRequest(route: APIRouter.login(email: email, password: password), completion: completion)
    //    }
    //
    
    //    static func logins(param: String, completionHandler: @escaping (_ response: Any?,_ status: ApiHandler)->Void) {
    //        getJSONResponses(route: APIRouter.login(param: param), completionHandler: completionHandler)
    //    }
    //
    //    static func document_list(completionHandler: @escaping (_ response: Any?, _ status: ApiHandler)->Void){
    //        getJSONResponses(route: APIRouter.documentList, completionHandler: completionHandler)
    //    }
    //
    //    static func getLoginData(completionHandler: @escaping (_ response: Any?, _ status :ApiHandler)->Void){
    //        getJSONResponses(route: APIRouter.GetLoginData, completionHandler: completionHandler)
    //    }
    
//    var vc:UIViewController?
//    init(vc:UIViewController) {
//        self.vc=vc
//    }
    
    static func getStateList(completionHandler: @escaping(_ response: Data?, _ status: ApiHandler)->Void){
        let params:[String:String] = ["mode":"getStates"]
        getJSONResponses(route: APIRouter.stasheasyApi(param: params), completionHandler: completionHandler)
        
    }
    
    static func getCityList(_ state_id:Int,completionHandler: @escaping(_ response: Data?, _ status: ApiHandler)->Void){
        let params:[String:String] = ["mode":"getCities","state_id":"\(state_id)"]
        getJSONResponses(route: APIRouter.stasheasyApi(param: params), completionHandler: completionHandler)
        
    }
    
    static func getCardData(completionHandler: @escaping(_ response: Data?, _ status: ApiHandler)->Void){
        let params=["mode":"cardOverview"]
        getJSONResponses(route: APIRouter.stasheasyApi(param: params)){
            result, status in
            switch status{
            case .success:
                if let json = try? JSON(data: result!).rawString(){
                    guard let value = json else{
                        return
                    }
                    SessionManger.getInstance.saveCardResponse(cardResponse: value)
                }
                completionHandler(nil,.success)
            case .errors(let errors):
                Log(errors)
                SessionManger.getInstance.saveCardResponse(cardResponse: "No card found")
                completionHandler(nil,.errors(error: ""))
            }
        }
    }
    
    static func getLoginData(completionHandler: @escaping(_ response: Data?, _ status: ApiHandler)->Void){
        let params:[String:String] = ["mode":"getLoginData"]
        getJSONResponses(route: APIRouter.v2Api(param: params),completionHandler:completionHandler)
    }
    
    static func updateAppDetails(completionHandler: @escaping(_ response: Data?, _ status: ApiHandler)->Void){
      
        let appVersion = Utilities.getAppInfo()
       
        let device = UIDevice.current

        let model = device.model
        Log(model) // e.g. "iPhone"
        
        let modelName = Utilities.getModelName()
        Log(modelName) // e.g. "iPhone 6"  /* see the extension */
        
        let deviceName = device.name
        Log(deviceName) // e.g. "My iPhone"
        
        let systemName = device.systemName
        Log(systemName) // e.g. "iOS"
        
        let systemVersion = device.systemVersion
        Log(systemVersion) // e.g. "10.3.2"
        
        if let identifierForVendor = device.identifierForVendor {
            
            print(identifierForVendor) // e.g. "E1X2XX34-5X6X-7890-123X-XXX456C78901"
        }
        
        Log("App version: \(appVersion)")
        let params=["mode":"uploadDeviceInfo","manufacture":"Apple","app_version":appVersion,"osVersion":systemVersion,"brand":model,"model":modelName,"device_id":Utilities.getDeviceIds(),"device":model]
//
        getJSONResponses(route: APIRouter.stasheasyApi(param: params), completionHandler: completionHandler)

    }
    
    //
    //    static func registerPersonalApi(name:String,mobile:String,city:String,completionghandler: @escaping (_ response:Any?, _ status:ApiHandler)->Void){
    //        getJSONResponses(route: APIRouter.GetLoginData, completionHandler: completionghandler)
    //    }
    
    static func getJSONResponses(route:APIRouter,
                                 completionHandler: @escaping (_ responses: Data?,_ status: ApiHandler) -> Void) {
       
        guard  Reachability.isConnectedToNetwork() else {
            print("Internet Connection not Available!")
            return
                completionHandler(nil,.errors(error: Constants.Values.network_error))
        }
        
        AF.request(route)
            .debugLog()
            .response { response in
                switch(response.result) {
                case .success(_):
                    guard response.result.value != nil else{
                        print("nil api")
                        completionHandler(nil,.errors(error: "\(Constants.Values.server_error)\nerror_code: 111"))
                        return
                    }
                    
//                    Log.servers("Body: \(String(describing: String(data: (response.request?.httpBody)!, encoding: .utf8)))")
                    
                    if let data = response.data, let dataResponse = String(data: data, encoding: .utf8){
                        Log("Response:..code: \(String(describing: response.response?.statusCode))...response: \(dataResponse)")
                        
                        switch response.response?.statusCode{
                        case 200:
                            if let dataFromString = dataResponse.data(using: .utf8, allowLossyConversion: false) {
                                completionHandler(dataFromString, .success)
                            }else{
                                completionHandler(nil,.errors(error: "\(Constants.Values.server_error)\nerror_code: 112"))
                            }
                            
                        default:
                            print("default error...\(dataResponse)")
                            var error:String="Something went wrong"
                                if let json = try? JSON(data: data){
                                    error = json["message"].stringValue
                                    if error.isEmpty{
                                        error = json["error"].stringValue
                                    }
                            }
                            if error == "Login Expired"{
                               error = "Session expired!, Please login again to continue."
                                SessionManger.getInstance.saveAuthToken(token: "")
//                                let storyBoardRegister:UIStoryboard = UIStoryboard(name: "RegistrationNew", bundle: nil)
//                                let storyBoardController = storyBoardRegister.instantiateViewController(withIdentifier: "BasicViewController") as! PersonalViewController
//                                DispatchQueue.main.async {
//                                    vc.present(storyBoardController,animated: false,completion: nil)
//                                }
                            }
                            completionHandler(nil,.errors(error: error))
                            
                        }
                    }
                case .failure(_):
                    print("Error message:\(String(describing: response.result.error))")
                    completionHandler(nil, .errors(error: "\(Constants.Values.server_error)\nerror_code: 113"))
                    break
                }
        }
    }
    
    
    
   static func get(path: String, params: [String:Any]?,
             completion: @escaping ((_ jsonResponse: Data?, _ responseStatus: ApiHandler) -> Void)) {
   
    let headers:HTTPHeaders = [
        HTTPHeaderField.contentType.rawValue: ContentType.enc.rawValue,
        Constants.Params.DEVICE_ID: Utilities.getDeviceIds(),
       Constants.Params.AUTH_TOKEN:SessionManger.getInstance.getAuthToken()
    ]
    

    AF.request(path,method:.get, parameters: params, headers: headers).response { response in
//        Log(String(data:response.result.value as! Data, encoding: .utf8)!)
                if let json = response.result.value {
                    Log("response:__   \(String(describing: json))")
                    completion(json, .success)
                } else {
                    completion(nil, .errors(error: response.result.error?.localizedDescription ?? "error"))
                }
            }
    }
    
    
    
    public class Reachability {
        
        class func isConnectedToNetwork() -> Bool {
            
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
    }
}
