//
//  BNApplePayPaymentParams.m
//  BNPayment
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

#import "BNApplePayPaymentParams.h"


@interface BNApplePayPaymentParams () {
   //  NSDictionary* _applePayPaymentJsonData;
}
@end

@implementation BNApplePayPaymentParams

+ (NSDictionary *)JSONMappingDictionary {
    return @{
             @"paymentIdentifier" : @"paymentIdentifier",
             @"currency" : @"currency",
             @"amount" : @"amount",
             @"paymentData" : @"paymentData",
             @"comment" : @"comment"
             };
}

+ (BNApplePayPaymentParams *)paymentParamsWithId:(NSString *)identifier
                                        currency:(NSString *)currency
                                          amount:(NSNumber *)amount
                                           paymentData:(NSDictionary *)paymentData
                                         comment:(NSString *)comment {
    BNApplePayPaymentParams *params = [BNApplePayPaymentParams new];
    
    params.paymentIdentifier = identifier;
    params.currency = currency;
    params.amount = amount;
    
    params.paymentData = paymentData;
    params.comment = comment;
    
    return params;
}

+ (BNApplePayPaymentParams *)mockObject {
    BNApplePayPaymentParams *mockObject = [BNApplePayPaymentParams new];
    mockObject.paymentIdentifier = [NSString stringWithFormat:@"%u", arc4random_uniform(INT_MAX)];
    mockObject.currency = @"AUD";
    NSDictionary * data =   @{@"username":@"api.dev",
                              @"password":@"",
                              @"applePayMerchantID":@"merchant.com.ippayments.winkwink"};
    
    mockObject.amount = @100;
    //mockObject.token = @"58133813560350721";
    mockObject.comment = @"Mocked comment";
    
    [mockObject setApplePayPaymentJsonData: data];
    return mockObject;
}

NSDictionary* _applePayPaymentJsonData;
//[[oz]]
- (NSDictionary *)JSONDictionary {
    NSDictionary* dict = [super JSONDictionary];
    
    if (self.applePayPaymentJsonData != nil){
        NSMutableDictionary *mdict = [NSMutableDictionary dictionaryWithDictionary:dict];
        [mdict setObject:self.applePayPaymentJsonData forKey:@"applePayPaymentJsonData"];
        dict = mdict;
    }
    
    return dict;
}


- (NSDictionary*) applePayPaymentJsonData
{
    return _applePayPaymentJsonData;
}

- (void) setApplePayPaymentJsonData:(NSDictionary*) data
{
    //[[oz]] TODO validate?
    _applePayPaymentJsonData = data;
}

@end
