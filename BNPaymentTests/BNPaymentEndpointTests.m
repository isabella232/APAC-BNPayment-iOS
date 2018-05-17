//
//  BNPaymentEndpointTests.m
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

@interface BNPaymentEndpointTests : XCTestCase

@property NSString *fileName;
@property int statusCode;

@end

@implementation BNPaymentEndpointTests

+ (void)setUp {
    [super setUp];
    
    [OHHTTPStubs setEnabled:YES];
    
    NSError *error;
//    [BNPaymentHandler setupWithApiToken:@"T000000000"
//                                baseUrl:nil
//                                  debug:YES
//                                  error:&error];
    
    [BNPaymentHandler setupWithMerchantAccount:@"ABC" baseUrl:nil debug:YES error:&error];
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

- (void)testAuthorizePayment{
    
    // Given:
    self.fileName = @"authorizePaymentSuccess.json";
    self.statusCode = 200;
    BNPaymentParams *params = [BNPaymentParams mockObject];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Credit card endpoint test"];
    
    // When:
    NSURLSessionDataTask *task = [BNPaymentEndpoint authorizePaymentWithParams:params
                                                    paymentType:SubmitPaymentToken
                                                                    completion:^(BNPaymentResponse *paymentResponse, NSError *error) {
        // Then:
        XCTAssertNil(error, "The error variable should not be nil.");
        XCTAssertTrue([paymentResponse isKindOfClass:[BNPaymentResponse class]], "The class type of the paymentResponse variable should be BNPaymentResponse.");
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:task.originalRequest.timeoutInterval handler:^(NSError *error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        }
        [task cancel];
    }];
}

- (void)testAuthorizePaymentWithExtraParams {
    
    // Given:
    self.fileName = @"authorizePaymentSuccessExtraParams.json";
    self.statusCode = 200;
    BNPaymentParams *params = [BNPaymentParams mockObject];

    XCTestExpectation *expectation = [self expectationWithDescription:@"Credit card endpoint test"];
    
    // When:
    NSURLSessionDataTask *task = [BNPaymentEndpoint authorizePaymentWithParams:params
                                                                    paymentType:SubmitPaymentToken
                                                                    completion:^(BNPaymentResponse *paymentResponse, NSError *error) {
        // Then:
        XCTAssertNil(error, "The error variable should not be nil.");
        XCTAssertTrue([paymentResponse isKindOfClass:[BNPaymentResponse class]], "The class type of the paymentResponse variable should be BNPaymentResponse.");
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

- (void)testAuthorizePayment400Error {
    
    // Given:
    self.fileName = @"authorizePaymentSuccess.json";
    self.statusCode = 400;
    BNPaymentParams *params = [BNPaymentParams mockObject];

    XCTestExpectation *expectation = [self expectationWithDescription:@"Credit card endpoint test"];
    
    // When:
    NSURLSessionDataTask *task = [BNPaymentEndpoint authorizePaymentWithParams:params
                                                                    paymentType:SubmitPaymentToken
                                                                    completion:^(BNPaymentResponse *paymentResponse, NSError *error) {
        // Then:
        XCTAssertNotNil(error, "The error variable should not be nil.");
        XCTAssertNil(paymentResponse, "The paymentResponse variable should be nil.");
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

- (void)testAuthorizePayment500Error {
    
    // Given:
    self.fileName = @"authorizePaymentSuccess.json";
    self.statusCode = 500;
    BNPaymentParams *params = [BNPaymentParams mockObject];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Credit card endpoint test"];
    
    // When:
    NSURLSessionDataTask *task = [BNPaymentEndpoint authorizePaymentWithParams:params
                                                                    paymentType:SubmitPaymentToken
                                                                    completion:^(BNPaymentResponse *paymentResponse, NSError *error) {
        // Then:
        XCTAssertNotNil(error, "The error variable should not be nil.");
        XCTAssertNil(paymentResponse, "The paymentResponse variable should be nil.");
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
