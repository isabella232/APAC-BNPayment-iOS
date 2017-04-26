//
//  UITextField+BNCreditCardTests.m
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

@interface UITextFieldBNCreditCardTests : XCTestCase

@end

@implementation UITextFieldBNCreditCardTests

- (void)testValidateValidCardNumber {

    // Given:
    BNCreditCardNumberTextField *cardNumberTextField = [BNCreditCardNumberTextField new];
    cardNumberTextField.text = @"4002620000000005";

    // When:
    BOOL cardNumberValidity = [cardNumberTextField validCardNumber];

    // Then:
    XCTAssert(cardNumberValidity == true, "The validation should have succeeded.");

}

- (void)testInvalidateValidCardNumber {

    // Given:
    BNCreditCardNumberTextField *cardNumberTextField = [BNCreditCardNumberTextField new];
    cardNumberTextField.text = @"874905873945872380495234987235902340957230984572309845720938475093287450928347509283475098237459082374523452345";

    // When:
    BOOL cardNumberValidity = [cardNumberTextField validCardNumber];

    // Then:
    XCTAssert(cardNumberValidity == false, "The validation should have failed.");
}

- (void)testValidateValidExpiryDate {

    // Given:
    BNCreditCardExpiryTextField *expiryTextField = [BNCreditCardExpiryTextField new];
    expiryTextField.text = @"01/18";

    // When:
    BOOL expiryDateValidity = [expiryTextField validExpiryDate];

    // Then:
    XCTAssert(expiryDateValidity == true, "The validation should have succeeded.");
}

- (void)testValidateInvalidExpiryDate {

    // Given:
    BNCreditCardExpiryTextField *expiryTextField = [BNCreditCardExpiryTextField new];
    expiryTextField.text = @"00/00";

    // When:
    BOOL expiryDateValidity = [expiryTextField validExpiryDate];

    // Then:
    XCTAssert(expiryDateValidity == false, "The validation should have failed.");
}

- (void)testValidateValidCVC {

    // Given:
    BNCreditCardExpiryTextField *cvcTextField = [BNCreditCardExpiryTextField new];
    cvcTextField.text = @"123";

    // When:
    BOOL cvcValidity = [cvcTextField validCVC];

    // Then:
    XCTAssert(cvcValidity == true, "The validation should have succeeded.");
}

- (void)testValidateInvalidCVC {

    // Given:
    BNBaseTextField *cvcTextField = [BNBaseTextField new];
    cvcTextField.text = @"98769876986698769867";

    // When:
    BOOL cvcValidity = [cvcTextField validCVC];

    // Then:
    XCTAssert(cvcValidity == false, "The validation should have failed.");
}

- (void)testVISAValidation {

    // Given:
    BNCreditCardNumberTextField *cardNumberTextField = [BNCreditCardNumberTextField new];
    cardNumberTextField.text = @"4002620000000005";

    // When:
    BOOL cardNumberValidity = [cardNumberTextField isVisaCardNumber:cardNumberTextField.text];

    // Then:
    XCTAssert(cardNumberValidity == true, "The validation should have succeeded.");
}

- (void)testVISAValidationNegativeTest {

    // Given:
    BNCreditCardNumberTextField *cardNumberTextField = [BNCreditCardNumberTextField new];
    cardNumberTextField.text = @"5125860000000006";

    // When:
    BOOL cardNumberValidity = [cardNumberTextField isVisaCardNumber:cardNumberTextField.text];

    // Then:
    XCTAssert(cardNumberValidity == false, "The validation should have failed.");
}

- (void)testMasterCardValidation {

    // Given:
    BNCreditCardNumberTextField *cardNumberTextField = [BNCreditCardNumberTextField new];
    cardNumberTextField.text = @"5125860000000006";

    // When:
    BOOL cardNumberValidity = [cardNumberTextField isMasterCardNumber:cardNumberTextField.text];

    // Then:
    XCTAssert(cardNumberValidity == true, "The validation should have succeeded.");

}

- (void)testMasterCardValidationNegativeTest {

    // Given:
    BNCreditCardNumberTextField *cardNumberTextField = [BNCreditCardNumberTextField new];
    cardNumberTextField.text = @"4002620000000005";

    // When:
    BOOL cardNumberValidity = [cardNumberTextField isMasterCardNumber:cardNumberTextField.text];

    // Then:
    XCTAssert(cardNumberValidity == false, "The validation should have failed.");

}

- (void)testTextColorInValidTextField {

    // Given:
    BNCreditCardNumberTextField *cardNumberTextField = [BNCreditCardNumberTextField new];

    // When:
    [cardNumberTextField setTextfieldValid:true];

    // Then:
    XCTAssert(cardNumberTextField.textColor == [UIColor blackColor], "The text color should have been black.");

}

- (void)testTextColorInInvalidTextField {
    // Given:
    BNCreditCardNumberTextField *cardNumberTextField = [BNCreditCardNumberTextField new];

    // When:
    [cardNumberTextField setTextfieldValid:false];

    // Then:
    XCTAssert(cardNumberTextField.textColor == [UIColor redColor], "The text color should have been red.");

}

- (void)testTextFieldStyling {

    // Given:
    BNCreditCardNumberTextField *cardNumberTextField = [BNCreditCardNumberTextField new];

    // When:
    [cardNumberTextField applyStyle];

    // Then:
    XCTAssert(CGColorEqualToColor(cardNumberTextField.layer.borderColor, [[UIColor colorWithRed:220/255.f green:221/255.f blue:222/255.f alpha:1] CGColor]),
              "Incorrect tintColor - it should have been UIColor colorWithRed:220/255.f green:221/255.f blue:222/255.f alpha:1]");

    XCTAssert(cardNumberTextField.layer.borderWidth == 1.f,
              "Incorrect layer.borderWidth value - it shuould have been 1.f.");

    XCTAssert(cardNumberTextField.keyboardType == UIKeyboardTypeNumberPad,
              "Incorrect keyboardType - it should have been UIKeyboardTypeNumberPad.");

    XCTAssert(CGColorEqualToColor(cardNumberTextField.tintColor.CGColor,[UIColor BNPurpleColor].CGColor),
              "Incorrect tintColor - it should have been [UIColor BNPurpleColor].");

    XCTAssert(cardNumberTextField.font == [UIFont systemFontOfSize:16.f],
              "Incorrect font - it should have been [UIFont systemFontOfSize:16.f].");
}

@end
