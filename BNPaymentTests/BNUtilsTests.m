//
//  BNUtilsTests.m
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

@interface BNUtilsTests : XCTestCase

@end

@implementation BNUtilsTests

- (void)testGenerateSHA256HMAC {

    // Given:
    NSString *correctHMAC = @"f7bc83f430538424b13298e6aa6fb143ef4d59a14946175997479dbc2d1a3cd8";
    NSString *data = @"The quick brown fox jumps over the lazy dog";
    NSString *key = @"key";

    // When:
    NSString *HMAC = [BNUtils sha256HMAC:data key:key];

    // Then:
    XCTAssertEqualObjects(correctHMAC, HMAC, "The manually added HMAC (correctHMAC) should equal the HMAC generated through the BNUtils class (HMAC).");

}

- (void)testGenerateSHA256HMACUsingNil {
    // When:
    NSString *resultFromsha256HMAC = [BNUtils sha256HMAC:nil key:nil];

    // Then:
    XCTAssert([resultFromsha256HMAC isEqualToString:@""], "The variable resultFromsha256HMAC should contain an empty string.");
}

- (void)testsha1 {

    // Given:
    NSString *expectedFingerprint = @"233D86121459A53CB60BE33852EA7F18C117990A";
    NSString *certificatePath = [[NSBundle bundleForClass:self.class] pathForResource:@"iosTestCert" ofType:@"pem"];

    // When:
    NSError *error;
    NSString *certificateString = [NSString stringWithContentsOfFile:certificatePath encoding:NSUTF8StringEncoding error:&error];
    NSData *certificateData = [certificateString getCertData];
    BNEncryptionCertificate *certificate = [BNEncryptionCertificate new];
    certificate.base64Representation = [certificateData base64EncodedStringWithOptions:0];
    certificate.fingerprint = [[BNUtils sha1:certificateData] uppercaseString];

    // Then:
    XCTAssert([certificate.fingerprint isEqualToString:expectedFingerprint], @"certificate.fingerprint should be equal to expectedFingerprint.");

}

- (void)testColorFromHexString {
    
    NSString *testValue = @"#FFFFFF";
    UIColor *returnColor=[BNUtils colorFromHexString:testValue];
    XCTAssert(returnColor=UIColor.whiteColor, "The variable resultFromsha256HMAC should contain an empty string.");
}

@end
