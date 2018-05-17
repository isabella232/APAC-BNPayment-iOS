//
//  BNHTTPRequestSerializer.m
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

#import "BNHTTPRequestSerializer.h"
#import "BNPaymentHandler.h"
#import "BNUtils.h"
#import "NSDate+BNUtils.h"

@interface BNHTTPRequestSerializer ()

@property (readwrite, nonatomic, strong) NSSet *HTTPMethodsWithQueryParams;

@end

@implementation BNHTTPRequestSerializer

- (instancetype)init {
    self = [super init];
    if (self) {
        self.HTTPMethodsWithQueryParams = [NSSet setWithObjects:@"GET", @"DELETE", nil];
    }
    return self;
}

- (NSURLRequest *)requestWithMethod:(NSString *)method
                          URLString:(NSString *)URLString
                         parameters:(NSDictionary *)parameters
                              error:(NSError **)error {
    
    BNPaymentHandler *handler = [BNPaymentHandler sharedInstance];
    
    NSURLRequest *request = [self createRequestWithMethod:method
                                                URLString:URLString
                                               parameters:parameters
                                                 apiToken:[handler getApiToken]
                                          merchantAccount:[handler getMerchantAccount]
                                                    error:error];

    return request;
}

//- (NSURLRequest *)requestWithApiToken:(NSString *)apiToken
//                              request:(NSURLRequest *)request {
//    NSMutableURLRequest *mutableRequest = [request mutableCopy];
//    return mutableRequest;
//}

- (NSURLRequest *)createRequestWithMethod:(NSString *)method
                                URLString:(NSString *)url
                               parameters:(NSDictionary *)parameters
                                 apiToken:(NSString *)apiToken
                          merchantAccount:(NSString *)merchantAccount
                                    error:(NSError **)error {
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    
    [request setHTTPMethod:method];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"1" forHTTPHeaderField:@"Api-Version"];

    if ( apiToken) {
        [request setValue:apiToken forHTTPHeaderField:@"Api-Token"];
    }
    
    if ( merchantAccount) {
        [request setValue:merchantAccount forHTTPHeaderField:@"Merchant-Account"];
    }
    
    if ([self.HTTPMethodsWithQueryParams containsObject:[[request HTTPMethod] uppercaseString]]) {
        return [self request:request
                 queryParams:parameters
                       error:error];
    }
    
    return [self request:request
              bodyParams:parameters
                   error:error];
}

- (NSURLRequest *)request:(NSURLRequest *)request
               bodyParams:(NSDictionary *)parameters
                    error:(NSError **)error {
    
    if (parameters) {
        NSMutableURLRequest *mutableRequest = [request mutableCopy];
        
        [mutableRequest setHTTPBody:[NSJSONSerialization dataWithJSONObject:parameters
                                                                    options:kNilOptions error:error]];

        return mutableRequest;
    }
    

    return request;
}

- (NSURLRequest *)request:(NSURLRequest *)request
              queryParams:(NSDictionary *)parameters
                    error:(NSError **)error {
    
    if (parameters) {
        NSURLComponents *URLComponents = [NSURLComponents componentsWithURL:request.URL
                                                    resolvingAgainstBaseURL:NO];

        NSMutableArray *queryItems = [NSMutableArray new];
        
        [parameters enumerateKeysAndObjectsUsingBlock: ^(id key,
                                                         id obj,
                                                         BOOL *stop) {
            NSURLQueryItem *queryItem = [NSURLQueryItem queryItemWithName:key value:obj];
            [queryItems addObject:queryItem];
        }];
        
        [URLComponents setQueryItems:queryItems];
        NSMutableURLRequest *mutableRequest = [request mutableCopy];
        [mutableRequest setURL:URLComponents.URL];

        return mutableRequest;
    }
    
    return request;
}

@end
