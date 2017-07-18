//
//  IPAPmodels.swift
//  IPApplePaySDK
//
//  Created by Max Mattini on 15/03/2017.
//  Copyright © 2017 Max Mattini. All rights reserved.
//

import Foundation
import PassKit

open class APPaymentDetail:NSObject
{
    public var trnTypeId:String
    public var receiptNumber:String
    
    public init(trnTypeId: String, receiptNumber:String) {
        self.trnTypeId = trnTypeId
        self.receiptNumber = receiptNumber
    }
    
    public override convenience init()
    {
        self.init(trnTypeId: "", receiptNumber:"")
    }
}


public enum APTrnTypes:Int  {
    case PURCHASE = 1
    case AUTHORIZATION = 2
    case RECURRING = 7
}



