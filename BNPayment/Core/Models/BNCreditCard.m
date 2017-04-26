//
//  BNCreditCard.m
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

#import "BNCreditCard.h"
#import "NSString+BNCrypto.h"

@implementation BNCreditCard

+ (NSDictionary *)JSONMappingDictionary {
    return @{
             @"alias" : @"alias",
             @"cardNumber" : @"cardNumber",
             @"expMonth" : @"expiryMonth",
             @"expYear" : @"expiryYear",
             @"cvv" : @"cvcCode",
             @"holderName" : @"cardholderName",
             };
}

- (BNCreditCard *)encryptedCreditCardWithSessionKey:(NSData *)sessionKey {
    BNCreditCard *encryptedCreditCard = [BNCreditCard new];
    
    encryptedCreditCard.alias = self.alias;
    encryptedCreditCard.cardNumber = [self.cardNumber AES128EncryptWithKey:sessionKey];
    encryptedCreditCard.expMonth = [self.expMonth AES128EncryptWithKey:sessionKey];
    encryptedCreditCard.expYear = [self.expYear AES128EncryptWithKey:sessionKey];
    encryptedCreditCard.cvv = [self.cvv AES128EncryptWithKey:sessionKey];
    encryptedCreditCard.holderName = [self.holderName AES128EncryptWithKey:sessionKey];
    
    return encryptedCreditCard;
}

@end
