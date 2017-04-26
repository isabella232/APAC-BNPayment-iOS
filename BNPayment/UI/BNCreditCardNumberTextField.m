//
//  BNCreditCardNumberTextField.m
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

#import "BNCreditCardNumberTextField.h"
#import "UIColor+BNColors.h"
#import "UITextField+BNCreditCard.h"
#import "UIImage+BNUtils.h"

NSString *visaLogoImageName = @"VisaLogo";
NSString *masterCardLogoImageName = @"MasterCardLogo";
NSString *amexLogoImageName = @"AmexLogo";
NSString *dinersClubLogoImageName = @"DinersClubLogo";

@interface BNCreditCardNumberTextField () <UITextFieldDelegate>

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation BNCreditCardNumberTextField {
    NSString *oldText;
    UITextRange *oldSelection;
    BOOL whitesSpaceRemoved;
}

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if(self) {
        self.delegate = self;
        [self setupTextField];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if(self) {
        self.delegate = self;
        [self setupTextField];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(CGRectGetWidth(self.frame)-41, 15, 24, 18);
}

- (void)setupTextField {
    [self addTarget:self action:@selector(reformatAsCardNumber:) forControlEvents:UIControlEventEditingChanged];
    self.imageView = [UIImageView new];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.imageView];
}

- (BOOL)becomeFirstResponder {
    [self setTextfieldValid:YES];
    return [super becomeFirstResponder];
}

- (BOOL)resignFirstResponder {
    BOOL resign = [super resignFirstResponder];
    [self setTextfieldValid:([self validCardNumber] || self.text.length == 0)];
    return resign;
}

- (void)updateCardImage {
    UIImage *cardLogoImage = nil;
    NSBundle *bundle = [BNBundleUtils paymentLibBundle];
    
    if([self isVisaCardNumber:self.text]) {
        cardLogoImage = [UIImage loadImageWithName:visaLogoImageName
                                        fromBundle:bundle];
    }
    
    if([self isMasterCardNumber:self.text]) {
        cardLogoImage = [UIImage loadImageWithName:masterCardLogoImageName
                                        fromBundle:bundle];
    }
    
    if([self isAmexCardNumber:self.text]) {
        cardLogoImage = [UIImage loadImageWithName:amexLogoImageName
                                        fromBundle:bundle];
    }
    
    if([self isDinersClubCardNumber:self.text]) {
        cardLogoImage = [UIImage loadImageWithName:dinersClubLogoImageName
                                        fromBundle:bundle];
    }
    
    self.imageView.image = cardLogoImage;
}


-(void)reformatAsCardNumber:(UITextField *)textField
{
    NSUInteger cursorPosition =
    [textField offsetFromPosition:textField.beginningOfDocument
                       toPosition:textField.selectedTextRange.start];
    
    if(whitesSpaceRemoved) {
        textField.text = [textField.text stringByReplacingCharactersInRange:NSMakeRange(cursorPosition-1, 1) withString:@""];
        cursorPosition -= 1;
    }
    
    NSString *numberString = [self removeNonDigits:textField.text
                        andPreserveCursorPosition:&cursorPosition];
    
    
    NSString *formattedString = @"";
    NSUInteger maxLength = 16;
    
    if ([self isAmexCardNumber:numberString]){
        maxLength = 15;
        formattedString = [self addSpacesAmexDiners:numberString
                                     cursorPosition:&cursorPosition];
    }
    else if ([self isDinersClubCardNumber:numberString]){
        maxLength = 14;
        formattedString = [self addSpacesAmexDiners:numberString
                                     cursorPosition:&cursorPosition];
    }
    else {
        formattedString = [self addSpaces:numberString
                                     cursorPosition:&cursorPosition];
    }
    
    if ([numberString length] > maxLength) {
        [textField setText:oldText];
        textField.selectedTextRange = oldSelection;
        return;
    }
    
    textField.text = formattedString;
    UITextPosition *targetPosition =
    [textField positionFromPosition:[textField beginningOfDocument]
                             offset:cursorPosition];
    
    [textField setSelectedTextRange:[textField textRangeFromPosition:targetPosition
                                                          toPosition:targetPosition]];
    [self updateCardImage];
}

- (NSString *)removeNonDigits:(NSString *)string
    andPreserveCursorPosition:(NSUInteger *)cursorPosition {
    
    NSUInteger originalCursorPosition = *cursorPosition;
    NSMutableString *digitsOnlyString = [NSMutableString new];
    for (NSUInteger i=0; i<[string length]; i++) {
        unichar characterToAdd = [string characterAtIndex:i];
        if (isdigit(characterToAdd)) {
            NSString *stringToAdd =
            [NSString stringWithCharacters:&characterToAdd
                                    length:1];
            
            [digitsOnlyString appendString:stringToAdd];
        }
        else {
            if (i < originalCursorPosition) {
                (*cursorPosition)--;
            }
        }
    }
    
    return digitsOnlyString;
}


- (NSString *)addSpaces:(NSString *)string
         cursorPosition:(NSUInteger *)cursorPosition{
    
    NSMutableString *stringWithAddedSpaces = [NSMutableString new];
    for (NSUInteger i=0; i<[string length]; i++) {
        unichar characterToAdd = [string characterAtIndex:i];
        NSString *stringToAdd =
        [NSString stringWithCharacters:&characterToAdd length:1];
        
        [stringWithAddedSpaces appendString:stringToAdd];

        NSInteger iPlus1 = i+1;
        if ((i > 0) && (iPlus1 % 4) == 0 && i < 15) {
            [stringWithAddedSpaces appendString:@" "];
            if (i < *cursorPosition) {
                (*cursorPosition)++;
            }
        }
    }
    
    return stringWithAddedSpaces;
}

- (NSString *)addSpacesAmexDiners:(NSString *)string
         cursorPosition:(NSUInteger *)cursorPosition{
    
    NSMutableString *stringWithAddedSpaces = [NSMutableString new];
    
    for (NSUInteger i=0; i<[string length]; i++)
    {
        unichar characterToAdd = [string characterAtIndex:i];
        NSString *stringToAdd =
            [NSString stringWithCharacters:&characterToAdd length:1];
        
        [stringWithAddedSpaces appendString:stringToAdd];
        
        if (i == 3) {
            [stringWithAddedSpaces appendString:@" "];
            if (i < *cursorPosition) {
                (*cursorPosition)++;
            }
            
        }
        if (i == 9){
            [stringWithAddedSpaces appendString:@" "];
            if (i < *cursorPosition) {
                (*cursorPosition)++;
            }
        }
    }
    
    return stringWithAddedSpaces;
}

#pragma mark - UITextFieldDelegate methods

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    oldText = textField.text;
    oldSelection = textField.selectedTextRange;
    
    if(string.length == 0 && range.length == 1 && [oldText characterAtIndex:range.location] == ' ') {
        whitesSpaceRemoved = YES;
    }else {
        whitesSpaceRemoved = NO;
    }
    
    return YES;
}


@end
