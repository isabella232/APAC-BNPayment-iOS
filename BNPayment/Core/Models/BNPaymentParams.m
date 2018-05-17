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
#import "BNCrypto.h"
#import "BNCertManager.h"
#import "BNEncryptionCertificate.h"
#import "BNEncryptedSessionKey.h"
#import "BNPaymentType.h"

const NSInteger BNPaymentCCParamsKeyLength = 16;

@interface BNPaymentParams () {
    NSDictionary* _paymentJsonData;
    NSDictionary* _cardJsonData;
}
@end


@implementation BNPaymentParams

+ (NSDictionary *)JSONMappingDictionary {
    return @{
             @"paymentValidation" : @"paymentValidation",
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
                                 comment:(NSString *)comment
{
    BNPaymentParams *params = [BNPaymentParams new];
    
    params.paymentIdentifier = identifier;
    params.currency = currency;
    params.amount = amount;
    params.token = token;
    params.comment = comment;
    params.paymentValidation = @"none";
    
    return params;
}


//+ (BNPaymentParams *)paymentParamsWithCreditCard:(NSString *)identifier
//                                currency:(NSString*)currency
//                                  amount:(NSNumber*)amount
//                                 comment:(NSString*)comment
//                              creditCard:(BNCreditCard*)creditCard
//                         isTokenRequired:(BOOL)isTokenRequired
//{
//    BNPaymentParams *params = [BNPaymentParams new];
//
//    params.paymentIdentifier = identifier;
//    params.currency = currency;
//    params.amount = amount;
//    params.comment = comment;
//    params.paymentValidation = @"none";
//    [params SetCreditCardJsonData:creditCard isTokenRequired: isTokenRequired];
//    return params;
//}

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
    
    if (self.cardJsonData != nil){
        NSMutableDictionary *mdict = [NSMutableDictionary dictionaryWithDictionary:dict];
        [mdict setObject:self.cardJsonData forKey:@"cardJsonData"];
        dict = mdict;
    }
    
    return dict;
}

- (void)SetCreditCardJsonData: (BNCreditCard*) creditCard
              isTokenRequired: (BOOL) isTokenRequired{
    NSData *sessionKey = [BNCrypto generateRandomKey:BNPaymentCCParamsKeyLength];
    creditCard = [creditCard encryptedCreditCardWithSessionKey:sessionKey];
    NSArray *encryptionCertificates = [[BNCertManager sharedInstance] getEncryptionCertificates];
    NSString *encryptedSessionKey;
    for(BNEncryptionCertificate *cert in encryptionCertificates) {
        if([cert isKindOfClass:[BNEncryptionCertificate class]] && cert.base64Representation) {
            encryptedSessionKey = [cert encryptSessionKey:sessionKey];
            break;
        }
    }
    NSDictionary *jsonCardInfo = @{
                                   @"cardholderName": creditCard.holderName,
                                   @"cardNumber":creditCard.cardNumber,
                                   @"expiryMonth":creditCard.expMonth,
                                   @"expiryYear":creditCard.expYear,
                                   @"cvcCode":creditCard.cvv==nil? @"": creditCard.cvv,
                                   @"istokenrequested": isTokenRequired? @"true":@"false",
                                   @"sessionKey" : encryptedSessionKey
                                   };
    _cardJsonData = jsonCardInfo;
}


- (NSDictionary*) paymentJsonData
{
    return _paymentJsonData;
}

- (void) setPaymentJsonData:(NSDictionary*) data
{
    _paymentJsonData = data;
}


- (NSDictionary*) cardJsonData
{
    return _cardJsonData;
}

- (void) setCardJsonData:(NSDictionary*) data
{
      _cardJsonData = data;
}


@end
