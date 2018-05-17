//
//  BNPaymentTypeTest.m
//  BNPaymentTests
//
//  Created by Mark Ma on 18/4/18.
//  Copyright © 2018 Bambora. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface BNPaymentTypeTest : XCTestCase

@end

@implementation BNPaymentTypeTest

- (void)testGetDisplayTextByType{
    
    NSString *expectedValueForSubmitPaymentCard = @"Payment(Card)";
    NSString *expectedValueForSubmitPaymentToken = @"Payment(Token)";
    NSString *expectedValueForSubmitPreAuthCard = @"PreAuth(Card)";
    NSString *expectedValueForSubmitPreAuthToken = @"PreAuth(Token)";
    
    XCTAssertTrue([expectedValueForSubmitPaymentCard isEqualToString:[BNPaymentType GetDisplayTextByType:SubmitPaymentCard]] ,"Text for SubmitPaymentCard");
    
    XCTAssertTrue([expectedValueForSubmitPaymentToken isEqualToString:[BNPaymentType GetDisplayTextByType:SubmitPaymentToken]] ,"Text for SubmitPaymentToken");
    
    XCTAssertTrue([expectedValueForSubmitPreAuthCard isEqualToString:[BNPaymentType GetDisplayTextByType:PreAuthCard]] ,"Text for PreAuthCard");
    
    XCTAssertTrue([expectedValueForSubmitPreAuthToken isEqualToString:[BNPaymentType GetDisplayTextByType:PreAuthToken]] ,"Text for PreAuthToken");

}

@end
