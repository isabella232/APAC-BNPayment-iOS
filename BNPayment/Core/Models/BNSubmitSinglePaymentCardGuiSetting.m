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

#import "BNSubmitSinglePaymentCardGuiSetting.h"
#import "BNBaseModel.h"

@implementation BNSubmitSinglePaymentCardGuiSetting


//Get cardRegistrationGuiEnum string key.
+(NSString *)GetGuiKey:(submitSinglePaymentCardGuiEnum)guiEnum{
    NSString *guiKey = nil;
    
    switch(guiEnum) {
        case payTitleText:
            guiKey = @"submitSinglePaymentCardTitleText";
            break;
        case payCardHolderWatermark:
            guiKey = @"submitSinglePaymentCardHolderWatermark";
            break;
        case payCardNumberWatermark:
            guiKey = @"submitSinglePaymentCardNumberWatermark";
            break;
        case payExpiryDateWatermark:
            guiKey = @"submitSinglePaymentExpiryDateWatermark";
            break;
        case paySecurityCodeWatermark:
            guiKey = @"submitSinglePaymentSecurityCodeWatermark";
            break;
        case payButtonText:
            guiKey = @"submitSinglePaymentPayButtonText";
            break;
        case payButtonColor:
            guiKey = @"submitSinglePaymentPayButtonColor";
            break;
        case switchButtonColor:
            guiKey = @"submitSinglePaymentSwitchButtonColor";
            break;
        case loadingBarColor:
            guiKey = @"loadingBarColor";
            break;
        case cardIOColor:
            guiKey = @"cardIOColor";
            break;
        case cardIODisable:
            guiKey = @"cardIODisable";
            break;
        default:
            [NSException raise:NSGenericException format:@"Unexpected submitSinglePaymentCardGuiEnum."];
    }
    return guiKey;
}

@end
