//
//  BNTokenizedCreditCard.h
//  Copyright (c) 2016 Bambora ( http://bambora.com/ )
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "BNBaseModel.h"

@class BNPaymentParams;

/**
 *  `BNAuthorizedCreditCard` represents a tokenized credit card.
 */
@interface BNAuthorizedCreditCard : BNBaseModel

@property (nonatomic, strong) NSString *creditCardHolder;
@property (nonatomic, strong) NSString *creditCardAlias;
@property (nonatomic, strong) NSString *creditCardNumber;
@property (nonatomic, strong) NSString *creditCardToken;
@property (nonatomic, strong) NSString *creditCardType;
@property (nonatomic, strong) NSNumber *creditCardExpiryMonth;
@property (nonatomic, strong) NSNumber *creditCardExpiryYear;

/**
 *  A convenience method for creating an instance of `BNPaymentParams`
 *
 *  @param identifier `NSString` Representing the identifier of the payment.
 *  @param currency   `NSString` Representing the ISO 4217 currency code of the payment.
 *  @param amount     `NSString` Representing the amount in cents of the payment.
 *  @param comment    `NSString` Reprenseting an optional comment for the payment.
 *
 *  @return An instance of `BNPaymentParams`
 */
- (BNPaymentParams *)paymentParamsWithId:(NSString *)identifier
                                currency:(NSString *)currency
                                  amount:(NSNumber *)amount
                                 comment:(NSString *)comment;

@end
