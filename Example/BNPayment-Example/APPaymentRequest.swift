//
//  APPaymentRequest.swift
//  ApplePaySDK
//
//  Created by Max Mattini on 16/03/2017.
//  Copyright © 2017 Max Mattini. All rights reserved.
//

import Foundation
import PassKit

open class APPaymentRequest:NSObject
{
    public var payment:PKPayment?
    public var appKey:String
    public var appSecret:String
    public var custNumber:String
    public var custReference:String
    public var receiptNumber:String?
    public var recurringPayment:APRecurringPayment?
    public var paymentType:APTrnTypes
    
    public init(payment: PKPayment?, appKey:String, appSecret:String, custNumber:String, custReference: String, receiptNumber:String, result: String, recurringPayment:APRecurringPayment?,  paymentType: APTrnTypes) {
        self.payment = payment
        self.appKey = appKey
        self.appSecret = appSecret
        self.custNumber = custNumber
        self.custReference = custReference
        self.receiptNumber = receiptNumber
        self.recurringPayment = recurringPayment
        self.paymentType = paymentType
    }
    
    public convenience init(payment: PKPayment?, appKey:String, appSecret:String, custNumber:String, custReference: String, paymentType: APTrnTypes) {
        self.init(payment: payment, appKey:appKey, appSecret:appSecret, custNumber:custNumber, custReference: custReference, receiptNumber:"", result: "", recurringPayment:nil,  paymentType: paymentType)    }
    
    public override convenience init()
    {
        self.init(payment: nil, appKey:"", appSecret:"", custNumber:"", custReference: "", receiptNumber:"", result: "", recurringPayment:nil,  paymentType: APTrnTypes.PURCHASE)
    }
    
}
