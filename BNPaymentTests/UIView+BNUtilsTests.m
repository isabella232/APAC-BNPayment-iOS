//
//  UIView+BNUtilsTests.m
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

@interface UIViewBNUtilsTests : XCTestCase

@end

@implementation UIViewBNUtilsTests

- (void)testsetYoffset {
    
    // Given:
    UIButton *button = [UIButton new];
    
    // When:
    [button setYoffset:5];
    
    // Then:
    XCTAssertTrue((button.frame.origin.y == 5), "The vertical offset of the button should be 5.");
    
}


- (void)testsetXoffset {
    
    // Given:
    UIButton *button = [UIButton new];
    
    // When:
    [button setXoffset:5];
    
    // Then:
    XCTAssertTrue((button.frame.origin.x == 5), "The horizontal offset of the button should be 5.");
    
}

- (void)testSetHeight {
    
    // Given:
    UIButton *button = [UIButton new];
    
    // When:
    [button setHeight:5];
    
    // Then:
    XCTAssertTrue((button.frame.size.height == 5), "The height of the button should be 5.");
    
}

- (void)testSetWidth {
    
    // Given:
    UIButton *button = [UIButton new];

    // When:
    [button setWidth:5];
    
    // Then:
    XCTAssertTrue((button.frame.size.width == 5), "The width of the button should be 5.");
    
}


- (void)testSetCornerRadius {
    
    // Given:
    UIButton *button = [UIButton new];
    
    
    // When:
    [button setCornerRadius:5];
    
    // Then:
    XCTAssertTrue((button.layer.cornerRadius == 5), "The corner radius of the button should be 5.");
    
}

@end