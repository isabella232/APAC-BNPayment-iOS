//
//  BNCCHostedFormParams.m
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

#import "BNCCHostedFormParams.h"
#import "BNCCFormInputGroup.h"

@implementation BNCCHostedFormParams {
    BNCCFormInputGroup *_cardNumberInputGroup;
    BNCCFormInputGroup *_cvvInputGroup;
    BNCCFormInputGroup *_expiryDateInputGroup;
}

+ (NSDictionary *)JSONMappingDictionary {
    return @{
             @"cssURL" : @"cssurl",
             @"platform" : @"platform",
             @"inputGroups" : @"inputgroups",
             @"submitButtonText": @"submitbutton"
             };
}

- (instancetype)init {
    self = [super init];
    
    if(self) {
        self.platform = @"ios";

        _cardNumberInputGroup = [BNCCFormInputGroup new];
        _cardNumberInputGroup.name = @"cardnumber";

        _expiryDateInputGroup = [BNCCFormInputGroup new];
        _expiryDateInputGroup.name = @"cardexpiry";

        _cvvInputGroup = [BNCCFormInputGroup new];
        _cvvInputGroup.name = @"cardverification";
        
        self.inputGroups = @[_cardNumberInputGroup,_expiryDateInputGroup,_cvvInputGroup];
    }
    
    return self;
}

- (void)CCNumberPlaceholder:(NSString *)placeholder {
    _cardNumberInputGroup.placeholder = placeholder;
}

- (void)expiryPlaceholder:(NSString *)placeholder {
    _expiryDateInputGroup.placeholder = placeholder;
}

- (void)cvvPlaceholder:(NSString *)placeholder {
    _cvvInputGroup.placeholder = placeholder;
}

+ (BNCCHostedFormParams *)hostedFormParamsWithCSS:(NSString *)css
                            cardNumberPlaceholder:(NSString *)cardNumberPlaceholder
                                expiryPlaceholder:(NSString *)expiryPlaceholder
                                   cvvPlaceholder:(NSString *)cvvPlaceholder
                                       submitText:(NSString *)submitText {
    
    BNCCHostedFormParams *params = [BNCCHostedFormParams new];
    
    params.cssURL = css;
    params.submitButtonText = submitText;
    
    [params CCNumberPlaceholder:cardNumberPlaceholder];
    [params expiryPlaceholder:expiryPlaceholder];
    [params cvvPlaceholder:cvvPlaceholder];
    
    return params;
}

+ (BNCCHostedFormParams *)mockObject {
    BNCCHostedFormParams *params = [BNCCHostedFormParams new];
    
    params.submitButtonText = @"Save card";

    [params CCNumberPlaceholder:@"Card number"];
    [params expiryPlaceholder:@"MM/YY"];
    [params cvvPlaceholder:@"CVV/CVC"];
    
    return params;
}

@end
