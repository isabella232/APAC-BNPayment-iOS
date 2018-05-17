//
//  BNCardRegistrationGuiSettingTest.m
//  BNPaymentTests
//
//  Created by Mark Ma on 16/4/18.
//  Copyright © 2018 Bambora. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface BNCardRegistrationGuiSettingTest : XCTestCase

@end

@implementation BNCardRegistrationGuiSettingTest

- (void)testGetGuiKey {
    
    XCTAssert([[BNCardRegistrationGuiSetting GetGuiKey:registrationTitleText] isEqualToString:@"regiTitleText"], "Get String from Enum");
    
    XCTAssert([[BNCardRegistrationGuiSetting GetGuiKey:registrationButtonText] isEqualToString:@"registerButtonText"], "Get String from Enum");
    
    XCTAssert([[BNCardRegistrationGuiSetting GetGuiKey:registrationCardHolderWatermark] isEqualToString:@"regiCardHolderWatermark"], "Get String from Enum");
    
    XCTAssert([[BNCardRegistrationGuiSetting GetGuiKey:registrationCardNumberWatermark] isEqualToString:@"regiCardNumberWatermark"], "Get String from Enum");
    
    XCTAssert([[BNCardRegistrationGuiSetting GetGuiKey:registrationExpiryDateWatermark] isEqualToString:@"regiExpiryDateWatermark"], "Get String from Enum");
    
    XCTAssert([[BNCardRegistrationGuiSetting GetGuiKey:registrationSecurityCodeWatermark] isEqualToString:@"regiSecurityCodeWatermark"], "Get String from Enum");
    
    XCTAssert([[BNCardRegistrationGuiSetting GetGuiKey:registrationButtonColor] isEqualToString:@"registrationButtonColor"], "Get String from Enum");
    
    XCTAssert([[BNCardRegistrationGuiSetting GetGuiKey:registrationCardIODisable] isEqualToString:@"registrationCardDisable"], "Get String from Enum");
    
    XCTAssert([[BNCardRegistrationGuiSetting GetGuiKey:registrationCardIOColor] isEqualToString:@"registrationCardIOColor"], "Get String from Enum");
    
}

@end
