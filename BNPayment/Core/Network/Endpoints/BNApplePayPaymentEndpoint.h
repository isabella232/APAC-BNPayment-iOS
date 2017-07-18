//
//  BNApplePayPaymentEndpoint.h
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

#import <Foundation/Foundation.h>
#import "BNPaymentEndpoint.h"

@class BNPaymentHandler;
@class BNPaymentResponse;
@class BNPaymentParams;


/**
 `BNApplePayPaymentEndpoint` is a subclass of `BNBaseEndpoint`
 `BNApplePayPaymentEndpoint` offers convenient methods for handling Apple Pay payment API calls.
 */
@interface BNApplePayPaymentEndpoint : NSObject

/**
 *  A method for processing an Apple Pay payment.
 *
 *  @param params            `BNPaymentParams` representing the payment to be authorized.
 *  @param completion        `BNPaymentRequestBlock` excecuted when the operation is completed.
 *
 *  @return `NSURLSessionDataTask`
 */
+ (NSURLSessionDataTask *)authorizePaymentWithParams:(BNPaymentParams *)params
                                          completion:(BNPaymentRequestBlock)completion;

@end
