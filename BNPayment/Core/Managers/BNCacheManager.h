//
//  BNCacheManager.h
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

#import <Foundation/Foundation.h>

/**
 `BNCacheManager` is a handler made to simplify caching objects.
 `BNPaymentHandler` offers convenient methods for saving and retrieving objects from disk
 */
@interface BNCacheManager : NSObject

/** Returns a `BNCacheManager` shared instance, creating it if necessary.
 *
 * @return The shared `BNCacheManager` instance
 */
+ (BNCacheManager *)sharedCache;

/**
 *  Saving an object to disk
 *
 *  @param object `NSObject` that will be saved to disk
 *  @param name  `NSString` representing the cache name of the object
 *
 *  @return A `BOOL` indicating the result of the save
 */
- (BOOL)saveObject:(NSObject *)object withName:(NSString *)name;

/**
 *  Retrieving an object from disk
 *
 *  @param name `NSString` representing the cache name of the object
 *
 *  @return `NSCoding` compliant class that has been retrieved from the cache or `nil` if not found
 */
- (id<NSCoding>)getObjectWithName:(NSString *)name;

@end
