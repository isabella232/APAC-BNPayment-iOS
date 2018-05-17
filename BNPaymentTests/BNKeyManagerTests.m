//
//  BNKeyManagerTests.m
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

@interface BNKeyManagerTests : XCTestCase

@end

@implementation BNKeyManagerTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testGetPublicKey {

    // When:
    SecKeyRef publicKey = [BNKeyUtils getPublicKeyRefForCerFile:@"iosTestCert"
                                                         bundle:[NSBundle bundleForClass:self.class]];
    // Then:
    XCTAssertTrue(publicKey != nil, "The publicKey variable should not be nil.");
}

- (void)testGetPublicKeyWithInvalidFile{
    
    // When:
    SecKeyRef publicKey = [BNKeyUtils getPublicKeyRefForCerFile:@"iosTestCert1"
                                                         bundle:[NSBundle bundleForClass:self.class]];
    // Then:
    XCTAssertTrue(publicKey == nil, "The publicKey variable should be nil.");
}

- (void)testGetPublicKeyFromPem {

    // When:
    SecKeyRef publicKey = [BNKeyUtils getPublicKeyRefForPemFile:@"iosTestCert"
                                                         bundle:[NSBundle bundleForClass:self.class]];
    // Then:
    XCTAssertTrue(publicKey != nil, "The publicKey variable should not be nil.");
}

- (void)testGetPublicKeyFromPemWithInvalidFile {
    
    // When:
    SecKeyRef publicKey = [BNKeyUtils getPublicKeyRefForPemFile:@"iosTestCert1"
                                                         bundle:[NSBundle bundleForClass:self.class]];
    // Then:
    XCTAssertTrue(publicKey == nil, "The publicKey variable should be nil.");
}

- (void)testGetPrivateKey {

    // When:
    SecKeyRef privateKey = [BNKeyUtils getPrivateKeyRefForFile:@"iOSTestPrivKey"
                                                          bundle:[NSBundle bundleForClass:self.class]
                                                    withPassword:@"1234"];
    // Then:
    XCTAssertTrue(privateKey != nil, "The privateKey variable should not be nil.");
}

- (void)testGetPrivateKeyWithInvalidPassword {
    
    // When:
    SecKeyRef privateKey = [BNKeyUtils getPrivateKeyRefForFile:@"iOSTestPrivKey"
                                                        bundle:[NSBundle bundleForClass:self.class]
                                                  withPassword:@"12345"];
    // Then:
    XCTAssertTrue(privateKey == nil, "The privateKey variable should be nil.");
}

@end
