//
//  UIColor+BNColorsTests.m
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

@interface UIColorBNColorsTests : XCTestCase

@end

@implementation UIColorBNColorsTests

- (void)testBNPurpleColor {
    
    // Given
    UIColor *correctColor = [UIColor colorWithRed:102/255.f green:76/255.f blue:142/255.f alpha:1];
    
    // When:
    UIColor *colorFromUIColorBNColors = [UIColor BNPurpleColor];
    
    // Then:
    XCTAssertEqualObjects(correctColor, colorFromUIColorBNColors, "The manually added color (correctColor) should equal the color generated through the UIColor+BNColors category.");
}

- (void)testBNTextColor {
    
    // Given
    UIColor *correctColor = [UIColor colorWithRed:79/255.f green:83/255.f blue:85/255.f alpha:1];
    
    // When:
    UIColor *colorFromUIColorBNColors = [UIColor BNTextColor];
    
    // Then:
    XCTAssertEqualObjects(correctColor, colorFromUIColorBNColors, "The manually added color (correctColor) should equal the color generated through the UIColor+BNColors category.");
}

@end