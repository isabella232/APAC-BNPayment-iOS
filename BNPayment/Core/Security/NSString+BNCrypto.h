//
//  NSString+BPSCrypto.h
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

@interface NSString (BNCrypto)

/**
 *  A helper method which encrypts the string with a given
 *  AES128 key and returns a base64 encoded representation
 *  of the encrypted string.
 *
 *  @param key `NSData` used as a key for the encryption.
 *
 *  @return `NSString` AES128 encrypted string with key and base64 encoded.
 */
- (NSString *)AES128EncryptWithKey:(NSData *)key;

/**
 *  A helper method which decrypts a base64 encoded encrypted string
 *  and returns the original string.
 *
 *  @param key `NSData` used as a key for the decryption.
 *
 *  @return `NSString` AES128 decrypted string UTF8 encoded.
 */
- (NSString *)AES128DecryptWithKey:(NSData *)key;

/**
 *  A method for extracting the data from a string representing a Base64 encoded
 *  certificate in .pem format.
 *
 *  @return `NSData` representing the certificate.
 */
- (NSData *)getCertData;

@end
