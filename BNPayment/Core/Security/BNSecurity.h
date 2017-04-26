//
//  BNNetworkSecurity.h
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

@interface BNSecurity : NSObject

/**
*  This method can be used to respond to a connection level authentication challenge.
*  This method uses the pinned certs of the bundle to verify against.
*
*  @param serverTrust The X.509 certificate trust of the server.
*  @param domain      The domain to be verified. Must not be `nil`.
*
*  @return If the server should be trusted or not.
*/
- (BOOL)evaluateServerTrust:(SecTrustRef)serverTrust
                  forDomain:(NSString *)domain;

/**
 *  This method is used to determine whether or not the certificate trust is signed by the master X.509 cert.
 *  The method supports functionality to override the master certificate.
 *  If you choose to override the master cert be sure you know the implications.
 *
 *  @param certRef  `SecCertificateRef` to be evaluated
 *  @param secTrust `SecCertificateRef` to evaluate against. Normally not provided.
 *
 *  @return If the certificate is signed by the master cert.
 */
+ (BOOL)evaluateCert:(SecCertificateRef)certRef masterCert:(SecCertificateRef)secTrust;

/**
 *  This method is used for overriding the pinned certs.
 *  Note that overriding the pinned certs with `nil` or empty `NSArray` will result in trust evaluation always failing.
 *
 *  @param certs `NSArray` containing X.509 certs.
 */
- (void)overridePinnedCerts:(NSArray<NSData *> *)certs;

@end
