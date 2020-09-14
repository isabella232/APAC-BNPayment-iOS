//
//  AppDelegate.swift
//  BNPayment-Example
//
//  Created by Balázs Szamódy on 19/8/20.
//  Copyright © 2020 Bambora. All rights reserved.
//

import UIKit
import BNPayment

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func applicationDidFinishLaunching(_ application: UIApplication) {
        let appSettings = AppSettings.sharedInstance()
        setupPaymentHandler(appSettings)
        
        BNTouchIDValidation.enable()
        
        let data = appSettings.retrieveJsonDataforKey(kRegistrationData)
        BNRegisterCCParams.setRegistrationJsonData(data)
        
        let tabController = window?.rootViewController as? UITabBarController
        tabController?.tabBar.barTintColor = .purple
        
        UITabBarItem
            .appearance()
            .setTitleTextAttributes([
                .foregroundColor: UIColor.gray,
            ], for: .normal)
        UITabBarItem
            .appearance()
            .setTitleTextAttributes([
                .foregroundColor: UIColor.white,
            ], for: .selected)
        
        UITabBar.appearance().tintColor = .white
        UISegmentedControl.appearance().tintColor = .purple
        
        mockVisaCheckParams()
        mockVisaCheckoutTransaction()
    }
    
    private func setupPaymentHandler(_ appSettings: AppSettings) {
        do {
            try BNPaymentHandler.setup(withMerchantAccount: appSettings.getCurrentRunModeMerchantGuid(), baseUrl: appSettings.getRunModeUrl(), debug: true)
            
        } catch {
            guard (error as NSError).domain != "Foundation._GenericObjCError", (error as NSError).code != 0 else {
                return
            }
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        }
    }
    
    func mockVisaCheckParams() {
        OHHTTPStubs.stubRequests(passingTest: { (request) -> Bool in
            request.url?.path == "/rapi/visacheckout_params"
        }) { (request) -> OHHTTPStubsResponse in
            let filePath: String! = OHPathForFile("VisaCheckoutParams.json", self.classForCoder)
            let response = OHHTTPStubsResponse(fileAtPath: filePath, statusCode: 200, headers: ["Content-Type": "application/json"])
            response.responseTime = 1
            return response
        }
    }
    
    func mockVisaCheckoutTransaction() {
        OHHTTPStubs.stubRequests(passingTest: { (request) -> Bool in
            request.url?.path == "/rapi/visacheckout_transaction"
        }) { (request) -> OHHTTPStubsResponse in
            let filePath: String! = OHPathForFile("VisaCheckoutTransaction.json", self.classForCoder)
            let response = OHHTTPStubsResponse(fileAtPath: filePath, statusCode: 200, headers: ["Content-Type": "application/json"])
            response.responseTime = 3
            return response
        }
    }
}
