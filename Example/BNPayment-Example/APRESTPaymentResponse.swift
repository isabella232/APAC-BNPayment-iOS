//
//  APPaymentResponse.swift
//  PayDemo
//
//  Created by Max Mattini on 16/03/2017.
//  Copyright © 2017 IPPayments. All rights reserved.
//

import Foundation

open class APRESTPaymentResponse:NSObject
{
    /*
     "currency": null,
     "operations": null,
     "payment": null,
     "captures": null,
     "state": null,
     "region": null,
     "operationInProgress": false,
     "amount": 0,
     "refunds": null,
     "comment": null,
     "merchant": null
     
     */
    
    
    
    public var currency:String
    public var payment:String
    public var state:String
    public var region:String
    public var amount:Double
    public var comment:String
    public var merchant:String
    
    
    public func hasError() -> Bool
    {
        return "1" == self.state
    }
    
    public func setError(errorDescription:String) -> Void
    {
        self.state = "1"
        self.comment = errorDescription
    }
    
    public init(currency:String, payment:String, state:String, region:String, amount:Double, comment:String, merchant:String) {
        self.currency = currency
        self.payment = payment
        self.state = state
        self.region = region
        self.amount = amount
        self.comment = comment
        self.merchant = merchant
    }
    
    public override convenience init()
    {
        self.init(currency: "", payment:"", state:"", region:"", amount: 0.0, comment:"", merchant: "")
    }
    
    public convenience init(errorCode: String, declineCode:String)
    {
        self.init(currency: "", payment:"", state:errorCode, region:"", amount: 0.0, comment:declineCode, merchant: "")
    }

}
