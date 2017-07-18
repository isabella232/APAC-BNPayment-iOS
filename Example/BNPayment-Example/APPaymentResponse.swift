//
//  APPaymentResponse.swift
//  PayDemo
//
//  Created by Max Mattini on 16/03/2017.
//  Copyright © 2017 IPPayments. All rights reserved.
//

import Foundation

open class APPaymentResponse:NSObject
{
    public var errorCode:String
    public var declineCode:String
    public var errorDescription:String
    public var settlementDate:String
    public var timestamp:String
    public var receiptNumber:String
    public var result:String
    
    public func hasError() -> Bool
    {
        return "Error" == self.result
    }
    
    public func setError(errorDescription:String) -> Void
    {
        self.result = "Error"
        self.errorDescription = errorDescription
    }
    
    public init(errorCode: String, declineCode:String, errorDescription:String, settlementDate:String, timestamp: String, receiptNumber:String, result: String) {
        self.errorCode = errorCode
        self.declineCode = declineCode
        self.errorDescription = errorDescription
        self.settlementDate = settlementDate
        self.timestamp = timestamp
        self.receiptNumber = receiptNumber
        self.result = result
    }
    
    public override convenience init()
    {
        self.init(errorCode: "", declineCode:"", errorDescription:"", settlementDate:"", timestamp: "", receiptNumber:"", result: "")
    }
    
    public convenience init(errorCode: String, declineCode:String)
    {
        self.init(errorCode: errorCode, declineCode: declineCode, errorDescription:"", settlementDate:"", timestamp: "", receiptNumber:"", result: "")
    }
}
