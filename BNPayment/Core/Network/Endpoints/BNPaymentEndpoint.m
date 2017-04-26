//
//  BNTransactionEndpoint.m
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

#import "BNPaymentEndpoint.h"
#import "BNPaymentParams.h"
#import "BNPaymentResponse.h"
#import "BNPaymentHandler.h"
#import "BNHTTPClient.h"

@implementation BNPaymentEndpoint

+ (NSURLSessionDataTask *)authorizePaymentWithParams:(BNPaymentParams *)params
                                          completion:(BNPaymentRequestBlock) completion {
    BNHTTPClient *httpClient = [[BNPaymentHandler sharedInstance] getHttpClient];
    
    NSString *endPointUrl = [NSString stringWithFormat:@"payments/%@/card_token/", params.paymentIdentifier];
    
    NSURLSessionDataTask *dataTask = [httpClient POST:endPointUrl
                                           parameters:[params JSONDictionary]
                                              success:^(NSURLSessionDataTask *task, id responseObject) {
                                                  NSError *error;
                                                  BNPaymentResponse *response = [[BNPaymentResponse alloc] initWithJSONDictionary:responseObject
                                                                                                                            error:&error];
                                                  completion(response, error);
                                              } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                                  completion(nil, error);
                                              }];
    
    return dataTask;
}

@end
