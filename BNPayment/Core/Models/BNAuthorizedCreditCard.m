//
//  BNTokenizedCreditCard.m
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

#import "BNAuthorizedCreditCard.h"
#import "BNPaymentParams.h"

@implementation BNAuthorizedCreditCard

+ (NSDictionary *)JSONMappingDictionary {
    return @{
             @"creditCardHolder" :      @"cardHolderName",
             @"creditCardAlias" :       @"cardAlias",
             @"creditCardNumber" :      @"cardNumber",
             @"creditCardToken" :       @"recurringPaymentID",
             @"creditCardType" :        @"cardType",
             @"creditCardExpiryMonth" : @"expiryMonth",
             @"creditCardExpiryYear" :  @"expiryYear"
             };
}

- (BNPaymentParams *)paymentParamsWithId:(NSString *)identifier
                                currency:(NSString *)currency
                                  amount:(NSNumber *)amount
                                 comment:(NSString *)comment {
    
    return [BNPaymentParams paymentParamsWithId:identifier
                                       currency:currency
                                         amount:amount
                                          token:self.creditCardToken
                                        comment:comment];
}

- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;
    if (!other || ![other isKindOfClass:[self class]])
        return NO;
    return [self isEqualToAuthorizedCard:other];
}

- (BOOL)isEqualToAuthorizedCard:(BNAuthorizedCreditCard *)authorizedCard {
    if (!authorizedCard || ![authorizedCard isKindOfClass:[self class]]) {
        return NO;
    }
    
    return self == authorizedCard || [self.creditCardToken isEqualToString:authorizedCard.creditCardToken];
}

- (NSUInteger)hash {
    return [super hash];
}

@end
