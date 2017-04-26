//
//  BNCreditCardTests.m
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

@interface BNCreditCardTests : XCTestCase

@property NSData *key;
@property BNCreditCard *encryptedCreditCard;
@property BNCreditCard *cardToEncrypt;

@end

@implementation BNCreditCardTests

static const int KEY_LENGTH = 16;

- (void)setUp {
    [super setUp];
    
    uint8_t key[KEY_LENGTH] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16};
    self.key = [NSData dataWithBytes:key length:sizeof(key)];
    
    self.encryptedCreditCard = [BNCreditCard new];
    self.encryptedCreditCard.cardNumber = @"NXU/WqdgRAtAkXHnRiZ5xqmosqJhCFDiAgacb+GbS68=";
    self.encryptedCreditCard.expMonth = @"UbiBOe/QNlUpavS0KhOVkQ==";
    self.encryptedCreditCard.expYear = @"YycsTWZvdnqKyKqscPYTZw==";
    self.encryptedCreditCard.cvv = @"wrp0KdVqXRv6U4CAGtkorw==";
    
    self.cardToEncrypt = [BNCreditCard new];
    self.cardToEncrypt.cardNumber = @"4002620000000005";
    self.cardToEncrypt.expMonth = @"10";
    self.cardToEncrypt.expYear = @"20";
    self.cardToEncrypt.cvv = @"000";
    
}

- (void)testEncryptCreditCard {
    
    // When:
    BNCreditCard *encryptedCard = [self.cardToEncrypt encryptedCreditCardWithSessionKey:self.key];
    
    // Then:    
    XCTAssertEqualObjects(self.encryptedCreditCard, encryptedCard, @"The pre-existing encrypted credit card object (self.encryptedCreditCard) should be equal to the credit card object that is created in this test (encryptedCard).");
}

- (void)tearDown {
    [super tearDown];
}


@end
