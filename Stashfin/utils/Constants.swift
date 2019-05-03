//
//  Constants.swift
//  StashFinDemo
//
//  Created by Macbook on 22/01/19.
//  Copyright © 2019 StashFin. All rights reserved.
//

import Foundation
import UIKit

struct Server {
    // MARK: baseUrl
    struct Urls {
        // 192.168.60.149
//        static let baseUrl="https://devapi.stasheasy.com/"//dev
//        static let baseUrl="http://devapi.stashfin.com/"//dev
//        static let baseUrl="http://192.168.60.149/stashfin_app_v2_20-02-2019/"//dev
        static let baseUrl="https://api.stashfin.com/"//live
        static let serviceAndroidUrl="StashfinApp/android/"
        static let serviceStasheasyUrl="WebServicesMobile/StasheasyApp/"
        static let serviceV2Url="v2/api/"
        static let chatUrl="https://tawk.to/chat/5b20baa307752b51e61462c2/default/?$_tawk_popout=true"
        static let faqsUrl="https://www.stashfin.com/faqs"

    }
    
    struct ApiParameterKey {
        static let password="password"
        static let email="email"
        static let otp="otp"
        static let number="number"
        static let device_id="device_id"
        static let device_type="device_type"
        static let mode="mode"
        static let checksum="checksum"
        static let appVersion="AppVersion"
        static let login="login"
    }
}
enum HTTPHeaderField:String{
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
}

enum ContentType:String{
    case json="application/json"
    case enc = "application/x-www-form-urlencoded"
}

enum AttachmentType: String{
    case camera, video, photoLibrary
}

enum Constants {
    
    enum Params {
        static let email="email"
        static let phone="phone"
        static let password="password"
        static let AUTH_TOKEN="auth_token"
        static let DEVICE_ID="device_id"
    }
    
    enum ApplicationStatus{
        static let START = "start"
        static let APPROVED = "approved"
        static let DOCPICK = "docpick"
        static let DOCPICKDONE = "docpickdone"
        static let DISBURSED = "disbursed"
        static let REJECTED = "rejected"
        static let CLOSED = "closed"
    }
    
    enum Modes {
        static let mode="mode"
        static let login="login"
        static let getLoginData = "getLoginData"
        static let documents = "documents"
        //MARK: registraion modes
        static let SEND_OTP_REGISTRATION = "sendOTPBeforeRegistration"
        static let VERIFY_OTP_REGISTRATION = "verifyOTPBeforeRegistration"
        static let REGISTER = "register"

        //register
        static let personalRegister="personal"
    }
    
    enum Values{
        static let RupeeSign="\u{20B9} "
        static let device_type="device_type"
        static let ios="ios"
        static let device_id="device_id"
        static let server_error="Could not reach server"
        static let something_went_wrong="Something went wrong"
        static let network_error="Internet Connection not Available!"
    }
    
    enum Key {
        static let LANDING_PAGE="landing_page"
        static let AUTH_TOKEN="auth_token"
    }
    
    enum StoryBoard {
        static let MAIN = "Main"
        static let REGISTER = "RegistrationNew"
    }
    
    enum SavedKeys:String {
        case token="token"
        case CUSTOMER_ID="customer_id"
        case applicationStatus="applicationStatus"
        case loanStatus="loanStatus"
        case cardStatus="cardStatus"
        case UserName="UserName"
        case UserLogin="UserLogin"
        case DEVICE_SAVED="DeviceSaved"
        case UserPass="UserPass"
        case CardResponse="CardResponse"
        case LocResponse="LocResponse"
        case PROFILE_PIC="profile_pic"
        case NAME="name"
        case EMAIL="email"
        case CardRequest="CardRequest"
        case REGISTRATION_PAGE = "registration_pages"
    }
    
    enum Controllers {
        //        static let login="login"
                static let main="main"
        //        static let personal="personal"
        //        static let basic="basic"
        //        static let professional="professional"
        //        static let document="docment"
        //        static let thankyou="thankyou"
        //        static let pre_approved="pre_approved"
        //        static let congratulation="congratulation"
        //        static let bank="bank"
        //        static let reject="reject"
        //        static let pickup="pickup"
        //        static let approved="approved"
        //        static let enach="enach"
        //        static let complete="complete"
        
        enum SegueController:String {
            case Personal = "personal"
            case Basic = "basic"
            case Bank = "bank"
            case Enach = "enach"
            case document = "document"
        }
        
        static let LOGIN = "login"
        static let DASHBOARD = "profile"
        static let PROFILE_PAGE = "profile_page"
        static let PROFESSIONAL_INFO = "professional"
        static let UPLOAD_DOCUMENT = "document"
        static let REGISTER_MOBILE = "mobile"
        static let BASIC_INFO = "basic"
        static let BANK_PAGE = "bank"
        static let COMPLETE_REGISTRATION = "completed"
        static let UPLOAD_SIGNATURE = "signature"
        static let NO_PAGE = "no"
        static let CONGRATULATION = "congratulation"
        static let PRE_APPROVED = "preApproved"
        static let ENACH = "enach"
        static let PERSONAL = "personal"
        static let REGISTER = "register"

        static let PROFESSIONAL = "professional"
        static let DOCUMENT = "document"
        static let BASIC = "basic"
        static let BANK = "bank"
        static let EL_FORM = "EL_FORM"
        static let EL_DOC = "EL_DOCUMENT"
        static let EL_DOC_REJECT = "EL_DOCUMENT_REJECT"
        static let EL_BANK = "EL_BANK"
        static let EL_SCAN = "EL_SCAN"
        static let EL_APPROVE = "EL_APPROVED"
        static let EL_SUBMITTED = "EL_SUBMITTED"
        static let EL_HOME = "EL_HOME"
        static let EL_DEBIT = "EL_DEBIT"
        static let EL_ADDRESS_ERROR = "EL_ADDRESS_ERROR"

        //new registration flow
        static let PROFESSIONAL_ABOVE_SALARY = "professional_m40k" // for above 40k salary and salaried mode
        static let PROFESSIONAL_BELOW_SALARY = "professional_l40k" // for below 40k salary and salaried mode
        static let PROFESSIONAL_BUSINESS = "business" // for business
        static let BANK_STATEMENT_SALARY = "bankstatement_salary" // for salary bank statement
        static let BANK_STATEMENT_BUSINESS = "bankstatement_business" // for salary bank statement
        static let DOCUMENTS_SALARY = "documents_salary" // for salary document
        static let DOCUMENTS_BUSINESS = "documents_business" // for business document
        static let THANK_YOU = "thankyou"
        static let REJECT = "reject"
        static let ELEVATE = "elevate"
        static let REGISTRATION = "registration"
        static let REGISTRATION_LOGIN = "registration_login"
        static let PICKUP = "pickup"
        static let SIGNATURE = "signature"
        static let APPROVED = "approved"
        static let BANK_DETAILS_BUSINESS = "bankdetails_business"
        static let BANK_DETAILS_SALARY = "bankdetails_salary"
        static let ENACH_WEBVIEW = "enach_webview"
        static let NO_LANDING_PAGE = "no_page"
        static let LANDING_PAGE = "landing_page"
        static let APPLICATION_STATUS = "application_status"
        static let LOAN_STATUS = "loan_status"
        static let DASHBOARD_PAGE = "dashboard"
        static let LOAD_MY_CARD = "load_my_card"
        static let LOAD_MY_CARD_DONE = "load_my_card_done"
        static let LOAD_MY_CARD_CONFIRM = "load_my_card_confirm"
        static let TRANSACTION = "transaction"
        static let PAY_NOW = "pay_now_emi"
        static let FORGOT_PASSWORD = "forgot_password"
        static let OUTGOING_EMI = "outgoing_emi"
        static let BLOCK_CARD = "BLOCK_CARD"
        static let LOAN_CALCULATOR = "LoanCalculator"
        static let PAYBACK = "payback"
        static let CUSTOMER_CARE = "customer_care"
        static let GET_STASHFIN_CARD = "get_stashfin_card"
        static let STASHFIN_CARD = "stashfin_card"
        static let CHANGE_CARD_PIN = "change_pin_stashfin_card"
        static let ACTIVE_STASHFIN_CARD_INTRO = "activate_stashfin_card_intro"
        static let ACTIVE_STASHFIN_CARD = "activate_stashfin_card"

    }
}

struct Colors {
    static let colorPrimary=UIColor(red: 0, green: 192/255, blue: 255/255, alpha: 1)
    static let black=UIColor(red: 0, green: 0, blue: 0, alpha: 1)
    static let white=UIColor(red: 1, green: 1, blue: 1, alpha: 1)

}


struct Fonts {
    static let avenirNextCondensedDemiBold = "AvenirNextCondensed-DemiBold"
    static let avenirNextMediumItalic = "AvenirNext-MediumItalic"
    static let avenirNextRegular = "AvenirNext-Regular"
    static let avenirNextItalic = "AvenirNext-Italic"
    static let avenirNextBold = "AvenirNext-Bold"
}




