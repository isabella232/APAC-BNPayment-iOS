//
//  BNHTTPRequestSerializer.h
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

@import Foundation;

/**
 *  `BNHTTPRequestSerializer` is a class that extends `NSObject`.
 *  `BNHTTPRequestSerializer` only supports JSON serialization at the moment.
 *  `BNHTTPRequestSerializer` will add the Merchant Account or Api-Token to the request
 */
@interface BNHTTPRequestSerializer : NSObject

/**
 *  Creates an `NSURLRequest` object with the specified HTTP method and URL string.
 *
 *  @param method     The HTTP method for this `NSURLRequest`. [GET, POST, PUT, DELETE]
 *  @param URLString  The URL to the endpoint which will be appended to the base URL.
 *  @param parameters A dictionary of params to be added to the request.
 *  @param error      An error showing possible errors while creating the request.
 *
 *  @return A `NSURLRequest` to be executed.
 */
- (NSURLRequest *)requestWithMethod:(NSString *)method
                          URLString:(NSString *)URLString
                         parameters:(NSDictionary *)parameters
                              error:(NSError **)error;

@end
