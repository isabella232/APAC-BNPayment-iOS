//
//  BNCryptoTests.m
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

@interface BNCryptoTests : XCTestCase

@end

@implementation BNCryptoTests {
    SecKeyRef publicKey;
    SecKeyRef privateKey;
}

- (void)setUp {
    [super setUp];
    publicKey = [BNKeyUtils getPublicKeyRefForCerFile:@"iosTestCert"
                                              bundle:[NSBundle bundleForClass:self.class]];
    privateKey = [BNKeyUtils getPrivateKeyRefForFile:@"iOSTestPrivKey"
                                                bundle:[NSBundle bundleForClass:self.class]
                                          withPassword:@"1234"];
}

- (void)testRSAEncryptionAndDecryption {

    // Given:
    NSString *stringToEncrypt = @"String to encrypt/decrypt";
    
    // When:
    NSData *dataToEncrypt = [stringToEncrypt dataUsingEncoding:NSUTF8StringEncoding];
    NSData *encryptedData = [BNCrypto RSAEncryptData:dataToEncrypt
                                                 key:publicKey];

    // Then:
    XCTAssertNotNil(encryptedData, "The encryptedData object should not be nil.");
    
    // When:
    NSData *decryptedData = [BNCrypto RSADecryptData:encryptedData
                                                 key:privateKey];
    NSString *decryptedString = [[NSString alloc] initWithData:decryptedData
                                                      encoding:NSUTF8StringEncoding];
    
    // Then:
    XCTAssertNotNil(decryptedString, "The decryptedString object should not be nil.");
    XCTAssertEqualObjects(stringToEncrypt, decryptedString, "The unencrypted string (stringToEncrypt) should be equal to the decrypted string (decryptedString).");
}

- (void)testRSADecryption {
    
    // Given:
    NSString *correctString = @"String to encrypt/decrypt";
    NSString *encryptedString = @"orPx4HBrFeHS62Vksi9dNdi+YvoDnrRbxYggN4HF8bsIRaAEYW2MEJKANyBzxFrpSXNdl5J/Ky90pbAE2i9m64IbaPq06OzxCy3YfcEMTgmAts6bdAJEGn65ShRiKZohGYQ/lQnJs0970Ge3su25cmVwpS9LCsilBJIdiWt1YWQUIF8IQfBEKaWp/LmXFbgnyIhte3KJu7BLlMdKTrZOuR6qvDXMSMv4qQDXTJD10sckfauXZBaElq9Q6IjOq38dvDp4UZScCvfAoDWAxZX/IoiktDnxKDW1IsMiBDkcbccFin7UKoLGcDFWf99u49GE3I2llH059HP823FnkCWuy56yNvdJOoK+RoyahWVebLlsW/VZx0FgE7u0Qs7kFVFS1yrypoBra7xXy2/P9+KkSw5fvJizN0mh9PkxHUEpsMFJxgcKm9vSkPWDV9rxOK+90neAT66xufOdA+nFjZPvmtJnZXJcVaGYd0hWJMpWWd4kWcNWAUhu7sBa7po0IMOfMMHAS22O0lDpWKvS/lzOLcVgrl3fm4cxQd4NOVbSFbkrYAj/QaZWTum16Jt8hgtMEKfA1ccCDT7cRvsX0PCbHVWEID1R6pPdkZkddc+m2QUR0yxsQDtgs2EZsD8AMW+9UJ/7WWh0EZlr+T3YrCkz74ImywXqJblDMXHkA1+mvXE="; // Base64 encoded string
    
    // When:
    NSData *encryptedData = [[NSData alloc] initWithBase64EncodedString:encryptedString
                                                                options:0];
    
    NSData *decryptedData = [BNCrypto RSADecryptData:encryptedData
                                                 key:privateKey];
    
    NSString *decryptedString = [[NSString alloc] initWithData:decryptedData
                                                      encoding:NSUTF8StringEncoding];
    
    // Then:
    XCTAssertEqualObjects(correctString, decryptedString, "The unencrypted string (correctString) should be equal to the decrypted string (decryptedString).");
}

- (void)testRSADecryptDataNegativeTest {
    NSData *decryptedData = [BNCrypto RSADecryptData:nil key:nil];

    XCTAssertNil(decryptedData, "The decryptedData object should be nil.");
}

- (void)tearDown {
    CFRelease(publicKey);
    CFRelease(privateKey);
    [super tearDown];
}

@end