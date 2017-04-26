//
//  BNCCHostedRegistrationFormVC.h
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
#import "BNPaymentBaseVC.h"
#import "BNPaymentWebview.h"

@import WebKit;

@class BNCCHostedFormParams;
@class BNAuthorizedCreditCard;
@class BNCCHostedRegistrationFormVC;

/**
 *  `BNCCHostedRegistrationFormVC` is a view controller that displays a webview containing a credit card registration form.
 */
@interface BNCCHostedRegistrationFormVC : BNPaymentBaseVC

/**
 *  BNPaymentWebviewDelegate delegate.
 */
@property(nonatomic, weak) id <BNPaymentWebviewDelegate> webviewDelegate;

/**
 *  An init method where you provide the params for the hosted form
 *
 *  @param params `BNCCHostedFormParams` used for requesting an URL for the hosted form
 *
 *  @return return an instance of `BNCCHostedRegistrationFormVC`
 */
- (instancetype)initWithHostedFormParams:(BNCCHostedFormParams *)params;

/**
 *  A method for setting the header view
 *
 *  @param headerView A `UIView` to be set as header
 */
- (void)addHeaderView:(UIView *)headerView;

/**
 *  A method for setting the footer view
 *
 *  @param footerView A `UIView` to be set as footer
 */
- (void)addFooterView:(UIView *)footerView;

/**
 *  This method is used for setting the loading state of the view controller.
 *
 *  @param isLoading `BOOL` for loading state.
 */
- (void)setWebViewLoading:(BOOL)isLoading;

@end
