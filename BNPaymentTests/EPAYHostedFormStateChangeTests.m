//
//  EPAYHostedFormStateChangeTests.m
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

@interface EPAYHostedFormStateChangeTests : XCTestCase

@end

@implementation EPAYHostedFormStateChangeTests

- (void)testJSONMappingDictionary {
    
    // Given:
    NSDictionary *correctDictionary = @{
                                        @"meta": @"meta",
                                        @"truncatedCardNumber": @"truncatedcardnumber",
                                        @"expiryMonth": @"expmonth",
                                        @"expiryYear": @"expyear",
                                        @"paymentType": @"paymenttype",
                                        @"subscriptionId": @"subscriptionid"
                                        };
    
    
    // When:
    NSDictionary *dictionaryFromEPAYHostedFormStateChange = [EPAYHostedFormStateChange JSONMappingDictionary];
    
    // Then:
    XCTAssertEqualObjects(correctDictionary, dictionaryFromEPAYHostedFormStateChange, "The manually added dictionary (correctDictionary) should equal the dictionary generated through the EPAYHostedFormStateChange class.");
}

- (void)testIncorrectJSONMappingDictionary {
    
    // Given:
    NSDictionary *incorrectDictionary = @{
                                        @"meta": @"meta",
                                        @"truncatedCardNumber": @"truncatedcardnumber",
                                        @"expiryMonth": @"expmonth",
                                        @"expiryYear": @"expyear",
                                        @"paymentType": @"paymenttype",
                                        @"subscriptionId": @"subscriptionid",
                                        @"wasd" : @"wasd"
                                        };
    
    
    // When:
    NSDictionary *dictionaryFromEPAYHostedFormStateChange = [EPAYHostedFormStateChange JSONMappingDictionary];
    
    // Then:
    XCTAssertNotEqualObjects(incorrectDictionary, dictionaryFromEPAYHostedFormStateChange, "The manually added dictionary (correctDictionary) should not equal the dictionary generated through the EPAYHostedFormStateChange class.");
}

- (void)testGenerateAuthorizedCard {
    
    // Given:
    NSObject *authorizedCreditCard;
    EPAYHostedFormStateChange *EPAYHostedFormStateChangeObject = [EPAYHostedFormStateChange new];
    
    // When:
    authorizedCreditCard = [EPAYHostedFormStateChangeObject generateAuthorizedCard];
    
    // Then:
    XCTAssertNotNil(authorizedCreditCard, "The authorizedCreditCard object should not be nil.");
    XCTAssert([authorizedCreditCard isKindOfClass:[BNAuthorizedCreditCard class]], "The authorizedCreditCard object should an instance of the class BNAuthorizedCreditCard.");
}


@end
