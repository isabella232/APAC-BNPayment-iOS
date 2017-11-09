//
//  BNSubmitSinglePaymentWithCardVC.h
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

#import "BNEnums.h"
#import "BNPaymentParams.h"
#import "BNPaymentBaseVC.h"
#import "BNSubmitSinglePaymentCardGuiSetting.h"
#import "BNPaymentType.h"

@class BNCreditCard;
@class BNAuthorizedCreditCard;

/**
 *  A block indicating whether or not the `BNSubmitSinglePaymentVC` is done
 *
 *  @param success The status of the operation
 */
typedef void(^BNSubmitSinglePaymentFormCompletion)(NSDictionary<NSString*, NSString*> * response, BNAuthorizedCreditCard *authorizedCreditCard, BNPaymentResult result, NSError *error);

@interface BNSubmitSinglePaymentCardVC : BNPaymentBaseVC

//payment params allows sdk user passed in amount, currency etc for the payment.
@property (nonatomic, strong) BNPaymentParams *paymentParams;


@property (nonatomic, strong) BNSubmitSinglePaymentCardGuiSetting *guiSetting;

@property (nonatomic) BOOL isRequirePaymentAuthorization;


@property (nonatomic, copy) BNSubmitSinglePaymentFormCompletion completionBlock;

@property (nonatomic) PaymentType paymentType;

@end

