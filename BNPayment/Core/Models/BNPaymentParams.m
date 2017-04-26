//
//  BNPayment.m
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

#import "BNPaymentParams.h"


@interface BNPaymentParams () {
    NSDictionary* _paymentJsonData;
}
@end


@implementation BNPaymentParams

+ (NSDictionary *)JSONMappingDictionary {
    return @{
             @"paymentIdentifier" : @"paymentIdentifier",
             @"currency" : @"currency",
             @"amount" : @"amount",
             @"token" : @"token",
             @"comment" : @"comment"
             };
}

+ (BNPaymentParams *)paymentParamsWithId:(NSString *)identifier
                                currency:(NSString *)currency
                                  amount:(NSNumber *)amount
                                   token:(NSString *)token
                                 comment:(NSString *)comment {
    BNPaymentParams *params = [BNPaymentParams new];
    
    params.paymentIdentifier = identifier;
    params.currency = currency;
    params.amount = amount;
    params.token = token;
    params.comment = comment;
    
    return params;
}

+ (BNPaymentParams *)mockObject {
    BNPaymentParams *mockObject = [BNPaymentParams new];
    mockObject.paymentIdentifier = [NSString stringWithFormat:@"%u", arc4random_uniform(INT_MAX)];
    mockObject.currency = @"AUD";
    mockObject.amount = @100;
    mockObject.token = @"58133813560350721";
    mockObject.comment = @"Mocked comment";
    return mockObject;
}

- (NSDictionary *)JSONDictionary {
    NSDictionary* dict = [super JSONDictionary];
    
    if (self.paymentJsonData != nil){
        NSMutableDictionary *mdict = [NSMutableDictionary dictionaryWithDictionary:dict];
        [mdict setObject:self.paymentJsonData forKey:@"paymentJsonData"];
        dict = mdict;
    }
    
    return dict;
}

- (NSDictionary*) paymentJsonData
{
    return _paymentJsonData;
}

- (void) setPaymentJsonData:(NSDictionary*) data
{
    //[[oz]] TODO validate?
    _paymentJsonData = data;
}

@end
