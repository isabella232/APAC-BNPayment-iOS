//
//  BNCreditCard.m
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

#import "BNCardRegistrationGuiSetting.h"
#import "BNBaseModel.h"

@implementation BNCardRegistrationGuiSetting



+ (BNCardRegistrationGuiSetting *)BNCardRegistrationGuiSetting:
                                         (NSString *)titleText
                      registerButtonText:(NSString *)registerButtonText
                     cardHolderWatermark:(NSString *)cardHolderWatermark
                     cardNumberWatermark:(NSString *)cardNumberWatermark
                     expiryDateWatermark:(NSString *)expiryDateWatermark
                   securityCodeWatermark:(NSString *)securityCodeWatermark
                 registrationButtonColor:(NSString *)registrationButtonColor
                 registrationCardIODisable:(BOOL)registrationCardIODisable
                 registrationCardIOColor:(NSString *)registrationCardIOColor
{
    BNCardRegistrationGuiSetting *cardRegistrationGuiSetting = [BNCardRegistrationGuiSetting new];
    cardRegistrationGuiSetting.titleText = titleText;
    cardRegistrationGuiSetting.registerButtonText = registerButtonText;
    cardRegistrationGuiSetting.cardHolderWatermark = cardHolderWatermark;
    cardRegistrationGuiSetting.cardNumberWatermark = cardNumberWatermark;
    cardRegistrationGuiSetting.expiryDateWatermark = expiryDateWatermark;
    cardRegistrationGuiSetting.securityCodeWatermark = securityCodeWatermark;
    cardRegistrationGuiSetting.registrationButtonColor = registrationButtonColor;
    cardRegistrationGuiSetting.registrationCardIODisable = registrationCardIODisable;
    cardRegistrationGuiSetting.registrationCardIOColor = registrationCardIOColor;
    return cardRegistrationGuiSetting;
}

//Get cardRegistrationGuiEnum string key.
+(NSString *)GetGuiKey:(cardRegistrationGuiEnum)cardRegistrationGuiEnum{
    NSString *guiKey = nil;
    
    switch(cardRegistrationGuiEnum) {
        case registrationTitleText:
            guiKey = @"regiTitleText";
            break;
        case registrationButtonText:
            guiKey = @"registerButtonText";
            break;
        case registrationCardHolderWatermark:
            guiKey = @"regiCardHolderWatermark";
            break;
        case registrationCardNumberWatermark:
            guiKey = @"regiCardNumberWatermark";
            break;
        case registrationExpiryDateWatermark:
            guiKey = @"regiExpiryDateWatermark";
            break;
        case registrationSecurityCodeWatermark:
            guiKey = @"regiSecurityCodeWatermark";
            break;
        case registrationButtonColor:
            guiKey = @"registrationButtonColor";
            break;
        case registrationCardIODisable:
            guiKey = @"registrationCardDisable";
            break;
        case registrationCardIOColor:
            guiKey = @"registrationCardIOColor";
            break;
        default:
            [NSException raise:NSGenericException format:@"Unexpected cardRegistrationGuiEnum."];
    }
    return guiKey;
}

@end
