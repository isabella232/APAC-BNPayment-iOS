//
//  BPSNSString+BPSCryptoTests.m
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

@interface NSStringBNCryptoTests : XCTestCase

@property NSData *key;
@property NSString *stringToEncrypt;

@end

@implementation NSStringBNCryptoTests

static const int KEY_LENGTH = 16;

- (void)setUp {
    [super setUp];
    
    uint8_t key[KEY_LENGTH] = {75, -103, 104, 23, 57, -105, 34, -21, 67, 31, -59, -63, -38, 109, -117, 40};
    self.key = [NSData dataWithBytes:key length:sizeof(key)];
    self.stringToEncrypt = @"4002620000000005";
}

- (void)testEncryptAndDecryptUsingAES128 {

    // When:
    NSString *encryptedString = [self.stringToEncrypt AES128EncryptWithKey:self.key];
    
    // Then:
    XCTAssertNotEqualObjects(self.stringToEncrypt, encryptedString, "The unencrypted value (self.stringToEncrypt) should not be equal to the encrypted value (encryptedString).");
    
    // When:
    NSString *decryptedString = [encryptedString AES128DecryptWithKey:self.key];
   
    // Then:
    XCTAssertEqualObjects(self.stringToEncrypt, decryptedString, "The unencrypted value (self.stringToEncrypt) should be equal to the decrypted value (decryptedString).");
}


- (void)testAES128EncryptWithKeyNegativeTest {
    // When:
    NSString *encryptedString = [self.stringToEncrypt AES128EncryptWithKey:nil];
    
    // Then:
    XCTAssertNil(encryptedString);
}


- (void)testAES128DecryptWithKeyNegativeTest {
    // When:
    NSString *decryptedString = [self.stringToEncrypt AES128DecryptWithKey:nil];
    
    // Then:
    XCTAssertNil(decryptedString);
}

@end