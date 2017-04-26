//
//  BNPaymentHandlerTests.m
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

@interface BNPaymentHandlerTests : XCTestCase

@end

@implementation BNPaymentHandlerTests {
    BNAuthorizedCreditCard *firstCard;
    BNAuthorizedCreditCard *firstCardDuplicate;
    BNAuthorizedCreditCard *secondCard;
    BNAuthorizedCreditCard *thirdCard;
    BNPaymentHandler *handler;
}

- (void)setUp {
    [super setUp];

    handler = [BNPaymentHandler sharedInstance];
    
    firstCard = [BNAuthorizedCreditCard new];
    firstCard.creditCardAlias = @"First";
    firstCard.creditCardToken = @"123";
    
    firstCardDuplicate = [BNAuthorizedCreditCard new];
    firstCardDuplicate.creditCardAlias = @"First card duplicate";
    firstCardDuplicate.creditCardToken = @"123";
    
    secondCard = [BNAuthorizedCreditCard new];
    secondCard.creditCardAlias = @"Second";
    secondCard.creditCardToken = @"1234";
    
    thirdCard = [BNAuthorizedCreditCard new];
    thirdCard.creditCardAlias = @"Third";
    thirdCard.creditCardToken = @"1235";

    XCTAssertTrue([[handler authorizedCards] count] == 0, "No credit card tokens should be registered (in other words, the array that is returned from the call to [handler authorizedCards] should be empty).");
}

- (void)testSaveCreditCardTokens {
    
    // When:
    [handler saveAuthorizedCreditCard:firstCard];
    [handler saveAuthorizedCreditCard:secondCard];
    
    // Then:
    XCTAssertTrue([[handler authorizedCards] containsObject:firstCard], "The handler should contain the firstCard object.");
    XCTAssertTrue([[handler authorizedCards] containsObject:secondCard], "The handler should contain the secondCard");
}

- (void)testSaveTheSameCreditCardTokenTwice {
    
    // When:
    [handler saveAuthorizedCreditCard:firstCard];
    NSUInteger countAfterAddingOneCard = [[handler authorizedCards] count];
    [handler saveAuthorizedCreditCard:firstCard];
    
    // Then:
    XCTAssertEqual(countAfterAddingOneCard, [handler authorizedCards].count, "The number of credit card tokens that were present after adding one card (countAfterAddingOneCard) should be equal to the number of credit card tokens present after attempting to register the same credit card token again ([handler authorizedCards].count).");
}

- (void)testSaveDuplicateCreditCardTokens {
    
    // When:
    [handler saveAuthorizedCreditCard:firstCard];
    NSUInteger countAfterAddingOneCard = [[handler authorizedCards] count];
    [handler saveAuthorizedCreditCard:firstCardDuplicate];
    
    // Then:
    XCTAssertEqual(countAfterAddingOneCard, [handler authorizedCards].count, "The number of credit card tokens that were present after adding one card (countAfterAddingOneCard) should be equal to the number of credit card tokens present after attempting to add a duplicate credit card token ([handler authorizedCards].count).");
}

- (void)testSaveAndRemoveCreditCardTokens {
    
    // When:
    [handler saveAuthorizedCreditCard:firstCard];
    [handler saveAuthorizedCreditCard:secondCard];
    [handler saveAuthorizedCreditCard:thirdCard];
    
    // Then:
    XCTAssertTrue([[handler authorizedCards] containsObject:firstCard], "The handler should contain the firstCard object.");
    XCTAssertTrue([[handler authorizedCards] containsObject:secondCard], "The handler should contain the secondCard object.");
    XCTAssertTrue([[handler authorizedCards] containsObject:thirdCard], "The handler should contain the thirdCard object.");
    
    // When:
    [handler removeAuthorizedCreditCard:firstCard];
    [handler removeAuthorizedCreditCard:thirdCard];
    
    // Then:
    XCTAssertFalse([[handler authorizedCards] containsObject:firstCard], "The handler should not contain the firstCard object.");
    XCTAssertTrue([[handler authorizedCards] containsObject:secondCard], "The handler should contain the secondCard object.");
    XCTAssertFalse([[handler authorizedCards] containsObject:thirdCard], "The handler should not contain the thirdCard object.");
}

- (void)tearDown {
    [handler removeAuthorizedCreditCard:firstCard];
    [handler removeAuthorizedCreditCard:secondCard];
    [handler removeAuthorizedCreditCard:thirdCard];
    [super tearDown];
}

@end