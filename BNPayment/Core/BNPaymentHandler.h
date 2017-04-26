//
//  BNPaymentHandler.h
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
#import "BNCreditCardEndpoint.h"

@import Foundation;

@class BNAuthorizedCreditCard;
@class BNCCHostedFormParams;
@class BNAuthorizedCreditCard;
@class BNRegisterCCParams;
@class BNPaymentParams;
@class BNApplePayPaymentParams;
@class BNHTTPClient;
    
/**
 *  A block object to be executed when a payment operation has completed.
 *  The block returns an enum representing the result of the Payment operation.
 *
 *  @param result `BNPaymentResult`.
 */
typedef void (^BNPaymentBlock) (BNPaymentResult result, NSError *error);

/**
 *  A block object to be executed when a payment operation has completed.
 *  The block returns an enum representing the result of the Payment operation.
 * If success, 'response' return backend provided information like 'receipt' number
 *
 *  @param result `BNPaymentResult`.
 */
typedef void (^BNPaymentExtBlock) (NSDictionary<NSString*, NSString*> * response, BNPaymentResult result, NSError *error);

/**
 *  A block object to be executed when a apple pay payment operation has completed.
 *  The block returns an enum representing the result of the Payment operation.
 *
 *  @param result `BNPaymentResult`.
 */
typedef void (^BNApplePayPaymentBlock) (BNPaymentResult result, NSError *error);

/**
 *  A block object to be executed when a credit card registration operation has completed.
 *  The block returns a String containing the url to load in order to register a credit card
 *  `NSError` representing the error received. Error is nil if operation is successful.
 *
 *  @param url `NSString`.
 *  @param error `NSError`.
 */
typedef void (^BNCreditCardRegistrationUrlBlock)(NSString *url, NSError *error);

@interface BNPaymentHandler : NSObject

/** 
 *  Returns a `BNPaymentHandler` shared instance, creating it if necessary.
 *
 *  @return The shared `BNPaymentHandler` instance.
 */
+ (BNPaymentHandler *)sharedInstance;

///------------------------------------------------
/// @name Setting up handler and access `BNPaymentHandler` instance
///------------------------------------------------

/** 
 *  Setup `BNPaymentHandler` with an APIToken.
 *
 *  Sets up `BNPaymentHandler` with an APIToken that will be used
 *  to authenticate the application to the back end.
 *
 *  @param apiToken Api-token to be used
 *  @param error Possible error that can occur during initialization
 */
+ (BOOL)setupWithApiToken:(NSString *)apiToken
                  baseUrl:(NSString *)baseUrl
                    debug:(BOOL)debug
                    error:(NSError **)error;

/** 
 * Setup `BNPaymentHandler` with a Merchant Account.
 *
 * Sets up `BNPaymentHandler` with a Merchant Account that will be
 * used to authenticate the application to the back end.
 *
 * @param merchantAccount Merchant-Account number to be used
 * @param error Possible error that can occur during initialization
 */
+ (BOOL)setupWithMerchantAccount:(NSString *)merchantAccount
                  baseUrl:(NSString *)baseUrl
                    debug:(BOOL)debug
                    error:(NSError **)error;

///------------------------------------------------
/// @name Getting user and app information
///------------------------------------------------

/**
 *  Return the `BNHTTPClient` used by the handler
 *
 *  @return A `BNHTTPClient` associated with the handler
 */
- (BNHTTPClient *)getHttpClient;

/**
 *  Get the API token associated with this `BNPaymentHandler`
 *
 *  @return A string representing the API token associated with this `BNPaymentHandler`
 */
- (NSString *)getApiToken;

/**
 *  Get the Merchant Account Number associated with this `BNPaymentHandler`
 *
 *  @return A string representing the MerchantAccountNumber associated with this `BNPaymentHandler`
 */
- (NSString *)getMerchantAccount;

/**
 *  Get the base URL for the backend
 *
 *  @return A `NSString` containing the base URL
 */
- (NSString *)getBaseUrl;

/**
 *  Get debug flag value
 *
 *  @return A `BOOL` indicating if lib is in debug mode
 */
- (BOOL)debugMode;

/**
 *  A method for refreshing the encryption certificates
 */
- (void)refreshCertificates;

/**
 *  Initiate Credit card registration.
 *
 *  @param params `BNCCHostedFormParams` request params.
 *  @param block `BNCreditCardUrlBlock` block to be executed when the initiate credit card registration operation is finished.
 *
 *  @return `NSURLSessionDataTask`
 */
- (NSURLSessionDataTask *)initiateCreditCardRegistrationWithParams:(BNCCHostedFormParams *)params
                                                        completion:(BNCreditCardRegistrationUrlBlock) block;

/**
 *  Make Payment
 *
 *  @param paymentParams `BNPaymentParams` params to the request.
 *  @param identifier    `NSString` prepresenting the payment identidier.
 *  @param result The block to be executed when Payment operation is finished.
 *
 *  @return `NSURLSessionDataTask`
 */
- (NSURLSessionDataTask *)makePaymentWithParams:(BNPaymentParams *)paymentParams
                                         result:(BNPaymentBlock) result;


//[[]]c remove makePaymentWithParams?
/**
 *  Make Payment Ext
 *
 *  @param paymentParams `BNPaymentParams` params to the request.
 *  @param identifier    `NSString` prepresenting the payment identidier.
 *  @param result The block to be executed when Payment operation is finished.
 *
 *  @return `NSURLSessionDataTask`
 */
- (NSURLSessionDataTask *)makePaymentExtWithParams:(BNPaymentParams *)paymentParams
                                            result:(BNPaymentExtBlock) result;


/**
 *  Make Apple Pay Payment
 *
 *  @param paymentParams `BNApplePayPaymentParams` params to the request.
 *  @param identifier    `NSString` prepresenting the payment identidier.
 *  @param result The block to be executed when Payment operation is finished.
 *
 *  @return `NSURLSessionDataTask`
 */
- (NSURLSessionDataTask *)makeApplePayPaymentWithParams:(BNApplePayPaymentParams *)paymentParams
                                                 result:(BNApplePayPaymentBlock) result;

/**
 *  Register a credit card in order to retrieve an authorized card used for payments.
 *
 *  @param params     `BNRegisterCCParams`
 *  @param completion `BNCreditCardRegistrationBlock`
 *
 *  @return `NSURLSessionDataTask`
 */
- (NSURLSessionDataTask *)registerCreditCard:(BNRegisterCCParams *)params
                                  completion:(BNCreditCardRegistrationBlock)completion;

/**
 *  A method for retrieveing an array of authorized cards previously saved.
 *
 *  @return An Array of authorized credit cards.
 */
- (NSArray <BNAuthorizedCreditCard *>*)authorizedCards;

/**
 *  A method for saving an authorized credit card model and persist it to disk.
 *
 *  @param tokenizedCreditCard The authorized card to save.
 */
- (void)saveAuthorizedCreditCard:(BNAuthorizedCreditCard *)authorizedCreditCard;

/**
 *  A method for removing a saved authorized card from disk.
 *
 *  @param tokenizedCreditCard The authorized card to remove.
 */
- (void)removeAuthorizedCreditCard:(BNAuthorizedCreditCard *)authorizedCreditCard;

@end
