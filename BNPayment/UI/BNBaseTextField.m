//
//  BNBaseTextField.m
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

#import "BNBaseTextField.h"
#import "UIColor+BNColors.h"
#import "UITextField+BNCreditCard.h"

@interface BNBaseTextField () <UITextFieldDelegate>

@end

@implementation BNBaseTextField

#pragma mark - init methods

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

#pragma mark - Public methods

- (BOOL)hasValidInput {
    if(!self.validRegex) {
        return NO;
    }
    
    return [self regexPattern:self.validRegex matchesString:self.text];
}

#pragma mark - Private methods

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

#pragma mark - Ovveride methods

- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 10, 10);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 10, 10);
}

- (BOOL)becomeFirstResponder {
    BOOL become = [super becomeFirstResponder];
    [self setTextfieldValid:YES];
    return become;
}

- (BOOL)resignFirstResponder {
    BOOL resign = [super resignFirstResponder];
    [self setTextfieldValid:[self hasValidInput]];
    return resign;
}

#pragma mark - UITextFieldDelegate methods

- (BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string {
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if(self.inputRegex) {
        return [self regexPattern:self.inputRegex matchesString:newString];
    }
    
    return YES;
}

@end
