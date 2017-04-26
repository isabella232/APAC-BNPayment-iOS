//
//  EPAYHostedFormStateChange.h
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

@class EPAYMetaResponse;
@class BNAuthorizedCreditCard;

static NSInteger const EPAYSubmissionStarted = 100;     // Ajax request started
static NSInteger const EPAYSuccess = 200;               // Ajax request successfully completed and card is registered, call generateAuthorizedCard in order to retrieve the card.
static NSInteger const EPAYSubmissionDeclined = 300;    // Ajax request failed
static NSInteger const EPAYSystemError = 1000;          // System error
static NSInteger const EPAYUnknown = 9999;              // Unknown

@interface EPAYHostedFormStateChange : BNBaseModel

@property (nonatomic, strong) EPAYMetaResponse *meta;
@property (nonatomic, strong) NSString *truncatedCardNumber;
@property (nonatomic, strong) NSNumber *expiryMonth;
@property (nonatomic, strong) NSNumber *expiryYear;
@property (nonatomic, strong) NSString *paymentType;
@property (nonatomic, strong) NSString *subscriptionId;

- (BNAuthorizedCreditCard *)generateAuthorizedCard;

- (NSInteger)status;

@end
