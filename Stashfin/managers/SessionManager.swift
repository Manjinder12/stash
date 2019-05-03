//
//  SessionManager.swift
//  StashFinDemo
//
//  Created by Macbook on 05/02/19.
//  Copyright © 2019 StashFin. All rights reserved.
//
import UIKit
import SwiftKeychainWrapper

public class SessionManger {
    static let getInstance=SessionManger()
    
    let userDefaults=UserDefaults.standard
    
    private init() {
        
    }
    
//    Add a string value to keychain:
//    let saveSuccessful: Bool = KeychainWrapper.standard.set("Some String", forKey: "myKey")
    
//    Retrieve a string value from keychain:
//    let retrievedString: String? = KeychainWrapper.standard.string(forKey: "myKey")
    
//    Remove a string value from keychain:
//    let removeSuccessful: Bool = KeychainWrapper.standard.removeObject(forKey: "myKey")
    
    
    // string save
    private func saveDefaultValue(key:String,value:String){
        userDefaults.set(value, forKey: "\(key)\(getCustomerId())")
//        KeychainWrapper.standard.set(value, forKey: "\(key)\(getCustomerId())")
    }
    
    private func getStringValue(key:String)->String{
        return userDefaults.string(forKey: "\(key)\(getCustomerId())") ?? ""
//        return KeychainWrapper.standard.string(forKey: "\(key)\(getCustomerId())") ?? ""
    }
    
    // boolean save
    private func getBoolValue(key:String)->Bool{
        return userDefaults.bool(forKey: "\(key)\(getCustomerId())")
    }
    
    private func setBoolValue(key:String,value:Bool){
        return userDefaults.set(value, forKey: "\(key)\(getCustomerId())")
    }
    
    // boolean global save
    private func getGlobalBoolValue(key:String)->Bool{
        return userDefaults.bool(forKey: key)
    }
    
    private func setGlobalBoolValue(key:String,value:Bool){
        return userDefaults.set(value, forKey: key)
    }

    // string global save
    private func saveGlobalDefaultValue(key:String,value:String){
        userDefaults.set(value, forKey: key)
//        KeychainWrapper.standard.set(value, forKey: key)
    }

    private func getGlobalStringValue(key:String)->String{
        return userDefaults.string(forKey: key) ?? ""
//        return KeychainWrapper.standard.string(forKey: key) ?? ""
    }

    
    func saveAuthToken(token:String){
        saveDefaultValue(key: Constants.SavedKeys.token.rawValue, value: token)
    }
    
    public func getAuthToken()->String{
        return getStringValue(key: Constants.SavedKeys.token.rawValue)
    }
    

   public func saveApplicationStatus(status:String){
        saveDefaultValue(key: Constants.SavedKeys.applicationStatus.rawValue, value: status)
    }
    
    func getApplicationStatus()->String{
        return getStringValue(key: Constants.SavedKeys.applicationStatus.rawValue)
    }
    
    func saveLoanStatus(status:String){
        saveDefaultValue(key: Constants.SavedKeys.loanStatus.rawValue, value: status)
    }
    
    func getLoanStatus()->String{
        return getStringValue(key: Constants.SavedKeys.loanStatus.rawValue)
    }

    func saveCardResponse(cardResponse:String){
        saveDefaultValue(key: Constants.SavedKeys.CardResponse.rawValue, value: cardResponse)
    }
    
    public func getCardResponse()->String{
        return getStringValue(key: Constants.SavedKeys.CardResponse.rawValue)
    }
    
    func saveLocResponse(locResponse:String){
        saveDefaultValue(key: Constants.SavedKeys.LocResponse.rawValue, value: locResponse)
    }
    
    public func getLocResponse()->String{
        return getStringValue(key: Constants.SavedKeys.LocResponse.rawValue)
    }

    func saveProfilePic(profile:String){
        saveDefaultValue(key: Constants.SavedKeys.PROFILE_PIC.rawValue, value: profile)
    }
    
    public func getProfilePic()->String{
        return getStringValue(key: Constants.SavedKeys.PROFILE_PIC.rawValue)
    }
    
    func saveName(name:String){
        saveDefaultValue(key: Constants.SavedKeys.NAME.rawValue, value: name)
    }
    
    public func getName()->String{
        return getStringValue(key: Constants.SavedKeys.NAME.rawValue)
    }
    
    func saveEmail(email:String){
        saveDefaultValue(key: Constants.SavedKeys.EMAIL.rawValue, value: email)
    }
    
    public func getEmail()->String{
        return getStringValue(key: Constants.SavedKeys.EMAIL.rawValue)
    }
    
    func saveCardRequest(cardResponse:Bool){
        setBoolValue(key: Constants.SavedKeys.CardRequest.rawValue, value: cardResponse)
    }
    
    func setDeviceSaved(status:Bool){
        setBoolValue(key: Constants.SavedKeys.DEVICE_SAVED.rawValue, value: status)
    }
    
    public func getDeviceSaved()->Bool{
        return getBoolValue(key: Constants.SavedKeys.DEVICE_SAVED.rawValue)
    }
    
    public func getCardRequest()->Bool{
        return getBoolValue(key: Constants.SavedKeys.CardRequest.rawValue)
    }
    
    public func setRegistrationPage(page:String){
        saveDefaultValue(key: Constants.SavedKeys.REGISTRATION_PAGE.rawValue, value: page)
    }
    
    public func getRegistrationPage()-> String{
        return userDefaults.string(forKey: Constants.SavedKeys.REGISTRATION_PAGE.rawValue) ??  Constants.Controllers.SegueController.Personal.rawValue
    }
    
    // global values
    func setUserLogin(status:Bool){
        setGlobalBoolValue(key: Constants.SavedKeys.UserLogin.rawValue, value: status)
    }
    
    public func getUserLogin()->Bool{
        return getGlobalBoolValue(key: Constants.SavedKeys.UserLogin.rawValue)
    }
 
    public func saveCustomerId(id:String){
        saveGlobalDefaultValue(key: Constants.SavedKeys.CUSTOMER_ID.rawValue, value: id)
    }
    
    public func getCustomerId()->String{
        return getGlobalStringValue(key: Constants.SavedKeys.CUSTOMER_ID.rawValue)
    }
    
    public func clearAllData(){
        saveCardResponse(cardResponse: "")
        saveAuthToken(token: "")
        saveApplicationStatus(status: "")
        saveLoanStatus(status: "")
        saveLocResponse(locResponse: "")
        saveCustomerId(id: "")
    }
}
