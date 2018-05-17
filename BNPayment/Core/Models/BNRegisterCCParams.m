//
//  BNRegisterCCParams.m
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

#import "BNRegisterCCParams.h"
#import "BNCreditCard.h"
#import "BNCrypto.h"
#import "BNCertManager.h"
#import "BNEncryptionCertificate.h"
#import "BNEncryptedSessionKey.h"

const NSInteger BNRegisterCCParamsKeyLength = 16;

@interface BNRegisterCCParams ()

@property  BNCreditCard *cardDetails;
@property  NSArray<BNEncryptedSessionKey *> *encryptedSessionKeys;
@property  NSString *binNumber;

@end

@implementation BNRegisterCCParams

+ (NSDictionary *)JSONMappingDictionary {
    return @{
             @"cardDetails" : @"encryptedCard",
             @"binNumber" : @"binNumber",
             @"encryptedSessionKeys" : @"encryptedSessionKeys"
             };
}

- (instancetype)initWithCreditCard:(BNCreditCard *)creditCard {
    self = [super init];
    NSData *sessionKey = [BNCrypto generateRandomKey:BNRegisterCCParamsKeyLength];
    if(self && sessionKey && (sessionKey.length == BNRegisterCCParamsKeyLength)) {
        self.cardDetails = creditCard;
        [self generateParamsWithSessionKey:sessionKey];
    }
    return self;
}

- (void)generateParamsWithSessionKey:(NSData*)sessionKey {

    if(self.cardDetails.cardNumber.length >= 6) {
        self.binNumber = [self.cardDetails.cardNumber substringWithRange:NSMakeRange(0, 6)];
    }
    
    self.cardDetails = [self.cardDetails encryptedCreditCardWithSessionKey:sessionKey];
    
    NSArray *encryptionCertificates = [[BNCertManager sharedInstance] getEncryptionCertificates];
    NSMutableArray *encryptedSessionKeys = [NSMutableArray new];
    
    for(BNEncryptionCertificate *cert in encryptionCertificates) {
        if([cert isKindOfClass:[BNEncryptionCertificate class]] && cert.base64Representation) {
            BNEncryptedSessionKey *encryptedSessionKey = [BNEncryptedSessionKey new];
            encryptedSessionKey.sessionKey = [cert encryptSessionKey:sessionKey];
            encryptedSessionKey.fingerprint = [cert.fingerprint uppercaseString];
            [encryptedSessionKeys addObject:encryptedSessionKey];
        }
    }
    
    self.encryptedSessionKeys = encryptedSessionKeys;
}




//[[oz]]
- (NSDictionary *)JSONDictionary {
    NSDictionary* dict = [super JSONDictionary];
    
    if (BNRegisterCCParams.registrationJsonData != nil){
        NSMutableDictionary *mdict = [NSMutableDictionary dictionaryWithDictionary:dict];
        [mdict setObject:BNRegisterCCParams.registrationJsonData forKey:@"registrationJsonData"];
        dict = mdict;
    }
    return dict;
}

static NSDictionary* _registrationJsonData;
+ (NSDictionary*) registrationJsonData
{
    @synchronized(self) {
        return _registrationJsonData; }
}

+ (void) setRegistrationJsonData:(NSDictionary*) data
{
 
    @synchronized(self) { _registrationJsonData = data; }
}
@end
