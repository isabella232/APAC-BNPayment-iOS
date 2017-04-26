//
//  BNCreditCardEndpoint.h
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

@class BNCCHostedFormParams;
@class BNRegisterCCParams;
@class BNAuthorizedCreditCard;
@class BNEncryptionCertificate;

@import Foundation;

/**
 *  A block object to be executed when a credit card hosted form URL operation has completed.
 *  The block returns a String containing the url to load in order to load the registration form and
 *  a `NSError` representing the error received. Error is nil if operation is successful.
 *
 *  @param url `NSString`
 *  @param error `NSError`
 */
typedef void (^BNCreditCardUrlBlock)(NSString *url, NSError *error);


/**
 *  A block object to be executed when a credit card registration operation has completed.
 *  The block returns a `BNAuthorizedCard` containing the authorized credit card and
 *  a `NSError` representing the error received. Error is nil if operation is successful.
 *
 *  @param BNAuthorizedCreditCard   `BNAuthorizedCard`
 *  @param error                    `NSError`
 */
typedef void (^BNCreditCardRegistrationBlock)(BNAuthorizedCreditCard *card, NSError *error);

/**
 *  A block object to be executed when a encryption cert operation has completed.
 *  The block returns a `NSArray` `BNEncryptionCertificate` models and
 *  a `NSError` representing the error received. Error is nil if operation is successful.
 *
 *  @param encryptionCertificates   An array of `BNEncryptionCertificate`
 *  @param error                    `NSError`
 */
typedef void (^BNEncryptionCertBlock)(NSArray<BNEncryptionCertificate *> *encryptionCertificates, NSError *error);

/**
 `BNCreditCardEndpoint` is a subclass of `BNBaseEndpoint`
 `BNCreditCardEndpoint` offers convenient methods for handling credit card API calls.
 */
@interface BNCreditCardEndpoint : NSObject

///------------------------------------------------
/// @name Credit card registration methods
///------------------------------------------------

/**
*  Initiate Credit card registration form URL operation.
*
*  @param formParams `BNCCHostedFormParams` params to the request.
*  @param completion `BNCreditCardUrlBlock` block to be executed when the initiate credit card registration operation is finished.
*
*  @return `NSURLSessionDataTask`
*/
+ (NSURLSessionDataTask *)initiateCreditCardRegistrationForm:(BNCCHostedFormParams *)formParams
                                                  completion:(BNCreditCardUrlBlock)completion;

/**
 *  Register a credit card in order to retrieve an authorized card used for payments.
 *
 *  @param params     `BNRegisterCCParams`
 *  @param completion `BNCreditCardRegistrationBlock`
 *
 *  @return `NSURLSessionDataTask`
 */
+ (NSURLSessionDataTask *)registerCreditCard:(BNRegisterCCParams *)params
                                  completion:(BNCreditCardRegistrationBlock)completion;

/**
 *  Fetching credit card encryption certificates.
 *
 *  @param completion `BNEncryptionCertBlock`
 *
 *  @return `NSURLSessionDataTask`
 */
+ (NSURLSessionDataTask *)encryptionCertificatesWithCompletion:(BNEncryptionCertBlock)completion;

@end
