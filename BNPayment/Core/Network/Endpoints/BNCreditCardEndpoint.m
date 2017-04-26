//
//  BNCreditCardEndpoint.m
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

#import "BNCreditCardEndpoint.h"
#import "BNCCHostedFormParams.h"
#import "BNRegisterCCParams.h"
#import "BNAuthorizedCreditCard.h"
#import "BNPaymentHandler.h"
#import "BNHTTPClient.h"
#import "BNEncryptionCertificate.h"
#import "BNCertManager.h"
#import "BNSecurity.h"

@implementation BNCreditCardEndpoint

+ (NSURLSessionDataTask *)initiateCreditCardRegistrationForm:(BNCCHostedFormParams *)formParams
                                                  completion:(BNCreditCardUrlBlock)completion {
    BNHTTPClient *httpClient = [[BNPaymentHandler sharedInstance] getHttpClient];
    
    NSString *endpointUrl = @"hpp/";
    
    NSDictionary *params = [formParams JSONDictionary];
    
    NSURLSessionDataTask *dataTask = [httpClient POST:endpointUrl
                                           parameters:params
                                              success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString *url = [responseObject objectForKey:@"session_url"];
        completion(url, nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completion(nil, error);
    }];
    
    return dataTask;
}

+ (NSURLSessionDataTask *)registerCreditCard:(BNRegisterCCParams *)params
                                  completion:(BNCreditCardRegistrationBlock)completion {
    BNHTTPClient *httpClient = [[BNPaymentHandler sharedInstance] getHttpClient];
    NSString *endpointURL = @"cardregistration/";
    NSDictionary *requestParams = [params JSONDictionary];
    
    if([[BNCertManager sharedInstance] shouldUpdateCertificates]) {
        NSURLSessionDataTask *dataTask = [BNCreditCardEndpoint encryptionCertificatesWithCompletion:^(NSArray<BNEncryptionCertificate *> *encryptionCertificates, NSError *error) {
            [httpClient POST:endpointURL parameters:requestParams success:^(NSURLSessionDataTask *task, id responseObject) {
                NSError *error;
                BNAuthorizedCreditCard *response = [[BNAuthorizedCreditCard alloc] initWithJSONDictionary:responseObject
                                                                                                    error:&error];
                completion(response, error);
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                completion(nil, error);
            }];
        }];
        
        return dataTask;
    }
    
    NSURLSessionDataTask *dataTask = [httpClient POST:endpointURL parameters:requestParams success:^(NSURLSessionDataTask *task, id responseObject) {
        NSError *error;
        BNAuthorizedCreditCard *response = [[BNAuthorizedCreditCard alloc] initWithJSONDictionary:responseObject
                                                                                  error:&error];
        completion(response, error);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completion(nil, error);
    }];
    
    return dataTask;
}

+ (NSURLSessionDataTask *)encryptionCertificatesWithCompletion:(BNEncryptionCertBlock)completion {
    BNHTTPClient *httpClient = [[BNPaymentHandler sharedInstance] getHttpClient];
    
    NSString *endpointURL = @"certificates/";
    
    NSURLSessionDataTask *dataTask = [httpClient GET:endpointURL parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSError *error;
        
        if(responseObject && [responseObject isKindOfClass:[NSArray class]]) {
            NSMutableArray *certArray = [NSMutableArray new];
            for(NSDictionary *certDict in responseObject) {
                BNEncryptionCertificate *cert = [[BNEncryptionCertificate alloc] initWithJSONDictionary:certDict error:&error];
                if([cert isTrusted]) {
                    [certArray addObject:cert];
                }
            }
            [[BNCertManager sharedInstance] replaceEncryptionCertificates:certArray];
        }
        completion(responseObject, error);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completion(nil, error);
    }];
    
    return dataTask;
}

@end
