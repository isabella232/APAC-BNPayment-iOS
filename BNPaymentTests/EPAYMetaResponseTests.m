//
//  EPAYMetaResponseTests.m
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

@interface EPAYMetaResponseTests : XCTestCase

@end

@implementation EPAYMetaResponseTests

- (void)testJSONMappingDictionary {
    
    // Given:
    NSDictionary *correctDictionary = @{
                                        @"action": @"action",
                                        @"message": @"message",
                                        @"result": @"result"
                                        };
    
    // When:
    NSDictionary *dictionaryFromEPAYMetaResponse = [EPAYMetaResponse JSONMappingDictionary];
    
    // Then:
    XCTAssertEqualObjects(correctDictionary, dictionaryFromEPAYMetaResponse, "The manually added dictionary (correctDictionary) should equal the dictionary generated through the EPAYMetaResponse class.");
    
}

- (void)testIncorrectJSONMappingDictionary {
    
    // Given:
    NSDictionary *incorrectDictionary = @{
                                        @"action": @"action",
                                        @"message": @"message",
                                        @"result": @"result",
                                        @"wasd" : @"wasd"
                                        };
    
    // When:
    NSDictionary *dictionaryFromEPAYMetaResponse = [EPAYMetaResponse JSONMappingDictionary];
    
    // Then:
    XCTAssertNotEqualObjects(incorrectDictionary, dictionaryFromEPAYMetaResponse, "The manually added dictionary (correctDictionary) should equal the dictionary generated through the EPAYMetaResponse class.");
    
}

@end