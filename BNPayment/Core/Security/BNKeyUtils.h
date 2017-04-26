//
//  BNKeyManager.h
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

@interface BNKeyUtils : NSObject

/**
 *  A method for getting a reference to the public key for a certificate
 *  of type .cer with a specific filename. The certificate file must be 
 *  present in the bundle provided.
 *
 *  @param filename `NSString` representing the filename of the certificate.
 *  @param bundle   `NSBundle` the bundle containing the certificate file.
 *
 *  @return `SecKeyRef` for the certificate.
 */
+ (SecKeyRef)getPublicKeyRefForCerFile:(NSString *)filename
                                bundle:(NSBundle *)bundle;


/**
 *  A method for getting a reference to the public key for a certificate
 *  of type .pem with a specific filename. The certificate file must be
 *  present in the bundle provided.
 *
 *  @param filename `NSString` representing the filename of the certificate.
 *  @param bundle   `NSBundle` the bundle containing the certificate file.
 *
 *  @return `SecKeyRef` for the certificate.
 */
+ (SecKeyRef)getPublicKeyRefForPemFile:(NSString *)filename
                                bundle:(NSBundle *)bundle;

/**
 *  A method for getting a reference to the public key for a certificate
 *  represented by `NSData`.
 *
 *  @param certData `NSData` representation of the certificate.
 *
 *  @return `SecKeyRef` for the certificate.
 */
+ (SecKeyRef)getPublicKeyRefFromCertData:(NSData *)certData;

/**
 *  A method for getting a reference to the private key of a certificate
 *  of type .p12. The certificate must be present in the bundle provided 
 *  and be named the same as the filename provided.
 *
 *  @param filename `NSString` representing the filename of the certificate.
 *  @param bundle   `NSBundle` the bundle containing the certificate file.
 *  @param password `NSString` the paraphrase for the certificate.
 *
 *  @return `SecKeyRef` for the certificate.
 */
+ (SecKeyRef)getPrivateKeyRefForFile:(NSString *)filename
                              bundle:(NSBundle *)bundle
                        withPassword:(NSString *)password;

@end
