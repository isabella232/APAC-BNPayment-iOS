//
//  AppSettings.swift
//  BNPayment-Example
//
//  Created by Balázs Szamódy on 19/8/20.
//  Copyright © 2020 Bambora. All rights reserved.
//

import Foundation
import BNPayment

private let kMaxCard = 20

let kPaymentData = "paymentData"
let kRegistrationData = "registrationData"
let kMerchantID = "MerchantID"

@objc class AppSettings: NSObject {
    private typealias Keys = UserDefaultsKey
    enum UserDefaultsKey: String {
        case donationAmount
        case profileName
        case favoriteCard = "FavoriteCard"
        case offlineMode = "OfflineMode"
        case touchIDMode = "TouchIDMode"
        case hppMode = "HPPMode"
        case velocityMode
        case numberOfCardsSaved
        case payOnceMode
        case scanVisualCuesHidden = "ScanVisualCuesHidden"
        case scanCardHolderName = "ScanCardHolderName"
        case visaCheckoutMode = "VisaCheckoutMode"
        case runMode
        
        var key: String {
            rawValue
        }
    }
    
    enum RunMode: Int, CaseIterable {
        case dev = 1
        case uat
        case prod
        
        static var defaultRunMode: RunMode {
            .uat
        }
        
        init?(_ name: String) {
            guard let runMode = RunMode.allCases.first(where: { $0.name == name}) else {
                return nil
            }
            
            self = runMode
        }
        
        var name: String {
            switch self {
            case .dev:
                return "Dev"
            case .uat:
                return "UAT"
            case .prod:
                return "Prod"
            }
        }
        
        var url: String {
            switch self {
            case .dev:
                return "https://devsandbox.ippayments.com.au/rapi/"
            case .uat:
                return "https://uat.ippayments.com.au/rapi/"
            case .prod:
                return "https://www.ippayments.com.au/rapi/"
            }
        }
        
        var merchantGuidKey: String {
            switch self {
            case .dev:
                return "MerchantGuid-Dev"
            case .uat:
                return "MerchantGuid-UAT"
            case .prod:
                return "MerchantGuid-Prod"
            }
        }
    }
    
    static func sharedInstance() -> AppSettings {
        AppSettings()
    }
    
    var runMode: RunMode = .defaultRunMode
    private var merchantGuid: String?
    var cardRegistrationGuiSetting: BNCardRegistrationGuiSetting?
    var submitSinglePaymentCardGuiSetting: BNSubmitSinglePaymentCardGuiSetting?
    
    var numberOfCardsSaved = 0
    
    private var userDefaults: UserDefaults {
        UserDefaults.standard
    }
    
    var userName: String {
        userDefaults.string(forKey: Keys.profileName.key) ?? "Mattias Johansson"
    }
    
    func setUsername(_ name: String) {
        userDefaults.set(name, forKey: Keys.profileName.key)
    }
    
    var donatedAmount: Int? {
        userDefaults.integer(forKey: Keys.donationAmount.key)
    }
    
    func updateDonatedAmount(_ amount: Int) {
        userDefaults.set(amount, forKey: Keys.donationAmount.key)
    }
    
    var selectedCardIndex: Int {
        0
    }
    
    var offlineMode: Bool {
        userDefaults.bool(forKey: Keys.offlineMode.key)
    }
    
    func setOfflineMode(_ offlineMode: Bool) {
        userDefaults.set(offlineMode, forKey: Keys.offlineMode.key)
    }
    
    var touchIDMode: Bool {
        userDefaults.bool(forKey: Keys.touchIDMode.key)
    }
    
    func setTouchIDMode(_ touchIDMode: Bool, newRunMode: Int) {
        userDefaults.set(touchIDMode, forKey: Keys.touchIDMode.key)
    }
    
    func getVisaCheckoutMode() -> Bool {
        userDefaults.bool(forKey: Keys.visaCheckoutMode.key)
    }
    
    func setVisaCheckoutMode(_ newVisaCheckoutMode: Bool) {
        userDefaults.set(newVisaCheckoutMode, forKey: Keys.visaCheckoutMode.key)
    }
    
    var HPPMode: Bool {
        userDefaults.bool(forKey: Keys.hppMode.key)
    }
    
    func setHPPMode(_ hppMode: Bool) {
        userDefaults.set(hppMode, forKey: Keys.hppMode.key)
    }
    
    var velocityMode: Bool {
        userDefaults.bool(forKey: Keys.velocityMode.key)
    }
    
    func setVelocityMode(_ newVelocityMode: Bool, newRunMode: Int) {
        userDefaults.set(newVelocityMode, forKey: Keys.velocityMode.key)
    }
    
    var restoreNumberOfCardsSaved: Int {
        userDefaults.integer(forKey: Keys.numberOfCardsSaved.key)
    }
    
    func persistNumberOfCardsSaved(_ cardNumber: Int) {
        userDefaults.set(cardNumber, forKey: Keys.numberOfCardsSaved.key)
    }
    
    var maxSavedCardReached: Bool {
        numberOfCardsSaved >= kMaxCard
    }
    
    func incrementNumberOfSavedCard() {
        persistNumberOfCardsSaved(numberOfCardsSaved + 1)
    }
    
    func decrementNumberOfSavedCard() {
        persistNumberOfCardsSaved(numberOfCardsSaved - 1)
    }
    
    var payOnceMode: Bool {
        userDefaults.bool(forKey: Keys.payOnceMode.key)
    }
    
    func setPayOnce(mode: Bool) {
        userDefaults.set(mode, forKey: Keys.payOnceMode.key)
    }
    
    var scanVisualCues: Bool {
        !userDefaults.bool(forKey: Keys.scanVisualCuesHidden.key)
    }
    
    func setScanVisualCues(_ scanVisualCues: Bool) {
        userDefaults.set(!scanVisualCues, forKey: Keys.scanVisualCuesHidden.key)
    }
    
    var scanCardHolderName: Bool {
        userDefaults.bool(forKey: Keys.scanCardHolderName.key)
    }
    
    func setScanCardHolderName(_ scanCardHolderName: Bool) {
        userDefaults.set(scanCardHolderName, forKey: Keys.scanCardHolderName.key)
    }
    
    var savedRunMode: RunMode {
        RunMode(rawValue: userDefaults.integer(forKey: Keys.runMode.key))
            ?? .defaultRunMode
    }
    
    func getRunMode() -> Int {
        savedRunMode.rawValue
    }
    
    func getRunModeBy(name: String) -> RunMode? {
        RunMode(name)
    }
    
    func getRunModeNameBy(_ rawValue: Int) -> String {
        RunMode(rawValue: rawValue)?.name ?? "?"
    }
    
    func setRunMode(_ newRunMode: Int) {
        userDefaults.set(newRunMode, forKey: Keys.runMode.key)
        runMode = RunMode(rawValue: newRunMode) ?? .defaultRunMode
    }
    
    func setRunMode(_ newRunMode: RunMode) {
        setRunMode(newRunMode.rawValue)
    }
    
    func getRunModeUrl() -> String {
        savedRunMode.url
    }
    
    func getCurrentRunModeMerchantGuid() -> String {
        if let merchantGuid = merchantGuid {
            return merchantGuid
        }
        
        let merchantGuid = getMerchantGuid(runMode)
        self.merchantGuid = merchantGuid
        return merchantGuid
    }
    
    func getMerchantGuid(_ runMode: RunMode?) -> String {
        do {
            if runMode == .defaultRunMode {
                guard let path = Bundle.main.path(forResource: kMerchantID, ofType: "txt") else {
                    throw NSError()
                }
                return try String(contentsOfFile: path, encoding: .utf8)
                    .trimmingCharacters(in: .whitespacesAndNewlines)
            } else {
                guard let currentKey = runMode?.merchantGuidKey,
                    let value = userDefaults.string(forKey: currentKey) else {
                        throw NSError()
                }
                return value
            }
        } catch {
            return ""
        }
    }
    
    func getMerchantGuid(_ runMode: Int) -> String {
        getMerchantGuid(RunMode(rawValue: runMode))
    }
    
    func setRunModeMerchantGuid(newRunMode: RunMode?, merchantGuid: String?) {
        guard let runMode = newRunMode,
            let guid = merchantGuid else {
                self.merchantGuid = nil
                userDefaults.removeObject(forKey: newRunMode?.merchantGuidKey ?? "")
            return
        }
        userDefaults.set(guid, forKey: runMode.merchantGuidKey)
        self.merchantGuid = merchantGuid
    }
    
    func setRunModeMerchantGuid(_ runMode: Int, newMerchantGuid: String?) {
        setRunModeMerchantGuid(newRunMode: RunMode(rawValue: runMode), merchantGuid: newMerchantGuid)
    }
    
    func getCardRegistrationGuiSetting() -> BNCardRegistrationGuiSetting? {
        if let setting = cardRegistrationGuiSetting {
            return setting
        }
        let defaultSetting = BNCardRegistrationGuiSetting()
        defaultSetting.titleText = userDefaults.string(forKey: BNCardRegistrationGuiSetting.getGuiKey(registrationTitleText))
        defaultSetting.cardHolderWatermark = userDefaults.string(forKey: BNCardRegistrationGuiSetting.getGuiKey(registrationCardHolderWatermark))
        defaultSetting.cardNumberWatermark = userDefaults.string(forKey: BNCardRegistrationGuiSetting.getGuiKey(registrationCardNumberWatermark))
        defaultSetting.expiryDateWatermark = userDefaults.string(forKey: BNCardRegistrationGuiSetting.getGuiKey(registrationExpiryDateWatermark))
        defaultSetting.securityCodeWatermark = userDefaults.string(forKey: BNCardRegistrationGuiSetting.getGuiKey(registrationSecurityCodeWatermark))
        defaultSetting.registrationButtonColor = userDefaults.string(forKey: BNCardRegistrationGuiSetting.getGuiKey(registrationButtonColor))
        defaultSetting.registerButtonText = userDefaults.string(forKey: BNCardRegistrationGuiSetting.getGuiKey(registrationButtonText))
        defaultSetting.registrationCardIODisable = userDefaults.bool(forKey: BNCardRegistrationGuiSetting.getGuiKey(registrationCardIODisable))
        defaultSetting.registrationCardIOColor = userDefaults.string(forKey: BNCardRegistrationGuiSetting.getGuiKey(registrationCardIOColor))
        return defaultSetting
    }
    
    func getSubmitSinglePaymentGuiSetting() -> BNSubmitSinglePaymentCardGuiSetting? {
        if let setting = submitSinglePaymentCardGuiSetting {
            return setting
        }
        
        let defaultSetting = BNSubmitSinglePaymentCardGuiSetting()
        defaultSetting.titleText = userDefaults.string(forKey: BNSubmitSinglePaymentCardGuiSetting.getGuiKey(payTitleText))
        defaultSetting.cardHolderWatermark = userDefaults.string(forKey: BNSubmitSinglePaymentCardGuiSetting.getGuiKey(payCardHolderWatermark))
        defaultSetting.cardNumberWatermark = userDefaults.string(forKey: BNSubmitSinglePaymentCardGuiSetting.getGuiKey(payCardHolderWatermark))
        defaultSetting.expiryDateWatermark = userDefaults.string(forKey: BNSubmitSinglePaymentCardGuiSetting.getGuiKey(payExpiryDateWatermark))
        defaultSetting.securityCodeWatermark = userDefaults.string(forKey: BNSubmitSinglePaymentCardGuiSetting.getGuiKey(paySecurityCodeWatermark))
        defaultSetting.switchButtonColor = userDefaults.string(forKey: BNSubmitSinglePaymentCardGuiSetting.getGuiKey(switchButtonColor))
        defaultSetting.payButtonColor = userDefaults.string(forKey: BNSubmitSinglePaymentCardGuiSetting.getGuiKey(payButtonColor))
        defaultSetting.payButtonText = userDefaults.string(forKey: BNSubmitSinglePaymentCardGuiSetting.getGuiKey(payButtonText))
        defaultSetting.loadingBarColor = userDefaults.string(forKey: BNSubmitSinglePaymentCardGuiSetting.getGuiKey(loadingBarColor))
        defaultSetting.cardIODisable = userDefaults.bool(forKey: BNSubmitSinglePaymentCardGuiSetting.getGuiKey(cardIODisable))
        defaultSetting.cardIOColor = userDefaults.string(forKey: BNSubmitSinglePaymentCardGuiSetting.getGuiKey(cardIOColor))
        
        return defaultSetting
    }
    
    func setCardRegistrationGuiSetting(_ setting: BNCardRegistrationGuiSetting) {
        userDefaults.set(setting.titleText, forKey: BNCardRegistrationGuiSetting.getGuiKey(registrationTitleText))
        userDefaults.set(setting.cardHolderWatermark, forKey: BNCardRegistrationGuiSetting.getGuiKey(registrationCardHolderWatermark))
        userDefaults.set(setting.cardNumberWatermark, forKey: BNCardRegistrationGuiSetting.getGuiKey(registrationCardNumberWatermark))
        userDefaults.set(setting.expiryDateWatermark, forKey: BNCardRegistrationGuiSetting.getGuiKey(registrationExpiryDateWatermark))
        userDefaults.set(setting.securityCodeWatermark, forKey: BNCardRegistrationGuiSetting.getGuiKey(registrationSecurityCodeWatermark))
        userDefaults.set(setting.registerButtonText, forKey: BNCardRegistrationGuiSetting.getGuiKey(registrationButtonText))
        userDefaults.set(setting.registrationButtonColor, forKey: BNCardRegistrationGuiSetting.getGuiKey(registrationButtonColor))
        userDefaults.set(setting.registrationCardIODisable, forKey: BNCardRegistrationGuiSetting.getGuiKey(registrationCardIODisable))
        userDefaults.set(setting.registrationCardIOColor, forKey: BNCardRegistrationGuiSetting.getGuiKey(registrationCardIOColor))
        
        cardRegistrationGuiSetting = setting
    }
    
    func setSubmitSinglePaymentCardGuiSetting(_ setting: BNSubmitSinglePaymentCardGuiSetting) {
        userDefaults.set(setting.titleText, forKey: BNSubmitSinglePaymentCardGuiSetting.getGuiKey(payTitleText))
        userDefaults.set(setting.cardHolderWatermark, forKey: BNSubmitSinglePaymentCardGuiSetting.getGuiKey(payCardHolderWatermark))
        userDefaults.set(setting.cardNumberWatermark, forKey: BNSubmitSinglePaymentCardGuiSetting.getGuiKey(payCardNumberWatermark))
        userDefaults.set(setting.expiryDateWatermark, forKey: BNSubmitSinglePaymentCardGuiSetting.getGuiKey(payExpiryDateWatermark))
        userDefaults.set(setting.securityCodeWatermark, forKey: BNSubmitSinglePaymentCardGuiSetting.getGuiKey(paySecurityCodeWatermark))
        userDefaults.set(setting.payButtonText, forKey: BNSubmitSinglePaymentCardGuiSetting.getGuiKey(payButtonText))
        userDefaults.set(setting.payButtonColor, forKey: BNSubmitSinglePaymentCardGuiSetting.getGuiKey(payButtonColor))
        userDefaults.set(setting.switchButtonColor, forKey: BNSubmitSinglePaymentCardGuiSetting.getGuiKey(switchButtonColor))
        userDefaults.set(setting.loadingBarColor, forKey: BNSubmitSinglePaymentCardGuiSetting.getGuiKey(loadingBarColor))
        userDefaults.set(setting.cardIODisable, forKey: BNSubmitSinglePaymentCardGuiSetting.getGuiKey(cardIODisable))
        userDefaults.set(setting.cardIOColor, forKey: BNSubmitSinglePaymentCardGuiSetting.getGuiKey(cardIOColor))
        
        submitSinglePaymentCardGuiSetting = setting
    }
    
    var getTestUrl: String {
        ""
    }
    
    var getTestToken: String {
        ""
    }
    
    var getProdUrl: String {
        ""
    }
    
    var getProdToken: String {
        ""
    }
    
    func getCompileDate() -> String {
        guard let infoDate = getFullCompileDate() else {
            return "N/A"
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/DD"
        return formatter.string(from: infoDate)
    }
    
    func getCompileTime() -> String {
        guard let infoDate = getFullCompileDate() else {
            return "N/A"
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        return formatter.string(from: infoDate)
    }
    
    private func getFullCompileDate() -> Date? {
        guard let infoPath = Bundle.main.path(forResource: "Info", ofType: "plist"),
        let infoAttr = try? FileManager.default.attributesOfItem(atPath: infoPath) else {
                return nil
        }
        
        return infoAttr[.creationDate] as? Date
    }
    
    func selectedCard() -> BNAuthorizedCreditCard? {
        let index = userDefaults.integer(forKey: Keys.favoriteCard.key)
        
        return BNPaymentHandler
            .sharedInstance()?
            .authorizedCards()?
            .enumerated()
            .first(where: { $0.offset == index})?
            .element
    }
    
    func readJson(fromResource resourceName: String) -> [String: Any]? {
        do {
            guard let filePath = Bundle.main.path(forResource: resourceName, ofType: "json") else {
                throw NSError()
            }
            let url = URL(fileURLWithPath: filePath)
            let data = try Data(contentsOf: url)
            guard let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
                throw NSError()
            }
            return json
        } catch {
            return nil
        }
    }
    
    func retrieveJsonDataforKey(_ key: String) -> [String: Any]? {
        userDefaults.dictionary(forKey: key)
            ?? readJson(fromResource: key)
    }
    
    func persistJsonDataRegistration(_ json: [String: Any], forKey key: String) {
        userDefaults.set(json, forKey: key)
    }
    
    func createMockPaymentParameters(_ amount: NSNumber, comment: String, token: String) -> BNPaymentParams {
        let paymentIdentifier = String(format: "%u", arc4random())
        guard let mockObject = BNPaymentParams(id: paymentIdentifier, currency: "AUD", amount: amount, token: token, comment: comment) else {
            fatalError("Getting payment params failed")
        }
        if let data = retrieveJsonDataforKey(kPaymentData) {
            mockObject.setPaymentJsonData(data)
        }
        
        return mockObject
    }
    
    func createMockSinglePaymentParameters(_ amount: NSNumber, comment: String) -> BNPaymentParams {
        createMockPaymentParameters(amount, comment: comment, token: "")
    }
}
