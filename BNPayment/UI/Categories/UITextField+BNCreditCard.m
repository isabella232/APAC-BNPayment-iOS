//
//  UITextField+BNCreditCard.m
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

#import "UITextField+BNCreditCard.h"
#import "UIColor+BNColors.h"

static NSString *const VisaRegex = @"^4";
static NSString *const MasterCardRegex = @"^5[1-5]";
static NSString *const AmexRegex = @"^3[4,7]";
static NSString *const DinersClubRegex = @"^3[0,6,8]";
NSString *const CreditCardRegex =
@"^4(?:[0-9]{15})$"                     //Visa
"|^5(?:[0-9]{15})$"                     //MasterCard
"|^3(?:[0-9]{15})$"                     //JCB
"|^6(?:[0-9]{15})$"                     //Discover
"|^3(?:[47][0-9]{13})$"                 //AmEx
"|^3(?:0[0-5]|[68][0-9])[0-9]{11}$";    //Diners Club

static NSString *const CardHolderRegex = @"[a-z0-9]*";
static NSString *const CVCRegex = @"^[0-9]{3,4}$";
static NSString *const ExpiryRegex = @"^(0[1-9]|1[0-2])\\/?([0-9]{4}|[0-9]{2})$";

@implementation UITextField (BNCreditCard)

- (void)applyStyle {
    [self applyStyleWithKeyboard:UIKeyboardTypeNumberPad];
}

- (void)applyAlphaNumericalStyle {
    [self applyStyleWithKeyboard:UIKeyboardTypeASCIICapable];
}


- (void)applyStyleWithKeyboard:(UIKeyboardType) keyboardType {
    self.layer.borderColor = [[UIColor colorWithRed:220/255.f green:221/255.f blue:222/255.f alpha:1] CGColor];
    self.layer.borderWidth = 1.f;
    self.keyboardType = keyboardType;
    self.tintColor = [UIColor BNPurpleColor];
    self.font = [UIFont systemFontOfSize:16.f];
}


- (void)setTextfieldValid:(BOOL)valid {
    self.textColor = valid ? [UIColor blackColor] : [UIColor redColor];
}

- (BOOL)validCardNumber {
    return [self regexPattern:CreditCardRegex matchesString:[self.text stringByReplacingOccurrencesOfString:@" " withString:@""]];
}

- (BOOL)validCVC {
    return [self regexPattern:CVCRegex matchesString:self.text];
}

- (BOOL)validCardHolder {
    return [self regexPattern:CardHolderRegex matchesString:self.text];
}
    
- (BOOL)validExpiryDate {
    if([self regexPattern:ExpiryRegex matchesString:self.text]) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yy/MM"];
        NSString *currentDateString = [formatter stringFromDate:[NSDate date]];
        
        NSString *monthString = [self.text substringWithRange:NSMakeRange(0, 2)];
        NSString *yearString = [self.text substringWithRange:NSMakeRange(3, 2)];

        
        return [[NSString stringWithFormat:@"%@/%@", yearString, monthString] compare:currentDateString] != NSOrderedAscending;
    }
    
    return NO;
}

- (BOOL)isVisaCardNumber:(NSString *)cardNumber {
    return [self regexPattern:VisaRegex matchesString:cardNumber];
}

- (BOOL)isMasterCardNumber:(NSString *)cardNumber {
    return [self regexPattern:MasterCardRegex matchesString:cardNumber];
}

- (BOOL)isAmexCardNumber:(NSString *)cardNumber {
    return [self regexPattern:AmexRegex matchesString:cardNumber];
}

- (BOOL)isDinersClubCardNumber:(NSString *)cardNumber {
    return [self regexPattern:DinersClubRegex matchesString:cardNumber];
}

- (BOOL)regexPattern:(NSString *)pattern matchesString:(NSString *)string {
    NSError *error;
    NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                           options:0
                                                                             error:&error];
    if(!error) {
        return  0 < [regex numberOfMatchesInString:string
                                           options:0
                                             range:NSMakeRange(0, [string length])];
        
    }
    
    return NO;
}

@end
