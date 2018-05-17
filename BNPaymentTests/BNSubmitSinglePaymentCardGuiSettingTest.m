//
//  BNSubmitSinglePaymentCardGuiSettingTest.m
//  BNPaymentTests
//
//  Created by Mark Ma on 16/4/18.
//  Copyright © 2018 Bambora. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface BNSubmitSinglePaymentCardGuiSettingTest : XCTestCase

@end

@implementation BNSubmitSinglePaymentCardGuiSettingTest

- (void)testGetGuiKey {
    
    XCTAssert([[BNSubmitSinglePaymentCardGuiSetting GetGuiKey:payTitleText] isEqualToString:@"submitSinglePaymentCardTitleText"], "Get String from Enum");
    XCTAssert([[BNSubmitSinglePaymentCardGuiSetting GetGuiKey:payCardHolderWatermark] isEqualToString:@"submitSinglePaymentCardHolderWatermark"], "Get String from Enum");
    XCTAssert([[BNSubmitSinglePaymentCardGuiSetting GetGuiKey:payCardNumberWatermark] isEqualToString:@"submitSinglePaymentCardNumberWatermark"], "Get String from Enum");
    XCTAssert([[BNSubmitSinglePaymentCardGuiSetting GetGuiKey:payExpiryDateWatermark] isEqualToString:@"submitSinglePaymentExpiryDateWatermark"], "Get String from Enum");
    XCTAssert([[BNSubmitSinglePaymentCardGuiSetting GetGuiKey:paySecurityCodeWatermark] isEqualToString:@"submitSinglePaymentSecurityCodeWatermark"], "Get String from Enum");
    XCTAssert([[BNSubmitSinglePaymentCardGuiSetting GetGuiKey:payButtonText] isEqualToString:@"submitSinglePaymentPayButtonText"], "Get String from Enum");
    XCTAssert([[BNSubmitSinglePaymentCardGuiSetting GetGuiKey:payButtonColor] isEqualToString:@"submitSinglePaymentPayButtonColor"], "Get String from Enum");
    XCTAssert([[BNSubmitSinglePaymentCardGuiSetting GetGuiKey:switchButtonColor] isEqualToString:@"submitSinglePaymentSwitchButtonColor"], "Get String from Enum");
    XCTAssert([[BNSubmitSinglePaymentCardGuiSetting GetGuiKey:loadingBarColor] isEqualToString:@"loadingBarColor"], "Get String from Enum");
    XCTAssert([[BNSubmitSinglePaymentCardGuiSetting GetGuiKey:cardIOColor] isEqualToString:@"cardIOColor"], "Get String from Enum");
    XCTAssert([[BNSubmitSinglePaymentCardGuiSetting GetGuiKey:cardIODisable] isEqualToString:@"cardIODisable"], "Get String from Enum");
    
}

@end
