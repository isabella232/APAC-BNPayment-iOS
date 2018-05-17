//
//  BNPaymentParamsTests.m
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

#import <XCTest/XCTest.h>

@interface BNPaymentParamsTests : XCTestCase

@end

@implementation BNPaymentParamsTests


- (void)testPaymentParamsWithId {
    
    // Given:
    NSString *identifier = @"identifier";
    NSString *currency = @"currency";
    NSNumber *amount = @100;
    NSString *token = @"token";
    NSString *comment = @"comment";
    NSString *paymentValidation = @"none";
    
    BNPaymentParams *correctObject = [BNPaymentParams new];
    correctObject.paymentIdentifier = identifier;
    correctObject.currency = currency;
    correctObject.amount = amount;
    correctObject.token = token;
    correctObject.comment = comment;
    correctObject.paymentValidation=paymentValidation;
    // When:
    BNPaymentParams *paymentParameters = [BNPaymentParams paymentParamsWithId:identifier
                                                                     currency:currency
                                                                       amount:amount
                                                                        token:token
                                                                      comment:comment];
    
    // Then:
    XCTAssertEqualObjects(correctObject, paymentParameters, "The corret payment params should be equal to the paymentParameters variable created with helper method.");
}

@end
