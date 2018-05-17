//
//  BNPaymentHandler.m
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


#import "BNPaymentHandler.h"
#import "BNPaymentEndpoint.h"
#import "BNApplePayPaymentEndpoint.h"
#import "BNCreditCardEndpoint.h"
#import "BNAuthorizedCreditCard.h"
#import "BNCacheManager.h"
#import "BNCCHostedFormParams.h"
#import "BNRegisterCCParams.h"
#import "BNPaymentParams.h"
#import "BNHTTPClient.h"
#import "BNCertManager.h"
#import "BNPaymentResponse.h"

#define kDefaultPaymentValidation @"none"
#define kApplePayPaymentValidation @"applepay"
#define kAppleTouchIdPaymentValidation @"appletouchid";



static NSString *const TokenizedCreditCardCacheName = @"tokenizedCreditCardCacheName";
static NSString *const SharedSecretKeychainKey = @"sharedSecret";
static NSString *const DefaultBaseUrl = @"https://eu-native.bambora.com";

static NSString *const existingMerchantAccountKey = @"BamboraMerchantAccount";
static NSString *const existingBaseURLKey = @"BamboraBaseURL";


@interface BNPaymentHandler ()

@property (nonatomic, strong) NSMutableArray<BNAuthorizedCreditCard *> *tokenizedCreditCards;
@property (nonatomic, strong) NSString *apiToken;
@property (nonatomic, strong) NSString *merchantAccount;
@property (nonatomic, assign) BOOL debug;
@property (nonatomic, strong) NSString *baseUrl;
@property (nonatomic, strong) BNHTTPClient *httpClient;
@property (nonatomic) BNExtraPaymentValidationBlock extraPaymentValidationBlock;

@end

@implementation BNPaymentHandler

+ (BNPaymentHandler *)sharedInstance {
    static BNPaymentHandler *_sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[BNPaymentHandler alloc] init];
        [_sharedInstance setupBNPaymentHandler];
    });
    
    return _sharedInstance;
}

+(NSString*) checkBaseUrl:(NSString *)url
{
    if (url == nil || [url isEqualToString:@""]){
        return DefaultBaseUrl;
    }
    NSMutableString* u = [NSMutableString stringWithString:[url stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
    if(![u hasSuffix:@"/"]){
        [u appendString:@"/"];
    }
    return u;
}

+ (void)setupCommon:(NSString *)baseUrl
              debug:(BOOL)debug {
    BNPaymentHandler *handler = [BNPaymentHandler sharedInstance];
    NSString* url = [BNPaymentHandler checkBaseUrl:baseUrl];
    handler.baseUrl = url; 
    handler.debug = debug;
    handler.httpClient = [[BNHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:handler.baseUrl]];
    [handler.httpClient enableLogging:debug];
    if([[BNCertManager sharedInstance] shouldUpdateCertificates]) {
        [handler refreshCertificates];
    }
}

+ (BOOL)setupWithApiToken:(NSString *)apiToken
                  baseUrl:(NSString *)baseUrl
                    debug:(BOOL)debug
                    error:(NSError **)error {
    
    BNPaymentHandler *handler = [BNPaymentHandler sharedInstance];
    handler.apiToken = apiToken;
    [self setupCommon:baseUrl debug:debug];
    return error == nil;
}


+ (BOOL)setupWithMerchantAccount:(NSString *)merchantAccount
                  baseUrl:(NSString *)baseUrl
                    debug:(BOOL)debug
                    error:(NSError **)error {
    
    BNPaymentHandler *handler = [BNPaymentHandler sharedInstance];
    handler.merchantAccount = merchantAccount;
    [self setupCommon:baseUrl debug:debug];
    [self checkMerchant:merchantAccount AndEnvironment:baseUrl];
    return error == nil;
}


+ (void)checkMerchant:(NSString *)merchantAccount AndEnvironment:(NSString *)baseURL{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *existingMerchantAccount=[userDefaults objectForKey:existingMerchantAccountKey];
    NSString *existingBaseURL=[userDefaults objectForKey:existingBaseURLKey];
    
    if(existingMerchantAccount==nil || existingBaseURL==nil)
    {
        [userDefaults setObject:merchantAccount forKey:existingMerchantAccountKey];
        [userDefaults setObject:baseURL forKey:existingBaseURLKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else if(![existingMerchantAccount isEqualToString:merchantAccount] || ![existingBaseURL isEqualToString:baseURL])
    {
         [self removeAllAuthorizedCreditCards];
         [userDefaults setObject:merchantAccount forKey:existingMerchantAccountKey];
         [userDefaults setObject:baseURL forKey:existingBaseURLKey];
         [[NSUserDefaults standardUserDefaults] synchronize];
    }
}


- (void)setupBNPaymentHandler {
    id cachedCards = [[BNCacheManager sharedCache] getObjectWithName:TokenizedCreditCardCacheName];
    
    self.tokenizedCreditCards = [NSMutableArray new];
    
    if ([cachedCards isKindOfClass:[NSArray class]]) {
        self.tokenizedCreditCards = [cachedCards mutableCopy];
    }
    self.extraPaymentValidationBlock =  nil;
}

- (BNHTTPClient *)getHttpClient {
    return self.httpClient;
}

- (NSString *)getApiToken {
    return self.apiToken;
}

- (NSString *)getMerchantAccount {
    return self.merchantAccount;
}

- (NSString *)getBaseUrl {
    return self.baseUrl;
}

- (BOOL)debugMode {
    return self.debug;
}

- (void)refreshCertificates {
    [BNCreditCardEndpoint encryptionCertificatesWithCompletion:^(NSArray *encryptionCertificates, NSError *error) {
        
    }];
}

- (NSURLSessionDataTask *)initiateCreditCardRegistrationWithParams:(BNCCHostedFormParams * )params
                                                        completion:(BNCreditCardRegistrationUrlBlock) block {
    NSURLSessionDataTask *dataTask = [BNCreditCardEndpoint initiateCreditCardRegistrationForm:params
                                                                                   completion:^(NSString *url, NSError *error) {
        block(url, error);
    }];
    
    return dataTask;
}


-(NSURLSessionDataTask *)getVisaCheckoutWithCompletionHandler:(void(^)(VisaCheckoutLaunchParams* visaCheckoutLaunchParams,NSError* error))completionHandler{
    
    NSURLSessionDataTask *dataTask = [VisaCheckoutEndpoint getVisaCheckoutWithCompletionHandler:^(VisaCheckoutLaunchParams *visaCheckoutLaunchParams, NSError *error) {
        completionHandler(visaCheckoutLaunchParams,error);
    }];
    return dataTask;
}


-(NSURLSessionDataTask *)processTransactionFromVisaCheckout:(VisaCheckoutTransactionParams*)visaCheckoutTransactionParams WithCompletionHandler:(void(^)(VisaCheckoutResponse* visaCheckoutResponse,NSError* error))completionHandler{
    
    
    NSURLSessionDataTask *dataTask = [VisaCheckoutEndpoint processTransactionFromVisaCheckout:visaCheckoutTransactionParams WithCompletionHandler:^(VisaCheckoutResponse *visaCheckoutResponse, NSError *error) {
        completionHandler(visaCheckoutResponse,error);
    }];
    return dataTask;
}





- (NSURLSessionDataTask *)registerCreditCard:(BNRegisterCCParams *)params
                                  completion:(BNCreditCardRegistrationBlock)completion {
    NSURLSessionDataTask *dataTask = [BNCreditCardEndpoint registerCreditCard:params completion:^(BNAuthorizedCreditCard *card, NSError *error) {
        if(card) {
            [self saveAuthorizedCreditCard:card];
        }
        completion(card, error);
    }];
    return dataTask;
}

//Temporally keep this old method until product owner get feedback from client.
- (NSURLSessionDataTask *)makePaymentExtWithParams:(BNPaymentParams *)paymentParams
                          requirePaymentValidation:(BOOL)requirePaymentValidation
                                            result:(BNPaymentExtBlock) result {
    return [self submitTokenPayment:paymentParams
           requirePaymentValidation:requirePaymentValidation
                        paymentType:SubmitPaymentToken
                             result:result];}

//APAC submit single payment token.
- (NSURLSessionDataTask *)submitSinglePaymentToken:(BNPaymentParams *)paymentParams
                          requirePaymentValidation:(BOOL)requirePaymentValidation
                                            result:(BNPaymentExtBlock) result {
    return [self submitTokenPayment:paymentParams
                 requirePaymentValidation:requirePaymentValidation
                              paymentType:SubmitPaymentToken
                              result:result];
}

//APAC submit pre-auth token.
- (NSURLSessionDataTask *)submitPreAuthToken:(BNPaymentParams *)paymentParams
                    requirePaymentValidation:(BOOL)requirePaymentValidation
                                      result:(BNPaymentExtBlock) result {
    return [self submitTokenPayment:paymentParams
           requirePaymentValidation:requirePaymentValidation
                        paymentType:PreAuthToken
                             result:result];
}



//APAC submit token payment, (submitPaymentToken, submitPreAuthToken)
- (NSURLSessionDataTask *)submitTokenPayment:(BNPaymentParams *)paymentParams
                          requirePaymentValidation:(BOOL)requirePaymentValidation
                                 paymentType:(PaymentType)paymentType
                                            result:(BNPaymentExtBlock) result {
    if (requirePaymentValidation && self.extraPaymentValidationBlock != nil ){
        paymentParams.paymentValidation = kAppleTouchIdPaymentValidation;
        if([self isTouchIdCheckValid: result]==false){
            return nil;
        }
    } else {
        paymentParams.paymentValidation = kDefaultPaymentValidation;
    }
    return [self _submitTokenPayment:paymentParams
                               paymentType:paymentType
                                    result:result];
}




- (NSURLSessionDataTask *)_submitTokenPayment:(BNPaymentParams *)paymentParams
                                  paymentType:(PaymentType)paymentType
                                             result:(BNPaymentExtBlock) result
{
    NSURLSessionDataTask *dataTask = [BNPaymentEndpoint authorizePaymentWithParams:paymentParams
                                                                       paymentType: paymentType
                                                                        completion:^(BNPaymentResponse *paymentResponse, NSError *error) {
                                                                            //success
                                                                            if (paymentResponse && paymentResponse.receipt){
                                                                                NSDictionary<NSString*,NSString*> * r = @{@"receipt":paymentResponse.receipt};
                                                                                result(r, BNPaymentSuccess, error);
                                                                            }
                                                                            //fail
                                                                            else {
                                                                                result(nil, paymentResponse ? BNPaymentSuccess : BNPaymentFailure, error);
                                                                            }
                                                                        }];
    
    return dataTask;
}



- (NSURLSessionDataTask *)submitSinglePreAuthCard:(BNPaymentParams *)paymentParams
                         requirePaymentValidation:(BOOL)requirePaymentValidation
                                  requireSaveCard: (BOOL)requireSaveCard
                                       completion:(BNSinglePaymentExtBlock) completion {
    if (requirePaymentValidation && self.extraPaymentValidationBlock != nil ){
        paymentParams.paymentValidation = kAppleTouchIdPaymentValidation;
        if([self isSinglePaymentTouchIdCheckValid: completion]==false){
            return nil;
        }
    } else {
        paymentParams.paymentValidation = kDefaultPaymentValidation;
    }
    
    
    
    NSURLSessionDataTask *dataTask = [self _submitSinglePaymentCard:paymentParams  requireSaveCard:requireSaveCard paymentType: PreAuthCard result:^(NSDictionary<NSString*, NSString*> * response,BNAuthorizedCreditCard *authorizedCreditCard, BNPaymentResult result,NSError *error){
        if(authorizedCreditCard)
        {
            [self saveAuthorizedCreditCard:authorizedCreditCard];
        }
        completion(response, authorizedCreditCard, result, error);
    }];
    
    return dataTask;
}


- (NSURLSessionDataTask *)submitSinglePaymentCard:(BNPaymentParams *)paymentParams
                          requirePaymentValidation:(BOOL)requirePaymentValidation           	
                                  requireSaveCard: (BOOL)requireSaveCard
                                        completion:(BNSinglePaymentExtBlock) completion {
    if (requirePaymentValidation && self.extraPaymentValidationBlock != nil ){
        paymentParams.paymentValidation = kAppleTouchIdPaymentValidation;
        if([self isSinglePaymentTouchIdCheckValid: completion]==false){
            return nil;
        }
    } else {
        paymentParams.paymentValidation = kDefaultPaymentValidation;
    }
    
    
    
    NSURLSessionDataTask *dataTask = [self _submitSinglePaymentCard:paymentParams  requireSaveCard:requireSaveCard paymentType: SubmitPaymentCard result:^(NSDictionary<NSString*, NSString*> * response,BNAuthorizedCreditCard *authorizedCreditCard, BNPaymentResult result,NSError *error){
        if(authorizedCreditCard)
        {
            [self saveAuthorizedCreditCard:authorizedCreditCard];
        }
        completion(response, authorizedCreditCard, result, error);
    }];
    
    return dataTask;
}


- (NSURLSessionDataTask *)_submitSinglePaymentCard:(BNPaymentParams *)paymentParams
                                            requireSaveCard: (BOOL)requireSaveCard
                                            paymentType: (PaymentType)paymentType
                                             result:(BNSinglePaymentExtBlock) result
{
    NSURLSessionDataTask *dataTask = [BNPaymentEndpoint authorizePaymentWithParams:paymentParams
                                                                       paymentType: paymentType
                                                                        completion:^(BNPaymentResponse *paymentResponse, NSError *error) {
                                                                            //success
                                                                            if (paymentResponse && paymentResponse.receipt){
                                                                                NSDictionary<NSString*,NSString*> * r = @{@"receipt":paymentResponse.receipt};
                                                                                if(requireSaveCard)
                                                                                {
                                                                                    BNAuthorizedCreditCard *authorizedCard = [BNAuthorizedCreditCard alloc];
                                                                                    authorizedCard.creditCardNumber = paymentResponse.truncatedCard;
                                                                                    authorizedCard.creditCardToken = paymentResponse.creditCardToken;
                                                                                    authorizedCard.creditCardType = paymentResponse.cardType;
                                                                                    authorizedCard.creditCardHolder = paymentResponse.cardHolderName;
                                                                                    result(r, authorizedCard, BNPaymentSuccess, error);
                                                                                }
                                                                                else{
                                                                                    result(r, nil, BNPaymentSuccess, error);
                                                                                }
                                                                            }
                                                                            //fail
                                                                            else {
                                                                                result(nil, nil, paymentResponse ? BNPaymentSuccess : BNPaymentFailure, error);
                                                                            }
                                                                        }];
    
    return dataTask;
}





- (NSURLSessionDataTask *)submitSinglePaymentApplePay:(BNPaymentParams *)paymentParams
                                                 result:(BNPaymentExtBlock) result {
    paymentParams.paymentValidation = kApplePayPaymentValidation;
    NSURLSessionDataTask *dataTask = [BNApplePayPaymentEndpoint authorizePaymentWithParams:paymentParams
                                                                                completion:^(BNPaymentResponse *paymentResponse, NSError *error) {
                                                                                    if (paymentResponse && paymentResponse.receipt){
                                                                                        NSDictionary<NSString*,NSString*> * r = @{@"receipt":paymentResponse.receipt};
                                                                                        result(r, BNPaymentSuccess, error);
                                                                                    } else {
                                                                                        result(nil, paymentResponse ? BNPaymentSuccess : BNPaymentFailure, error);
                                                                                    }
                                                                                }];
    
    return dataTask;
}

- (NSArray <BNAuthorizedCreditCard *>*)authorizedCards {
    return self.tokenizedCreditCards;
}

- (void)saveAuthorizedCreditCard:(BNAuthorizedCreditCard *)authorizedCreditCard {
    if (self.tokenizedCreditCards) {
        [self.tokenizedCreditCards removeObject:authorizedCreditCard];
        [self.tokenizedCreditCards addObject:authorizedCreditCard];
        [[BNCacheManager sharedCache] saveObject:self.tokenizedCreditCards
                                        withName:TokenizedCreditCardCacheName];
    }
}

- (void)removeAuthorizedCreditCard:(BNAuthorizedCreditCard *)authorizedCreditCard {
    if (self.tokenizedCreditCards) {
        [self.tokenizedCreditCards removeObject:authorizedCreditCard];
        [[BNCacheManager sharedCache] saveObject:self.tokenizedCreditCards
                                        withName:TokenizedCreditCardCacheName];
    }
}

+(void)removeAllAuthorizedCreditCards{
    BNPaymentHandler *handler = [BNPaymentHandler sharedInstance];
    if (handler.tokenizedCreditCards) {
        [handler.tokenizedCreditCards removeAllObjects];
        [[BNCacheManager sharedCache] saveObject:handler.tokenizedCreditCards
                                        withName:TokenizedCreditCardCacheName];
    }
}



-(void) registerExtraPaymentValidationHook:(BNExtraPaymentValidationBlock) hook
{
    self.extraPaymentValidationBlock = hook;
}

-(BOOL)isTouchIdCheckValid: (BNPaymentExtBlock) result{
    __block NSError* authError = nil;
    dispatch_sync( dispatch_get_global_queue(0, 0), ^{
        authError = self.extraPaymentValidationBlock(); });
    if (authError != nil){
        result(nil, BNPaymentNotAuthorized, authError);
        return false;
    }
    return true;
}

-(BOOL)isSinglePaymentTouchIdCheckValid: (BNSinglePaymentExtBlock) result{
    __block NSError* authError = nil;
    dispatch_sync( dispatch_get_global_queue(0, 0), ^{
        authError = self.extraPaymentValidationBlock(); });
    if (authError != nil){
        result(nil,nil, BNPaymentNotAuthorized, authError);
        return false;
    }
    return true;
}

@end
