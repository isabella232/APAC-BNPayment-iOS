//
//  BNHTTPClient.h
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

typedef void (^BNHTTPClientSuccessBlock)(NSURLSessionDataTask *task, id responseObject);
typedef void (^BNHTTPClientErrorBlock)(NSURLSessionDataTask *task, NSError *error);

/**
 *  `BNHTTPClient` is the HTTP client used for network communication by the SDK.
 *  `BNHTTPClient` only supports [GET, POST, PUT, DELETE] HTTP methods.
 *  `BNHTTPClient` only supports application/json content type and is made for consuming JSON rest APIs.
 */
@interface BNHTTPClient : NSObject <NSURLSessionDelegate>

/**
 *  Init method for `BNHTTPClient`.
 *
 *  @param url A `NSURL` representing the base URL to be used by the client.
 *
 *  @return An instance of `BNHTTPClient`.
 */
- (instancetype)initWithBaseURL:(NSURL *)url;

/**
 *  Enable logging allows you to view request information logged by NSLog.
 *  Default is NO logging.
 *
 *  @param enableLogging A flag indicating whether logging should be enabled.
 */
- (void)enableLogging:(BOOL)enableLogging;

/**
 *  Creates and runs a `NSURLSessionDataTask` with a `GET` request.
 *
 *  @param endpointURLString The endpoint URL used for creating the request URL
 *  @param params            The params to be encoded by the serializer `BNHTTPRequestSerializer`.
 *  @param success           An object block executed when the request was successful. Dispatched to main queue.
 *  @param failure           An object block executed when the request returns an error. Dispatched to main queue.
 *
 *  @return A `NSURLSessionDataTask` created by this method.
 */
- (NSURLSessionDataTask *)GET:(NSString *)endpointURLString
                   parameters:(NSDictionary *)params
                      success:(BNHTTPClientSuccessBlock)success
                      failure:(BNHTTPClientErrorBlock)failure;

/**
 *  Creates and runs a `NSURLSessionDataTask` with a `POST` request.
 *
 *  @param endpointURLString The endpoint URL used for creating the request URL
 *  @param params            The params to be encoded by the serializer `BNHTTPRequestSerializer`.
 *  @param success           An object block executed when the request was successful. Dispatched to main queue.
 *  @param failure           An object block executed when the request returns an error. Dispatched to main queue.
 *
 *  @return A `NSURLSessionDataTask` created by this method.
 */
- (NSURLSessionDataTask *)POST:(NSString *)endpointURLString
                    parameters:(NSDictionary *)params
                       success:(BNHTTPClientSuccessBlock)success
                       failure:(BNHTTPClientErrorBlock)failure;

/**
 *  Creates and runs a `NSURLSessionDataTask` with a `PUT` request.
 *
 *  @param endpointURLString The endpoint URL used for creating the request URL
 *  @param params            The params to be encoded by the serializer `BNHTTPRequestSerializer`.
 *  @param success           An object block executed when the request was successful. Dispatched to main queue.
 *  @param failure           An object block executed when the request returns an error. Dispatched to main queue.
 *
 *  @return A `NSURLSessionDataTask` created by this method.
 */
- (NSURLSessionDataTask *)PUT:(NSString *)endpointURLString
                   parameters:(NSDictionary *)params
                      success:(BNHTTPClientSuccessBlock)success
                      failure:(BNHTTPClientErrorBlock)failure;

/**
 *  Creates and runs a `NSURLSessionDataTask` with a `DELETE` request.
 *
 *  @param endpointURLString The endpoint URL used for creating the request URL
 *  @param params            The params to be encoded by the serializer `BNHTTPRequestSerializer`.
 *  @param success           An object block executed when the request was successful. Dispatched to main queue.
 *  @param failure           An object block executed when the request returns an error. Dispatched to main queue.
 *
 *  @return A `NSURLSessionDataTask` created by this method.
 */
- (NSURLSessionDataTask *)DELETE:(NSString *)endpointURLString
                      parameters:(NSDictionary *)params
                         success:(BNHTTPClientSuccessBlock)success
                         failure:(BNHTTPClientErrorBlock)failure;

@end
