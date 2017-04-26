//
//  BNLoaderButtonTests.m
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

@interface BNLoaderButtonTests : XCTestCase

@end

@implementation BNLoaderButtonTests

- (void)testSetLoading {

    // Given:
    BNLoaderButton *loaderButton = [BNLoaderButton new];

    // When:
    [loaderButton setLoading:YES];

    // Then:
    XCTAssert(!loaderButton.enabled);
    

}

- (void)testSetNotLoading {
    
    // Given:
    BNLoaderButton *loaderButton = [BNLoaderButton new];

    // When:
    [loaderButton setLoading:NO];
    
    // Then:
    XCTAssert(loaderButton.enabled);
}

- (void)testDrawRect {

    // Given:
    BNLoaderButton *loaderButton = [BNLoaderButton new];
    CGRect originalFrame = loaderButton.frame;
    
    // When:
    CGRect rectangle = CGRectMake(0.0, 0.0, 50.0, 100.0);
    [loaderButton drawRect:rectangle];
    
    // Then:
    XCTAssert(!CGRectEqualToRect(originalFrame, rectangle));

}

@end


