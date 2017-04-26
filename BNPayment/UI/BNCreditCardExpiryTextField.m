//
//  BNCreditCardExpiryTextField.m
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

#import "BNCreditCardExpiryTextField.h"
#import "UITextField+BNCreditCard.h"

@interface BNCreditCardExpiryTextField () <UITextFieldDelegate>

@end

@implementation BNCreditCardExpiryTextField

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if(self) {
        self.delegate = self;
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if(self) {
        self.delegate = self;
    }
    
    return self;
}

- (NSString *)getExpiryMonth {
    if([self validExpiryDate]) {
        return [self.text substringWithRange:NSMakeRange(0, 2)];
    }
        
    return @"";
}

- (NSString *)getExpiryYear {
    if([self validExpiryDate]) {
        return [self.text substringWithRange:NSMakeRange(3, 2)];
    }
    
    return @"";
}

- (BOOL)becomeFirstResponder {
    BOOL become = [super becomeFirstResponder];
    [self setTextfieldValid:YES];
    return become;
}

- (BOOL)resignFirstResponder {
    BOOL resign = [super resignFirstResponder];
    [self setTextfieldValid:([self validExpiryDate] || self.text.length == 0)];
    return resign;
}

- (BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string {
    
    NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    if ([string rangeOfCharacterFromSet:notDigits].location != NSNotFound) {
        return NO;
    }
    
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSString *numberString = [newString stringByReplacingOccurrencesOfString:@"/" withString:@""];
    
    if(numberString.length > 4) {
        return NO;
    }
    
    
    if(range.location < numberString.length && numberString.length > 0 && string.length > 0 && numberString.length <= 3) {
        numberString = [numberString stringByReplacingCharactersInRange:NSMakeRange(range.location, numberString.length-range.location) withString:string];
        textField.text = numberString;
    }
    
    if(range.location <= numberString.length && numberString.length > 0 && string.length == 0) {
        if(range.location >= 2) {
            numberString = [numberString stringByReplacingCharactersInRange:NSMakeRange(range.location-1, numberString.length-range.location+1) withString:string];
        }else {
            numberString = [numberString stringByReplacingCharactersInRange:NSMakeRange(range.location, numberString.length-range.location) withString:string];
        }
        textField.text = numberString;
    }
    
    if(numberString.length < 2) {
        textField.text = [NSString stringWithFormat:@"%@", numberString];
    }
    
    if(numberString.length >= 2) {
        NSString *monthString = [numberString substringWithRange:NSMakeRange(0, 2)];
        NSString *yearString = [numberString substringWithRange:NSMakeRange(2, numberString.length-2)];
        textField.text = [NSString stringWithFormat:@"%@/%@",monthString, yearString];
    }
    
    [textField sendActionsForControlEvents:UIControlEventEditingChanged];

    return NO;
}

@end
