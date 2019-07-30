//
//  BNPayment.h
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
#import "BNCreditCard.h"

@interface BNPaymentParams : BNBaseModel

@property (nonatomic, strong) NSString *paymentIdentifier;
@property (nonatomic, strong) NSString *currency;
@property (nonatomic, strong) NSNumber *amount;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *comment; // Optional
@property (nonatomic, strong) NSString *paymentValidation; // Optional

// Optional dictionary which is passed to backend. Should contain Json serializable data
- (NSDictionary *) cardJsonData;
- (void) setCardJsonData:(NSDictionary*) data;

// Optional dictionary, specific to ApplePay,and submit single payment at the moment.
// which is passed to the backend. Should contain Json serializable data
- (NSDictionary*) paymentJsonData;
- (void) setPaymentJsonData:(NSDictionary*) data;


-(void)SetCreditCardJsonData: (BNCreditCard*) creditCard
             isTokenRequired: (BOOL) isTokenRequired;

+ (BNPaymentParams *)paymentParamsWithId:(NSString *)identifier
                                currency:(NSString *)currency
                                  amount:(NSNumber *)amount
                                   token:(NSString *)token
                                 comment:(NSString *)comment;


//+ (BNPaymentParams *)paymentParamsWithCreditCard:(NSString *)identifier
//                                        currency:(NSString *)currency
//                                          amount:(NSNumber *)amount
//                                         comment:(NSString *)comment
//                                      creditCard:(BNCreditCard*)creditCard
//                                 isTokenRequired: (BOOL) isTokenRequired;


+ (BNPaymentParams *)mockObject;

@end
