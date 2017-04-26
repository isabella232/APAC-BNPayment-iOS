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

static NSString *const TokenizedCreditCardCacheName = @"tokenizedCreditCardCacheName";
static NSString *const SharedSecretKeychainKey = @"sharedSecret";
static NSString *const DefaultBaseUrl = @"https://eu-native.bambora.com";

@interface BNPaymentHandler ()

@property (nonatomic, strong) NSMutableArray<BNAuthorizedCreditCard *> *tokenizedCreditCards;
@property (nonatomic, strong) NSString *apiToken;
@property (nonatomic, strong) NSString *merchantAccount;
@property (nonatomic, assign) BOOL debug;
@property (nonatomic, assign) NSString *baseUrl;
@property (nonatomic, strong) BNHTTPClient *httpClient;

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
    return error == nil;
}


- (void)setupBNPaymentHandler {
    id cachedCards = [[BNCacheManager sharedCache] getObjectWithName:TokenizedCreditCardCacheName];
    
    self.tokenizedCreditCards = [NSMutableArray new];
    
    if ([cachedCards isKindOfClass:[NSArray class]]) {
        self.tokenizedCreditCards = [cachedCards mutableCopy];
    }
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

- (NSURLSessionDataTask *)makePaymentWithParams:(BNPaymentParams *)paymentParams
                                         result:(BNPaymentBlock) result {
    NSURLSessionDataTask *dataTask = [BNPaymentEndpoint authorizePaymentWithParams:paymentParams
                                                                        completion:^(BNPaymentResponse *paymentResponse,
                                                                                     NSError *error) {
        result(paymentResponse ? BNPaymentSuccess : BNPaymentFailure, error);
    }];

    return dataTask;
}

- (NSURLSessionDataTask *)makePaymentExtWithParams:(BNPaymentParams *)paymentParams
                                            result:(BNPaymentExtBlock) result {
    NSURLSessionDataTask *dataTask = [BNPaymentEndpoint authorizePaymentWithParams:paymentParams
                                                                        completion:^(BNPaymentResponse *paymentResponse,
                                                                                     NSError *error) {
                                                                            if (paymentResponse && paymentResponse.receipt){
                                                                                NSDictionary<NSString*,NSString*> * r = @{@"receipt":paymentResponse.receipt};
                                                                                result(r, BNPaymentSuccess, error);
                                                                            } else {
                                                                                result(nil, paymentResponse ? BNPaymentSuccess : BNPaymentFailure, error);
                                                                            }
                                                                        }];
    
    return dataTask;
}


- (NSURLSessionDataTask *)makeApplePayPaymentWithParams:(BNApplePayPaymentParams *)paymentParams
                                                 result:(BNApplePayPaymentBlock) result {
    NSURLSessionDataTask *dataTask = [BNApplePayPaymentEndpoint authorizePaymentWithParams:paymentParams
                                                                                completion:^(BNPaymentResponse *paymentResponse,
                                                                                             NSError *error) {
                                                                                    result(paymentResponse ? BNPaymentSuccess : BNPaymentFailure, error);
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

@end
