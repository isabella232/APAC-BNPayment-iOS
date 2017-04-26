//
//  BNCCHostedFormParams.h
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

#import "BNBaseModel.h"

@class BNCCFormInputGroup;

/**
 *  `BNCCHostedFormParams` is used for generating params to /hpp/ endpoint
 */
@interface BNCCHostedFormParams : BNBaseModel

@property (nonatomic, strong) NSString *cssURL;
@property (nonatomic, strong) NSString *platform;
@property (nonatomic, strong) NSArray<BNCCFormInputGroup *> *inputGroups;
@property (nonatomic, strong) NSString *submitButtonText;

/**
 *  This method is used for setting the placeholder text for the credit card number input field in the hosted page.
 *  This will be translated into setting the HTML placeholder attribute.
 *
 *  @param placeholder `NSString` representing the placeholder text.
 */
- (void)CCNumberPlaceholder:(NSString *)placeholder;

/**
 *  This method is used for setting the placeholder text for the expiry date input field in the hosted page.
 *  This will be translated into setting the HTML placeholder attribute.
 *
 *  @param placeholder `NSString` representing the placeholder text.
 */
- (void)expiryPlaceholder:(NSString *)placeholder;

/**
 *  This method is used for setting the placeholder text for the CVV/CVC input field in the hosted page.
 *  This will be translated into setting the HTML placeholder attribute.
 *
 *  @param placeholder `NSString` representing the placeholder text.
 */
- (void)cvvPlaceholder:(NSString *)placeholder;

/**
 *  This is a convenience method for creating `BNCCHostedFormParams` params.
 *  This allows you to specify the CSS url used by the hosted page, all placeholders, and the submit button text.
 *  This can of course be done via the properties aswell.
 *
 *  @param css                   `NSString` containing an url to a CSS file.
 *  @param cardNumberPlaceholder `NSString` representing the placeholder text for CC input group.
 *  @param expiryPlaceholder     `NSString` representing the placeholder text for Expiry input group.
 *  @param cvvPlaceholder        `NSString` representing the placeholder text for CVV/CVC input group.
 *  @param submitText            `NSString` representing the text for the submit button.
 *
 *  @return An instance of `BNCCHostedFormParams`.
 */
+ (BNCCHostedFormParams *)hostedFormParamsWithCSS:(NSString *)css
                            cardNumberPlaceholder:(NSString *)cardNumberPlaceholder
                                expiryPlaceholder:(NSString *)expiryPlaceholder
                                   cvvPlaceholder:(NSString *)cvvPlaceholder
                                       submitText:(NSString *)submitText;

+ (BNCCHostedFormParams *)mockObject;

@end
