//
//  BNPaymentWebview.h
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

@import WebKit;

@class EPAYHostedFormStateChange;
@class BNCCHostedFormParams;
@class BNPaymentWebview;
@class BNAuthorizedCreditCard;

/**
 *  `BNPaymentWebviewOperation`
 */
typedef enum BNPaymentWebviewOperation : NSUInteger {
    BNPWVOperationFetchURL,     // Fetches a URL to load in the webview.
    BNPWVOperationLoadURL,      // Load the URL received in the webview.
    BNPWVOperationSubmitCCData  // The user submits the credit card form.
} BNPaymentWebviewOperation;

@protocol BNPaymentWebviewDelegate <NSObject>

/**
 *  An authorized card is registered.
 *
 *  @param webview        The webview that contains the form.
 *  @param authorizedCard The actual authorized card registered.
 */
- (void)BNPaymentWebview:(BNPaymentWebview *)webview didRegisterAuthorizedCard:(BNAuthorizedCreditCard *)authorizedCard;

/**
 *  An operation did start.
 *
 *  @param webview        The webview that contains the form.
 *  @param operation      The operation started.
 */
- (void)BNPaymentWebview:(BNPaymentWebview *)webview didStartOperation:(BNPaymentWebviewOperation)operation;

/**
 *  An operation did finish successfully.
 *
 *  @param webview        The webview that contains the form.
 *  @param operation      The operation that finished.
 */
- (void)BNPaymentWebview:(BNPaymentWebview *)webview didFinishOperation:(BNPaymentWebviewOperation)operation;

/**
 *  An operation did fail
 *
 *  @param webview        The webview that contains the form.
 *  @param operation      The operation that failed.
 *  @param error          The error that occured.
 */
- (void)BNPaymentWebview:(BNPaymentWebview *)webview didFailOperation:(BNPaymentWebviewOperation)operation withError:(NSError *)error;

@end

@interface BNPaymentWebview : WKWebView

@property (nonatomic, weak) id <BNPaymentWebviewDelegate> delegate;

/**
 *  Load the webview form with the `BNCCHostedFormParams` specified as input parameter.
 *
 *  @param params Params used to configure the form.
 */
- (void)loadPaymentWebviewWithParams:(BNCCHostedFormParams *)params;

@end
