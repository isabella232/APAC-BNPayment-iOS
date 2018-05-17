//
//  BNSecurityTests.m
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

@interface BNSecurityTests : XCTestCase

@end

@implementation BNSecurityTests {
    BNSecurity *_security;
    NSData *_invalidSelfSignedCertData;
    NSData *_validCertData;
    NSData *_validCACertData;
    NSData *_validExpiredCertData;
    SecTrustRef _invalidSelfSignedSecTrust;
    SecTrustRef _validSecTrust;
    SecTrustRef _validExpiredSecTrust;
    SecCertificateRef _validCertRef;
    SecCertificateRef _validExpiredCertRef;
    SecCertificateRef _invalidCertRef;
    SecCertificateRef _caCertRef;
}

- (void)setUp {
    [super setUp];
    
    _security = [BNSecurity new];

    NSString *invalidSelfSignedCertPath = [[NSBundle bundleForClass:[self class]]
                                                    pathForResource:@"invalidSelfSignedCert"
                                                             ofType:@"cer"];

    NSString *validCertPath = [[NSBundle bundleForClass:[self class]]
                                        pathForResource:@"validSelfSignedCert" ofType:@"cer"];
    
    NSString *validCaCertPath = [[NSBundle bundleForClass:[self class]]
                                          pathForResource:@"validCACert" ofType:@"cer"];
    
    NSString *validExpiredCertPath = [[NSBundle bundleForClass:[self class]]
                                               pathForResource:@"validExpiredSelfSignedCert" ofType:@"cer"];
    
    XCTAssertNotNil(invalidSelfSignedCertPath, "Invalid self signed cert not nil");
    XCTAssertNotNil(validCertPath, "Valid self signed cert not nil");
    XCTAssertNotNil(validCaCertPath, "Valid  CA cert not nil");
    XCTAssertNotNil(validExpiredCertPath, "Valid but expired self signed cert not nil");
    
    _invalidSelfSignedCertData = [NSData dataWithContentsOfFile:invalidSelfSignedCertPath];
    _validCertData = [NSData dataWithContentsOfFile:validCertPath];
    _validCACertData = [NSData dataWithContentsOfFile:validCaCertPath];
    _validExpiredCertData = [NSData dataWithContentsOfFile:validExpiredCertPath];
    
    XCTAssertNotNil(_invalidSelfSignedCertData, "Invalid self signed cert data not nil");
    XCTAssertNotNil(_validCertData, "Valid self signed cert data not nil");
    XCTAssertNotNil(_validCACertData, "Valid self signed CA cert data not nil");
    XCTAssertNotNil(_validExpiredCertData, "Valid but expired self signed data not nil");
    
    // Replace pinned certs for these tests.
    NSArray *overrideCerts = @[_validCACertData];
    [_security overridePinnedCerts:overrideCerts];
    
    SecPolicyRef secPolicy = SecPolicyCreateBasicX509();
    
    _caCertRef = SecCertificateCreateWithData(NULL, (__bridge CFDataRef)_validCACertData);
    _invalidCertRef = SecCertificateCreateWithData(NULL, (__bridge CFDataRef)_invalidSelfSignedCertData);
    _validCertRef = SecCertificateCreateWithData(NULL, (__bridge CFDataRef)_validCertData);
    _validExpiredCertRef = SecCertificateCreateWithData(NULL, (__bridge CFDataRef)_validExpiredCertData);
    
    SecTrustCreateWithCertificates(_invalidCertRef, secPolicy, &_invalidSelfSignedSecTrust);
    SecTrustCreateWithCertificates(_validCertRef, secPolicy, &_validSecTrust);
    SecTrustCreateWithCertificates(_validExpiredCertRef, secPolicy, &_validExpiredSecTrust);
}

//- (void)testValidCertificateWithCorrectDomain {
//
//    // When:
//    BOOL isServerTrusted = [_security evaluateServerTrust:_validSecTrust
//                                                forDomain:@"ironpoodle.zebragiraffe.net"];
//
//    // Then:
//    XCTAssertTrue(isServerTrusted, "Should accept a SecTrustRef that is signed by a pinned certificate and correct domain.");
//}
//
//- (void)testValidButExpiredCertificateWithCorrectDomain {
//
//    // When:
//    BOOL isServerTrusted = [_security evaluateServerTrust:_validExpiredSecTrust
//                                                forDomain:@"ironpoodle.zebragiraffe.net"];
//
//    // Then:
//    XCTAssertFalse(isServerTrusted, "Should not accept a SecTrustRef that is signed by an expired pinned certificate and correct domain.");
//}
//
//- (void)testValidCertificateWithIncorrectDomain {
//
//    // When:
//    BOOL isServerTrusted = [_security evaluateServerTrust:_validSecTrust forDomain:@"ironpoodle.zebragiraffe.com"];
//
//    // Then:
//    XCTAssertFalse(isServerTrusted, "Should not accept a SecTrustRef that is signed by a pinned certificate and incorrect domain.");
//}
//
//- (void)testInvalidCertificateWithCorrectDomain {
//
//    // When:
//    BOOL isServerTrusted = [_security evaluateServerTrust:_invalidSelfSignedSecTrust
//                                                forDomain:@"ironpoodle.zebragiraffe.net"];
//
//    // Then:
//    XCTAssertFalse(isServerTrusted, "Should not accept a SecTrustRef that is not signed by a pinned certificate and correct domain.");
//}
//
//- (void)testInvalidCertificateWithIncorrectDomain {
//
//    // When:
//    BOOL isServerTrusted = [_security evaluateServerTrust:_invalidSelfSignedSecTrust
//                                                forDomain:@"ironpoodle.zebragiraffe.com"];
//
//    // Then:
//    XCTAssertFalse(isServerTrusted, "Should not accept a SecTrustRef that is not signed by a pinned certificate and incorrect domain.");
//}
//
//- (void)testValidCertificateWithNilDomain {
//
//    // When:
//    BOOL isServerTrusted = [_security evaluateServerTrust:_validSecTrust
//                                                forDomain:nil];
//
//    // Then:
//    XCTAssertFalse(isServerTrusted, "Should not accept nil value for domain with valid cert.");
//}
//
//- (void)testNilCertificateWithCorrectDomain {
//
//    // When:
//    BOOL isServerTrusted = [_security evaluateServerTrust:nil
//                                                forDomain:@"ironpoodle.zebragiraffe.net"];
//
//    // Then:
//    XCTAssertFalse(isServerTrusted, "Should not accept nil value for SecTrustRef and correct domain.");
//}
//
//- (void)testNilCertWithNilDomain {
//
//    // When:
//    BOOL isServerTrusted = [_security evaluateServerTrust:nil
//                                                forDomain:nil];
//
//    // Then:
//    XCTAssertFalse(isServerTrusted, "Should not accept nil value for SecTrust and domain.");
//}
//
//- (void)testDefaultCertificateOvveride {
//
//    // Given
//    NSArray *overrideCerts = @[_validCertData];
//
//    // When:
//    [_security overridePinnedCerts:overrideCerts];
//    BOOL isServerTrusted = [_security evaluateServerTrust:_validSecTrust
//                                                forDomain:@"ironpoodle.zebragiraffe.net"];
//
//    // Then:
//    XCTAssertTrue(isServerTrusted, "Should be able to ovveride default pinned certificates.");
//
//    /********/
//
//    // Given:
//    overrideCerts = @[_invalidSelfSignedCertData];
//
//    // When:
//    [_security overridePinnedCerts:overrideCerts];
//    isServerTrusted = [_security evaluateServerTrust:_validSecTrust
//                                           forDomain:@"ironpoodle.zebragiraffe.net"];
//
//    // Then
//    XCTAssertFalse(isServerTrusted, "Should be able to ovveride default pinned certificates.");
//
//    /********/
//
//    // If:
//    overrideCerts = @[_validCertData];
//
//    // When:
//    [_security overridePinnedCerts:overrideCerts];
//    isServerTrusted = [_security evaluateServerTrust:_validSecTrust
//                                           forDomain:@"ironpoodle.zebragiraffe.net"];
//
//    // Then:
//    XCTAssertTrue(isServerTrusted, "Should be able to ovveride default pinned certificates.");
//}
//
//- (void)testMasterCertificateValidationWithValidCert {
//
//    // When:
//    BOOL isValidCert = [BNSecurity evaluateCert:_validCertRef
//                                     masterCert:_caCertRef];
//
//    // Then:
//    XCTAssertTrue(isValidCert, "Should accept a certificate signed by CA.");
//}
//
//- (void)testMasterCertificateValidationWithValidExpiredCert {
//
//    // When:
//    BOOL isValidCert = [BNSecurity evaluateCert:_validExpiredCertRef
//                                     masterCert:_caCertRef];
//
//    // Then:
//    XCTAssertFalse(isValidCert, "Should not accept expired certificate signed by CA.");
//}
//
//- (void)testMasterCertificateValidationWithInvalidCert {
//
//    // When:
//    BOOL isValidCert = [BNSecurity evaluateCert:_invalidCertRef
//                                     masterCert:_caCertRef];
//
//    // Then:
//    XCTAssertFalse(isValidCert, "Should not accept a certificate which is not signed by CA.");
//}
//
//- (void)testMasterCertificateValidationWithoutCertificate {
//
//    // When:
//    BOOL isValidCert = [BNSecurity evaluateCert:nil
//                                     masterCert:_caCertRef];
//
//    // Then:
//    XCTAssertFalse(isValidCert, "Should not accept the fact that no certificate has been provided.");
//}

- (void)tearDown {
    [super tearDown];

    _security = nil;
    CFRelease(_invalidSelfSignedSecTrust);
    CFRelease(_validSecTrust);
    CFRelease(_validExpiredSecTrust);
}

@end
