//
//  BNKeyManager.m
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

#import "BNKeyUtils.h"
#import "NSString+BNCrypto.h"

@implementation BNKeyUtils

+ (SecKeyRef)getPublicKeyRefForCerFile:(NSString *)filename
                                bundle:(NSBundle *)bundle {
    NSString *certPath = [bundle pathForResource:filename ofType:@"cer"];
    NSData *certData = [NSData dataWithContentsOfFile:certPath];
    
    if(!certPath || !certData) {
        return nil;
    }
    
    return [BNKeyUtils getPublicKeyRefFromCertData:certData];
}

+ (SecKeyRef)getPublicKeyRefForPemFile:(NSString *)filename
                                bundle:(NSBundle *)bundle {
    NSString *certPath = [bundle pathForResource:filename ofType:@"pem"];
    
    NSError *error;
    NSString *certString = [NSString stringWithContentsOfFile:certPath encoding:NSUTF8StringEncoding error:&error];

    if(!certPath || !certString || error) {
        return nil;
    }
    
    return [BNKeyUtils getPublicKeyRefFromCertData:[certString getCertData]];
}

+ (SecKeyRef)getPublicKeyRefFromCertData:(NSData *)certData {
    SecKeyRef publicKey = nil;
    SecTrustRef certSecTrust;
    SecPolicyRef secPolicy = SecPolicyCreateBasicX509();
    
    SecCertificateRef cert = SecCertificateCreateWithData(nil, (__bridge CFDataRef)certData);
    OSStatus status = SecTrustCreateWithCertificates(cert, secPolicy, &certSecTrust);
    
    if(status != noErr) {
        CFRelease(cert);
        CFRelease(secPolicy);
        
        return nil;
    }
    
    publicKey = SecTrustCopyPublicKey(certSecTrust);
    
    CFRelease(cert);
    CFRelease(secPolicy);
    
    return publicKey;
}

+ (SecKeyRef)getPrivateKeyRefForFile:(NSString *)filename
                              bundle:(NSBundle *)bundle
                        withPassword:(NSString *)password {
    SecKeyRef privateKeyRef = nil;

    NSString *certPath = [bundle pathForResource:filename ofType:@"p12"];
    NSData *certData = [NSData dataWithContentsOfFile:certPath];
    
    NSMutableDictionary * options = [[NSMutableDictionary alloc] init];
    
    if(password) {
        [options setObject:password forKey:(id)kSecImportExportPassphrase];        
    }

    CFArrayRef items = CFArrayCreate(nil, 0, 0, nil);
    
    OSStatus securityError = SecPKCS12Import((CFDataRef) certData,
                                             (CFDictionaryRef)options,
                                             &items);
    
    if (securityError == noErr && CFArrayGetCount(items) > 0) {
        CFDictionaryRef identityDict = CFArrayGetValueAtIndex(items, 0);
        SecIdentityRef identityApp = (SecIdentityRef)CFDictionaryGetValue(identityDict,
                                                                          kSecImportItemIdentity);
        
        securityError = SecIdentityCopyPrivateKey(identityApp, &privateKeyRef);
        if (securityError != noErr) {
            privateKeyRef = nil;
        }
    }
    
    return privateKeyRef;
}

@end
