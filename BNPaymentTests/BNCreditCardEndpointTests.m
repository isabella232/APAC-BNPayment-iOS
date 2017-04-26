//
//  BNCreditCardEndpointTests.m
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

@interface BNCreditCardEndpointTests : XCTestCase

@property NSString *fileName;
@property int statusCode;

@end

@implementation BNCreditCardEndpointTests

+ (void)setUp {
    [super setUp];
    
    [OHHTTPStubs setEnabled:YES];
    
    NSError *error;
    [BNPaymentHandler setupWithApiToken:@"T000000000"
                                baseUrl:nil
                                  debug:YES error:&error];
}

- (void)setUp {
    [super setUp];

    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return YES;
    } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
        NSString *filePath = OHPathForFile(self.fileName, self.class);
        OHHTTPStubsResponse *response = [OHHTTPStubsResponse responseWithFileAtPath:filePath
                                                                         statusCode:self.statusCode
                                                                            headers:@{@"Content-Type":@"application/json"}];
        return response;
    }];
}

- (void)testHPPSuccessfulResponse {
    
    // Given:
    self.fileName = @"hppSuccess.json";
    self.statusCode = 200;
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Credit card endpoint test"];
    
    // When:
    NSURLSessionDataTask *task = [BNCreditCardEndpoint initiateCreditCardRegistrationForm:[BNCCHostedFormParams mockObject]
                                                                               completion:^(NSString *url, NSError *error) {
        // Then:
        XCTAssertTrue([url isKindOfClass:[NSString class]], "The class type of the url variable should be NSString.");
        XCTAssertNil(error, "The error variable should be nil.");
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:task.originalRequest.timeoutInterval
                                 handler:^(NSError *error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        }
        [task cancel];
    }];
}

- (void)testHPPSuccessfulResponseExtraParams {
    
    // Given:
    self.fileName = @"hppExtraParams.json";
    self.statusCode = 200;
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Credit card endpoint test"];
    
    // When:
    NSURLSessionDataTask *task = [BNCreditCardEndpoint initiateCreditCardRegistrationForm:[BNCCHostedFormParams mockObject]
                                                                               completion:^(NSString *url, NSError *error) {
        // Then:
        XCTAssertTrue([url isKindOfClass:[NSString class]], "The class type of the url variable should be NSString.");
        XCTAssertNil(error, "The error variable should be nil.");
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:task.originalRequest.timeoutInterval
                                 handler:^(NSError *error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        }
        [task cancel];
    }];
}

- (void)testHPP400Response {
    
    // Given:
    self.fileName = @"hppSuccess.json";
    self.statusCode = 400;
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Credit card endpoint test"];
    
    // When:
    NSURLSessionDataTask *task = [BNCreditCardEndpoint initiateCreditCardRegistrationForm:[BNCCHostedFormParams mockObject]
                                                                               completion:^(NSString *url, NSError *error) {
        // Then:
        XCTAssertNil(url, "The url variable should be nil.");
        XCTAssertNotNil(error, "The error variable should not be nil.");
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:task.originalRequest.timeoutInterval
                                 handler:^(NSError *error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        }
        [task cancel];
    }];
}

- (void)testHPP500Response {

    // Given:
    self.fileName = @"hppSuccess.json";
    self.statusCode = 500;
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Credit card endpoint test"];
    
    // When:
    NSURLSessionDataTask *task = [BNCreditCardEndpoint initiateCreditCardRegistrationForm:[BNCCHostedFormParams mockObject]
                                                                               completion:^(NSString *url, NSError *error) {
        
        // Then:
        XCTAssertNil(url, "The url variable should be nil.");
        XCTAssertNotNil(error, "The error variable should not be nil.");
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:task.originalRequest.timeoutInterval
                                 handler:^(NSError *error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        }
        [task cancel];
    }];
}

- (void)testNativeCCSuccessfulResponse {
    
    // Given:
    self.fileName = @"nativeCCSuccess.json";
    self.statusCode = 200;
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Credit card endpoint test"];
    
    // When:
    NSURLSessionDataTask *task = [BNCreditCardEndpoint registerCreditCard:nil
                                                               completion:^(BNAuthorizedCreditCard *card, NSError *error) {
        
        // Then:
        XCTAssertTrue([card isKindOfClass:[BNAuthorizedCreditCard class]], "The class type of the card variable should be BNAuthorizedCreditCard.");
        XCTAssertNil(error, "The error variable should be nil.");
        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:task.originalRequest.timeoutInterval
                                 handler:^(NSError *error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        }
        [task cancel];
    }];
}

- (void)testNativeCCSuccessfulResponseExtraParams {
    
    // Given:
    self.fileName = @"nativeCCSuccessExtraParams.json";
    self.statusCode = 200;
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Credit card endpoint test"];
    
    // When:
    NSURLSessionDataTask *task = [BNCreditCardEndpoint registerCreditCard:nil
                                                               completion:^(BNAuthorizedCreditCard *card, NSError *error) {
        
        // Then:
        XCTAssertTrue([card isKindOfClass:[BNAuthorizedCreditCard class]], "The class type of the card variable should be BNAuthorizedCreditCard.");
        XCTAssertNil(error, "The error variable should be nil.");
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:task.originalRequest.timeoutInterval
                                 handler:^(NSError *error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        }
        [task cancel];
    }];
}

- (void)testNativeCC400Response {
    
    // Given:
    self.fileName = @"nativeCCSuccess.json";
    self.statusCode = 400;
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Credit card endpoint test"];
    
    // When:
    NSURLSessionDataTask *task = [BNCreditCardEndpoint registerCreditCard:nil
                                                               completion:^(BNAuthorizedCreditCard *card, NSError *error) {
        
        // Then:
        XCTAssertNil(card, "The card variable should be nil.");
        XCTAssertNotNil(error, "The error variable should not be nil.");
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:task.originalRequest.timeoutInterval handler:^(NSError *error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        }
        [task cancel];
    }];
}

- (void)testNativeCC500Response {
    
    // Given:
    self.fileName = @"nativeCCSuccess.json";
    self.statusCode = 500;
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Credit card endpoint test"];
    
    // When:
    NSURLSessionDataTask *task = [BNCreditCardEndpoint registerCreditCard:nil
                                                               completion:^(BNAuthorizedCreditCard *card, NSError *error) {
        
        // Then:
        XCTAssertNil(card, "The card variable should be nil.");
        XCTAssertNotNil(error, "The error variable should not be nil.");
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:task.originalRequest.timeoutInterval
                                 handler:^(NSError *error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        }
        [task cancel];
    }];
}

- (void)testEncryptionCertificatesSuccessfulResponse {
    
    // Given:
    self.fileName = @"encryptionCertificatesSuccess.json";
    self.statusCode = 200;
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Encryption certificates endpoint test"];
    
    // When:
    NSURLSessionDataTask *task = [BNCreditCardEndpoint encryptionCertificatesWithCompletion:^(NSArray<BNEncryptionCertificate *> *encryptionCertificates, NSError *error) {
        
        // Then:
        XCTAssertTrue([encryptionCertificates isKindOfClass:[NSArray class]], "The class type of the encryptionCertificates variable should be NSArray.");
        XCTAssertNil(error, "The error variable should be nil.");
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:task.originalRequest.timeoutInterval
                                 handler:^(NSError *error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        }
        [task cancel];
    }];
}

- (void)testEncryptionCertificatesSuccessfulResponseExtraParams {
    
    // Given:
    self.fileName = @"encryptionCertificatesSuccessExtraParams.json";
    self.statusCode = 200;
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Encryption certificates endpoint test"];
    
    // When:
    NSURLSessionDataTask *task = [BNCreditCardEndpoint encryptionCertificatesWithCompletion:^(NSArray<BNEncryptionCertificate *> *encryptionCertificates, NSError *error) {
        
        // Then:
        XCTAssertTrue([encryptionCertificates isKindOfClass:[NSArray class]], "The class type of the encryptionCertificates variable should be NSArray.");
        XCTAssertNil(error, "The error variable should not be nil.");
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:task.originalRequest.timeoutInterval
                                 handler:^(NSError *error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        }
        [task cancel];
    }];
}

- (void)testEncryptionCertificates400Response {
    
    // Given:
    self.fileName = @"encryptionCertificatesSuccess.json";
    self.statusCode = 400;
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Credit card endpoint test"];
    
    // When:
    NSURLSessionDataTask *task = [BNCreditCardEndpoint encryptionCertificatesWithCompletion:^(NSArray<BNEncryptionCertificate *> *encryptionCertificates, NSError *error) {
        
        // Then:
        XCTAssertNil(encryptionCertificates, "The encryptionCertificates variable should be nil.");
        XCTAssertNotNil(error, "The error variable should not be nil.");
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:task.originalRequest.timeoutInterval
                                 handler:^(NSError *error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        }
        [task cancel];
    }];
}

- (void)testEncryptionCertificates500Response {
    
    // Given:
    self.fileName = @"encryptionCertificatesSuccess.json";
    self.statusCode = 500;
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Credit card endpoint test"];
    
    // When:
    NSURLSessionDataTask *task = [BNCreditCardEndpoint encryptionCertificatesWithCompletion:^(NSArray<BNEncryptionCertificate *> *encryptionCertificates, NSError *error) {
        
        // Then:
        XCTAssertNil(encryptionCertificates, "The encryptionCertificates should be nil.");
        XCTAssertNotNil(error, "The error variable should not be nil.");
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:task.originalRequest.timeoutInterval
                                 handler:^(NSError *error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        }
        [task cancel];
    }];
}

- (void)tearDown {
    [OHHTTPStubs removeAllStubs];
    [super tearDown];
}

@end