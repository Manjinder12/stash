// To parse the JSON, add this file to your project and do:
//
//   let loginResponseModel = try LoginResponseModel(json)

import Foundation

struct LoginResponseModel: Codable {
    let customerID, loanID, otp, otpTime: String?
    let customerName, email, phone, dob: String?
    let profilePic, loanStatus, productCode, aadharNumber: String?
    let panNumber, address, cityName, stateName: String?
    let pin, virtualAccountNumber, landingPage, mPin: String?
    let authToken: String?
    let latestLoanDetails: LatestLoanDetails?
    let cardStatus: CardStatus?
    let signatureUpload: Bool?
    let lastDeviceLogDates: LastDeviceLogDates?
    let appVersion, updateRequired: String?
    let paybackStatus: Bool?
    let occupation, message: String?
    
    enum CodingKeys: String, CodingKey {
        case customerID = "customer_id"
        case loanID = "loan_id"
        case otp
        case otpTime = "otp_time"
        case customerName = "customer_name"
        case email, phone, dob
        case profilePic = "profile_pic"
        case loanStatus = "loan_status"
        case productCode = "product_code"
        case aadharNumber = "aadhar_number"
        case panNumber = "pan_number"
        case address
        case cityName = "city_name"
        case stateName = "state_name"
        case pin
        case virtualAccountNumber = "virtual_account_number"
        case landingPage = "landing_page"
        case mPin = "m_pin"
        case authToken = "auth_token"
        case latestLoanDetails = "latest_loan_details"
        case cardStatus = "card_status"
        case signatureUpload = "signature_upload"
        case lastDeviceLogDates
        case appVersion = "app_version"
        case updateRequired = "update_required"
        case paybackStatus, occupation, message
    }
}

struct CardStatus: Codable {
    let cardFound, cardRegistered, otpVerified: Bool?
    let cardVendor: String?
    
    enum CodingKeys: String, CodingKey {
        case cardFound = "card_found"
        case cardRegistered = "card_registered"
        case otpVerified = "otp_verified"
        case cardVendor = "card_vendor"
    }
}

struct LastDeviceLogDates: Codable {
    let lastCallDate, lastSMSDate, lastContactDate, lastCalenderDate: String?
    let lastAppDate: String?
    
    enum CodingKeys: String, CodingKey {
        case lastCallDate
        case lastSMSDate = "lastSmsDate"
        case lastContactDate, lastCalenderDate, lastAppDate
    }
}

struct LatestLoanDetails: Codable {
    let loanID, requestedAmount, requestedTenure, requestedRate: String?
    let loanCreationDate, currentStatus, productCode: String?
    
    enum CodingKeys: String, CodingKey {
        case loanID = "loan_id"
        case requestedAmount = "requested_amount"
        case requestedTenure = "requested_tenure"
        case requestedRate = "requested_rate"
        case loanCreationDate = "loan_creation_date"
        case currentStatus = "current_status"
        case productCode = "product_code"
    }
}

// MARK: Convenience initializers and mutators

extension LoginResponseModel {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(LoginResponseModel.self, from: data)
    }
    
    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func with(
        customerID: String?? = nil,
        loanID: String?? = nil,
        otp: String?? = nil,
        otpTime: String?? = nil,
        customerName: String?? = nil,
        email: String?? = nil,
        phone: String?? = nil,
        dob: String?? = nil,
        profilePic: String?? = nil,
        loanStatus: String?? = nil,
        productCode: String?? = nil,
        aadharNumber: String?? = nil,
        panNumber: String?? = nil,
        address: String?? = nil,
        cityName: String?? = nil,
        stateName: String?? = nil,
        pin: String?? = nil,
        virtualAccountNumber: String?? = nil,
        landingPage: String?? = nil,
        mPin: String?? = nil,
        authToken: String?? = nil,
        latestLoanDetails: LatestLoanDetails?? = nil,
        cardStatus: CardStatus?? = nil,
        signatureUpload: Bool?? = nil,
        lastDeviceLogDates: LastDeviceLogDates?? = nil,
        appVersion: String?? = nil,
        updateRequired: String?? = nil,
        paybackStatus: Bool?? = nil,
        occupation: String?? = nil,
        message: String?? = nil
        ) -> LoginResponseModel {
        return LoginResponseModel(
            customerID: customerID ?? self.customerID,
            loanID: loanID ?? self.loanID,
            otp: otp ?? self.otp,
            otpTime: otpTime ?? self.otpTime,
            customerName: customerName ?? self.customerName,
            email: email ?? self.email,
            phone: phone ?? self.phone,
            dob: dob ?? self.dob,
            profilePic: profilePic ?? self.profilePic,
            loanStatus: loanStatus ?? self.loanStatus,
            productCode: productCode ?? self.productCode,
            aadharNumber: aadharNumber ?? self.aadharNumber,
            panNumber: panNumber ?? self.panNumber,
            address: address ?? self.address,
            cityName: cityName ?? self.cityName,
            stateName: stateName ?? self.stateName,
            pin: pin ?? self.pin,
            virtualAccountNumber: virtualAccountNumber ?? self.virtualAccountNumber,
            landingPage: landingPage ?? self.landingPage,
            mPin: mPin ?? self.mPin,
            authToken: authToken ?? self.authToken,
            latestLoanDetails: latestLoanDetails ?? self.latestLoanDetails,
            cardStatus: cardStatus ?? self.cardStatus,
            signatureUpload: signatureUpload ?? self.signatureUpload,
            lastDeviceLogDates: lastDeviceLogDates ?? self.lastDeviceLogDates,
            appVersion: appVersion ?? self.appVersion,
            updateRequired: updateRequired ?? self.updateRequired,
            paybackStatus: paybackStatus ?? self.paybackStatus,
            occupation: occupation ?? self.occupation,
            message: message ?? self.message
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension CardStatus {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(CardStatus.self, from: data)
    }
    
    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func with(
        cardFound: Bool?? = nil,
        cardRegistered: Bool?? = nil,
        otpVerified: Bool?? = nil,
        cardVendor: String?? = nil
        ) -> CardStatus {
        return CardStatus(
            cardFound: cardFound ?? self.cardFound,
            cardRegistered: cardRegistered ?? self.cardRegistered,
            otpVerified: otpVerified ?? self.otpVerified,
            cardVendor: cardVendor ?? self.cardVendor
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension LastDeviceLogDates {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(LastDeviceLogDates.self, from: data)
    }
    
    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func with(
        lastCallDate: String?? = nil,
        lastSMSDate: String?? = nil,
        lastContactDate: String?? = nil,
        lastCalenderDate: String?? = nil,
        lastAppDate: String?? = nil
        ) -> LastDeviceLogDates {
        return LastDeviceLogDates(
            lastCallDate: lastCallDate ?? self.lastCallDate,
            lastSMSDate: lastSMSDate ?? self.lastSMSDate,
            lastContactDate: lastContactDate ?? self.lastContactDate,
            lastCalenderDate: lastCalenderDate ?? self.lastCalenderDate,
            lastAppDate: lastAppDate ?? self.lastAppDate
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension LatestLoanDetails {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(LatestLoanDetails.self, from: data)
    }
    
    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func with(
        loanID: String?? = nil,
        requestedAmount: String?? = nil,
        requestedTenure: String?? = nil,
        requestedRate: String?? = nil,
        loanCreationDate: String?? = nil,
        currentStatus: String?? = nil,
        productCode: String?? = nil
        ) -> LatestLoanDetails {
        return LatestLoanDetails(
            loanID: loanID ?? self.loanID,
            requestedAmount: requestedAmount ?? self.requestedAmount,
            requestedTenure: requestedTenure ?? self.requestedTenure,
            requestedRate: requestedRate ?? self.requestedRate,
            loanCreationDate: loanCreationDate ?? self.loanCreationDate,
            currentStatus: currentStatus ?? self.currentStatus,
            productCode: productCode ?? self.productCode
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

fileprivate func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

fileprivate func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}
