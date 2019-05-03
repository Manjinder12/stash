//
//  ApiRoute.swift
//  StashFinDemo
//
//  Created by Macbook on 22/01/19.
//  Copyright © 2019 StashFin. All rights reserved.
//

import Foundation
import Alamofire

enum APIRouter: URLRequestConvertible {
    
    //    case login(param:String)
    case posts
    //    case post(id: Int)
    //    case documentList(param:String)
    //    case GetLoginData(param:String)
    //    case personalRegister(param:String)
    
    case stasheasyApi(param:[String:Any])
    case androidApi(param:[String:Any])
    case v2Api(param:[String:Any])

    // MARK: - HTTPMethod
    private var method: HTTPMethod {
        switch self {
        case .posts:
            return .get
        default:
            return .post
        }
    }
    
    // MARK: - Path
    private var path: String {
        switch self {
        case .posts:
            return "/posts"
        case .androidApi:
            return Server.Urls.serviceAndroidUrl
        case .stasheasyApi:
            return Server.Urls.serviceStasheasyUrl
        case .v2Api:
            return Server.Urls.serviceV2Url
        }
    }
    
    // MARK: - Parameters
    private var parameters: String {
        var params:String = ""
         var paramString = ""
        switch self {
        case .stasheasyApi(let param),.androidApi(let param),.v2Api(let param):
             paramString = (param.compactMap({(key,value)->String in
//                if ("\(key)\(value)").count < 1000{
//                    Log(" ************ Key: \(key) -----  Value: \(value)")
//                }
                return "\(key)=\(value)"
            }) as Array).joined(separator: "&")
            params = paramString
        default:
            return ""
        }
        let checksum:String = params.hmac()
        params = params + "&checksum=\(checksum)"
        return params.replacingOccurrences(of: "+", with: "%2B")
    }
    
    // MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        let url = try Server.Urls.baseUrl.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        
        // HTTP Method
        urlRequest.httpMethod = method.rawValue
        
        // Common Headers
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
        urlRequest.setValue(ContentType.enc.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        urlRequest.setValue(SessionManger.getInstance.getAuthToken(), forHTTPHeaderField: Constants.Params.AUTH_TOKEN)
        urlRequest.setValue(Utilities.getDeviceIds(), forHTTPHeaderField:Constants.Params.DEVICE_ID )
        // Parameters
        urlRequest.httpBody=parameters.data(using: .utf8)
        
        Log("URLs: \(url.appendingPathComponent(path))")
        if parameters.count < 1000{
            Log("Parameters: \(parameters)")
        }
        Log("Headers: \(String(describing: urlRequest.allHTTPHeaderFields!))")
        
        return urlRequest
    }
}

