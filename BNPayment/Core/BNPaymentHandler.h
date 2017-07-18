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
#import "BNPaymentResponse.h"

@import Foundation;

@class BNAuthorizedCreditCard;
@class BNCCHostedFormParams;
@class BNAuthorizedCreditCard;
@class BNRegisterCCParams;
@class BNPaymentParams;
@class BNHTTPClient;
    


/**
 *  A block object to be executed when an extra payment payment is required
 * Currently, the only valid option is TouchID
 *
 */
typedef NSError* (^BNExtraPaymentValidationBlock) ();


/**
 *  A block object to be executed when a payment operation has completed.
 *  The block returns an enum representing the result of the Payment operation.
 *  If success, 'response' return backend provided information like 'receipt' number
 *
 *  @param result `BNPaymentResult`.
 */
typedef void (^BNPaymentExtBlock) (NSDictionary<NSString*, NSString*> * response, BNPaymentResult result, NSError *error);


/**
 *  A block object to be executed when a single payment operation has completed.
 *  The block returns an enum representing the result of the Payment operation.
 *  If success, 'response' return backend provided information like 'receipt' number
 *     also the payment response response.
 *  @param result `BNSinglePaymentExtBlock`.
 */
typedef void (^BNSinglePaymentExtBlock) (NSDictionary<NSString*, NSString*> * response, BNAuthorizedCreditCard *authorizedCreditCard, BNPaymentResult result, NSError *error);



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
 *  Make Payment Ext (old method)
 *
 *  @param paymentParams `BNPaymentParams` params to the request.
 *  @param identifier    `NSString` prepresenting the payment identidier.
 *  @param requirePaymentValidation If set and if the SDK's extra validation hook is set
 *                        then call the extra validation code before proceeding with payment.
 *  @param result The block to be executed when Payment operation is finished.
 *
 *  @return `NSURLSessionDataTask`
 *
 *  Note: 
 *  It is not enough to set the 'requirePaymentValidation' parameter to YES for 'Touch ID dialog' to appear.
 *  You need also to enable the SDK for Touch ID validation (see [BNTouchIDValidation enable])
 *
 */
- (NSURLSessionDataTask *)makePaymentExtWithParams:(BNPaymentParams *)paymentParams
                          requirePaymentValidation:(BOOL)requirePaymentValidation
                                            result:(BNPaymentExtBlock) result;



/**
 *  Submit Single Payment With Token
 *
 *  @param paymentParams `BNPaymentParams` params to the request.
 *  @param identifier    `NSString` prepresenting the payment identidier.
 *  @param requirePaymentValidation If set and if the SDK's extra validation hook is set
 *                        then call the extra validation code before proceeding with payment.
 *  @param result The block to be executed when Payment operation is finished.
 *
 *  @return `NSURLSessionDataTask`
 *
 *  Note:
 *  It is not enough to set the 'requirePaymentValidation' parameter to YES for 'Touch ID dialog' to appear.
 *  You need also to enable the SDK for Touch ID validation (see [BNTouchIDValidation enable])
 *
 */
- (NSURLSessionDataTask *)submitSinglePaymentToken:(BNPaymentParams *)paymentParams
                          requirePaymentValidation:(BOOL)requirePaymentValidation
                                            result:(BNPaymentExtBlock) result;






/**
 *  Submit Single Payment With Card
 *
 *  @param paymentParams `BNPaymentParams` params to the request.
 *  @param identifier    `NSString` prepresenting the payment identidier.
 *  @param requirePaymentValidation If set and if the SDK's extra validation hook is set
 *                        then call the extra validation code before proceeding with payment.
 *  @param requireSaveCard If set, save the credit card on the device.
 *  @param result The block to be executed when Payment operation is finished.
 *
 *  @return `NSURLSessionDataTask`
 *
 *  Note:
 *  It is not enough to set the 'requirePaymentValidation' parameter to YES for 'Touch ID dialog' to appear.
 *  You need also to enable the SDK for Touch ID validation (see [BNTouchIDValidation enable])
 *  
 */
- (NSURLSessionDataTask *)submitSinglePaymentCard:(BNPaymentParams *)paymentParams
                          requirePaymentValidation:(BOOL)requirePaymentValidation
                                         requireSaveCard: (BOOL) requireSaveCard
                                            completion:(BNSinglePaymentExtBlock) completion;



/**
 *  Submit Single Payment With ApplePay
 *
 *  @param paymentParams `BNPaymentParams` params to the request.
 *                        NOTE: Apple Pay and normal payment use the same param structure
 *  @param identifier    `NSString` prepresenting the payment identidier.
 *  @param result The block to be executed when Payment operation is finished.
 *
 *  @return `NSURLSessionDataTask`
 */
- (NSURLSessionDataTask *)submitSinglePaymentApplePay:(BNPaymentParams *)paymentParams
                                                 result:(BNPaymentExtBlock) result;





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

/**
 *  A method for registering extra payment validation
 *
 *  @param hook This block will be executed before each payment
 */
-(void) registerExtraPaymentValidationHook:(BNExtraPaymentValidationBlock) hook;

@end
