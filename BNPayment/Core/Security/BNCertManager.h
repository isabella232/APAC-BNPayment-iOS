//
//  BNCertManager.h
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

@class BNEncryptionCertificate;

@interface BNCertManager : NSObject

/**
 *  A method for obtaining a reference to the class singleton.
 *
 *  @return `BNCertManager` singleton instance.
 */
+ (BNCertManager *)sharedInstance;

/**
 *  A method for replacing the encryption certificates used by client side 
 *  encryption in order to safely send credit cards over the Internet.
 *
 *  @param encryptionCertificates `NSArray` containing the new encryption certificates.
 */
- (void)replaceEncryptionCertificates:(NSArray<BNEncryptionCertificate *> *)encryptionCertificates;

/**
 *  A method for retrieving the encryption certificates used for client 
 *  side encryption.
 *
 *  @return `NSArray` containing the certificates.
 */
- (NSArray<BNEncryptionCertificate *> *)getEncryptionCertificates;

/**
 *  A method for checking if new certificates should be fetched.
 *
 *  @return `BOOL` indicating wheter or not to update the certificates.
 */
- (BOOL)shouldUpdateCertificates;

@end
