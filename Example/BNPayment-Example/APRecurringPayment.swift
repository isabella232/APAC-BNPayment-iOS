//
//  APRecurringPayment.swift
//  ApplePaySDK
//
//  Created by Max Mattini on 16/03/2017.
//  Copyright © 2017 Max Mattini. All rights reserved.
//
// ApplePaySDK-Swift
import Foundation

open class APRecurringPayment:NSObject
{
    public var frequency:String
    public var startDate:String
    public var endDate:String
    public var numOfPayments:String
    public var noEnd:Bool
    
    public init(frequency: String, startDate:String, endDate:String, numOfPayments:String, noEnd: Bool) {
        self.frequency = frequency
        self.startDate = startDate
        self.endDate = endDate
        self.numOfPayments = numOfPayments
        self.noEnd = noEnd
    }
    
    public override convenience init()
    {
        self.init(frequency: "", startDate:"", endDate:"", numOfPayments:"", noEnd: false)
    }
}
