//
//  BNCCHostedFormParamsTests.m
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

#import <XCTest/XCTest.h>

@interface BNCCHostedFormParamsTests : XCTestCase

@end

@implementation BNCCHostedFormParamsTests

- (void)testhostedFormParamsWithCSS {
    
    // Given:
    NSString *cssURL = @"stylesheet.css";
    NSString *submitText = @"submit";
    
    // When:
    BNCCHostedFormParams *parameters = [BNCCHostedFormParams hostedFormParamsWithCSS:cssURL
                                                   cardNumberPlaceholder:@"Card number"
                                                       expiryPlaceholder:@"Expiration"
                                                          cvvPlaceholder:@"CVV"
                                                            submitText:submitText];
    
    // Then:
    XCTAssert([parameters.cssURL isEqualToString:cssURL], "The value of parameters.cssURL should have been stylesheet.css.");
    XCTAssert([parameters.submitButtonText isEqualToString:submitText], "The value of submitButtonText should have been Submit.");
    XCTAssert(parameters.inputGroups.count == 3, "The input group count should be 3");
}

@end
