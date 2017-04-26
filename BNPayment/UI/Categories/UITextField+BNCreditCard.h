//
//  UITextField+BNCreditCard.h
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

#import <UIKit/UIKit.h>

@interface UITextField (BNCreditCard)

extern NSString *const CreditCardRegex;

/**
 *  A method for applying default style to UITextField
 */
- (void)applyStyle;
- (void)applyAlphaNumericalStyle;

/**
 *  A method for styling the textfield.
 *  Invalid textfield will have red text color.
 *  Valid textfield will have black text color.
 *
 *  @param valid `BOOL`
 */
- (void)setTextfieldValid:(BOOL)valid;

    
/**
 *  Validate card number according regex: ^(?:\\d[ -]*?){16}$
 *
 *  @return `BOOL` indicating whether or not regex validation passed.
 */
    - (BOOL)validCardNumber;


/**
 *  Validate card holder: Any alphanumerical char
 *
 *  @return `BOOL` indicating whether or not regex validation passed.
 */
- (BOOL)validCardHolder ;


/**
 *  Validate card cvc according regex: ^[0-9]{3,4}$
 *
 *  @return `BOOL` indicating whether or not regex validation passed.
 */
- (BOOL)validCVC;

/**
 *  Validate card cvc according regex: ^[0-9]{3,4}$.
 *  and that the date is in the future.
 *
 *  @return `BOOL` indicating whether or not regex validation passed.
 */
- (BOOL)validExpiryDate;

/**
 *  Check if input is a Visa card.
 *
 *  @return `BOOL` indicating whether or not input represents VISA card.
 */
- (BOOL)isVisaCardNumber:(NSString *)cardNumber;

/**
 *  Check if input is a MasterCard card.
 *
 *  @return `BOOL` indicating whether or not input represents MasterCard.
 */
- (BOOL)isMasterCardNumber:(NSString *)cardNumber;

/**
 *  Check if input is an Amex card.
 *
 *  @return `BOOL` indicating whether or not input represents Amex.
 */
- (BOOL)isAmexCardNumber:(NSString *)cardNumber;

/**
 *  Check if input is a Diners Club card.
 *
 *  @return `BOOL` indicating whether or not input represents Diners Club.
 */
- (BOOL)isDinersClubCardNumber:(NSString *)cardNumber;

@end
