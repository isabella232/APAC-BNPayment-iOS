//
//  APProcessor.swift
//  IPApplePaySDK
//
//  Created by Max Mattini on 15/03/2017.
//  Copyright © 2017 Max Mattini. All rights reserved.
//

import Foundation
import PassKit

open class  APProcessor : NSObject{
    let kTestUrl:String = "https://devsandbox.ippayments.com.au/rapi/applepaypayments/AppleTest/applepaypayments"
    
   public func submitPayment(paymentRequest:APPaymentRequest) -> APRESTPaymentResponse?
    {
         return  processPayment(paymentRequest: paymentRequest)
    }
    
   public func submitRecurringPayment(paymentRequest:APPaymentRequest) -> APRESTPaymentResponse?
    {
        paymentRequest.paymentType = .RECURRING
        return  processPayment(paymentRequest: paymentRequest)
    }
    
    private func errorResponse(response: APRESTPaymentResponse, msg:String) -> APRESTPaymentResponse
    {
        print(msg)
        response.setError(errorDescription: msg)
        return response
    }
    
    private func error(response: APRESTPaymentResponse, msg:String) -> (APRESTPaymentResponse, PKPaymentToken?)
    {
        print(msg)
        response.setError(errorDescription: msg)
        return (response, nil)
    }
    
    private func createAndCheckRequest(paymentRequest:APPaymentRequest) -> (APRESTPaymentResponse, PKPaymentToken?)
    {
        let response = APRESTPaymentResponse(errorCode: "200", declineCode: "200")
        
        let _tokenData: PKPaymentToken = paymentRequest.payment!.token
        guard !_tokenData.paymentData.isEmpty else {
            return error(response: response, msg:"Payment data should not be empty.")
        }
        
        guard !paymentRequest.appKey.isEmpty, !paymentRequest.appSecret.isEmpty else {
            return error(response: response, msg: "ApiKey or AppSecret should not be empty.")
        }
        
        guard !paymentRequest.custNumber.isEmpty else {
            return error(response: response, msg: "Customer number should not be empty.")
        }
        
        guard !paymentRequest.custReference.isEmpty else {
            return error(response: response, msg:"Customer reference should not be empty.")
        }
        
        return (response, _tokenData)

    }
    
    private func processPayment(paymentRequest:APPaymentRequest) -> APRESTPaymentResponse?
    {
        let (response, _tokenData) = createAndCheckRequest(paymentRequest:paymentRequest)
        
        guard let tokenData = _tokenData else {
            
            return response
        }
        
        //create a query string to send apiKey and apiSecret to ipp webservice
        let queryString = kTestUrl
        
        // TODO [[]]z do not trace this payment data for production
        print("tokenData: \(tokenData)")
        
        // create a request with url
        guard let theUrl = URL(string:queryString) else {
            return errorResponse(response: response, msg:"Cannot create URL.")
        }
        var theRequest = URLRequest(url: theUrl)
        theRequest.timeoutInterval = 60.0
        theRequest.cachePolicy = .useProtocolCachePolicy
        
        var trnTypeId = ""
        switch (paymentRequest.paymentType) {
        case .PURCHASE:
            trnTypeId = "1"
        case .AUTHORIZATION:
            trnTypeId = "2"
        case .RECURRING:
            trnTypeId = "7"
        default:
            //by default treat this as purchase ??
            trnTypeId = "1"
        }
        
        var jsonDictionary:[String:Any] = [
            "custRef" : paymentRequest.custReference,
            "custNumber" : paymentRequest.custNumber,
            "trnTypeId" : trnTypeId,
            "transactionIdentifier" : tokenData.transactionIdentifier,
            "paymentInstrumentName" : tokenData.paymentInstrumentName,
            "paymentNetwork" : tokenData.paymentNetwork
        ]
        
        do {
            if let paymentDataDict = try JSONSerialization.jsonObject(with: tokenData.paymentData, options: []) as? [String: AnyObject] {
                jsonDictionary["paymentData"] = paymentDataDict
            }
        } catch {
            return errorResponse(response: response, msg:"Interface error.")
        }
        
        if let _receiptNumber = paymentRequest.receiptNumber  {
            jsonDictionary["receiptNumber"] = _receiptNumber;
        }
        
        if(paymentRequest.paymentType == .RECURRING){
            //for recurring payments only
            if let _recurringPayment = paymentRequest.recurringPayment {
                var recurringDictionary:[String:String] = [:]
                
                let _frequency = _recurringPayment.frequency
                let _startDate = _recurringPayment.startDate
                let _endDate = _recurringPayment.endDate
                guard  !_frequency.isEmpty, !_startDate.isEmpty, !_endDate.isEmpty else {
                    return errorResponse(response: response, msg:"Payment frequency/startDate/endDate should not be empty.")
                }
                recurringDictionary["frequency"] = _frequency
                recurringDictionary["startDate"] = _startDate
                recurringDictionary["endDate"] = _endDate
                
                let _numOfPayments = _recurringPayment.numOfPayments
                if  !_numOfPayments.isEmpty{
                    recurringDictionary["numOfPayments"] = _numOfPayments
                }
                jsonDictionary["recurring"] = recurringDictionary;
            }
        }
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject:jsonDictionary, options:[.prettyPrinted])
            let dataString = String(data: jsonData, encoding: String.Encoding.utf8)!
            
            theRequest.httpMethod = "POST"
            theRequest.addValue("application/json", forHTTPHeaderField:"Content-Type")
            theRequest.httpBody = jsonData
            
            let authDictionary:[String:String] = ["appKey" : paymentRequest.appKey, "appSecret" : paymentRequest.appSecret]
            
            theRequest.allHTTPHeaderFields = authDictionary
            
            print("        request : \(theRequest)")
            print("           json : \(jsonDictionary)")
            print("request    body : \(dataString)")
            print("request headers : \(theRequest.allHTTPHeaderFields)")
            
            let session = URLSession.shared
            let (retData, _, err) = session.synchronousDataTaskWithRequest(request: theRequest)
            
            guard err == nil, retData != nil else {
                return errorResponse(response: response, msg:"Interface error.")
            }
            
            let dataString1 = String(data: retData!, encoding: String.Encoding.utf8)!
            // BE Results : {"Result":"APPROVED","ErrorCode":0,"DecCode":0,"DecDescription":null}
            print("BE Results : \(dataString1)")
            
            do {
                if let jsonResponseDict = try JSONSerialization.jsonObject(with: retData!, options: []) as? [String: AnyObject] {
                    
                    let jsonResponseData = jsonResponseDict["d"]
                    if jsonResponseData == nil {
                        
                        // Server may have returned a response containing an error
                        // The "ExceptionType" value is returned from my .NET server used in sample
                        if let jsonExceptioTypeData = jsonResponseDict["ExceptionType"] {
                            let f = #function
                            print("\(f) ERROR : Server returned an exception")
                            print("\(f) ERROR : Server error details = \(jsonExceptioTypeData)")
                            return errorResponse(response: response, msg:"Interface error.")
                            
                        } else {
                            
                            //handle response and returning data
                            
                            if let _state = jsonResponseDict["state"] as? String {
                                response.state = _state
                            }
                            
                            if let _comment = jsonResponseDict["comment"] as? String {
                                response.comment = _comment
                            }
                            
//                            if let number = jsonResponseDict["ErrorCode"] as? NSNumber {
//                                response.state = number.stringValue
//                            }
//                            
//                            if let result = jsonResponseDict["Result"] as? String {
//                                response.state = result
//                            }
                            
//                            if let _receipt = jsonResponseDict["Reciept"] {
//                                response.receiptNumber = _receipt as! String
//                            }
                        }
                    }
                }
            } catch {
                return errorResponse(response: response, msg:"Cannot get JSON from response")
            }
        } catch {
            return errorResponse(response: response, msg:"Cannot create data from JSON")
        }
        return response
    }
}

public extension URLSession {
    
    /// Return data from synchronous  request
    func synchronousDataTaskWithRequest(request: URLRequest) -> (Data?, URLResponse?, Error?) {
        var data: Data?, response: URLResponse?, error: Error?
        
        let semaphore = DispatchSemaphore(value: 0)
        
        dataTask(with: request) {
            data = $0; response = $1; error = $2
            semaphore.signal()
            }.resume()
        
        semaphore.wait()
        
        return (data, response, error)
    }
}
