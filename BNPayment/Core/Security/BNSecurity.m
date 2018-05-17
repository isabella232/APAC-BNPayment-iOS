//
//  BNNetworkSecurity.m
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

#import "BNSecurity.h"
#import "BNCertUtils.h"
#import "NSString+BNCrypto.h"

//[[oz]]
static NSString *const MasterCert =
@"-----BEGIN CERTIFICATE-----"
"MIID5zCCAs+gAwIBAgIJAMFepyQzkC0VMA0GCSqGSIb3DQEBCwUAMIGJMQswCQYD"
"VQQGEwJBVTEMMAoGA1UECAwDTlNXMQ8wDQYDVQQHDAZTWURORVkxDDAKBgNVBAoM"
"A0lQUDEVMBMGA1UECwwMSVBQIFJlc3QgQVBJMREwDwYDVQQDDAhSRVNUIEFQSTEj"
"MCEGCSqGSIb3DQEJARYUY2hlbi5saW5AYmFtYm9yYS5jb20wHhcNMTcwMzAzMDMy"
"NDI1WhcNMTgwMzAzMDMyNDI1WjCBiTELMAkGA1UEBhMCQVUxDDAKBgNVBAgMA05T"
"VzEPMA0GA1UEBwwGU1lETkVZMQwwCgYDVQQKDANJUFAxFTATBgNVBAsMDElQUCBS"
"ZXN0IEFQSTERMA8GA1UEAwwIUkVTVCBBUEkxIzAhBgkqhkiG9w0BCQEWFGNoZW4u"
"bGluQGJhbWJvcmEuY29tMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA"
"u01ozTZy4e3Nf06nZWF5JO0SKhVlW1Wv29/LIBoEARTK9VWNqV33jo9rT6522XaA"
"aee9fqvH6ntCWh1240J4a2GOaA4CMMIiz5nIk6tavw7JZ6RtyGp24o2nFqPtD+Ui"
"aWWkTZgQJmf74r0whGXpDTMDdQCBgGZSdJ0V84jDpdu6ACkQvcI9XwNJd5WACoCp"
"zgohH1+rcZVYqN5TtuF1gjIkxi9UJ8VBrz+llvTJ9t1p61PJ5Kvp3IDJRmwXv0ml"
"58H7HzXnatBKAi/xIl7Yghb+fCEQ3OzBJZlF6fa/wGcMtEaE6SSrcedOLVY4dQQF"
"1XLTYW2KiSqd8Aj6sD56YwIDAQABo1AwTjAdBgNVHQ4EFgQUC5+DJBdxo3F1c05s"
"IYijw7WnXf4wHwYDVR0jBBgwFoAUC5+DJBdxo3F1c05sIYijw7WnXf4wDAYDVR0T"
"BAUwAwEB/zANBgkqhkiG9w0BAQsFAAOCAQEAkhC5KohKz7/MNEuVFrDFztzYjO3I"
"ZxQoa7nDc3TwO/GQUgjZ2shF+en71Ui1ejlvFylYh53f3hkX8bJ4tRt3geX4ZueW"
"W8YKaSJvRoMjnMckIn0ZFPa3dRDwnVjd6lLFskIjbRmNlMQ3USyYoOCiRNm8ZEHQ"
"FnhspggWzhp+xW617X9mB9chZx6zIW8RSKHTXOoaelHAO7aeLoLSN5PTwk2Iy/99"
"xDXk4zbDODrxPa0wgNkgX/xt2v5gEyWtDyVQx7b8wR6+VcnAQHC7vYJD3/OX0LhF"
"7/VhUyKJo76+XJoPm6gjier8ASc/Za2FWmfllPXJhxS08rYqTrEnHNU0ow=="
"-----END CERTIFICATE-----";

static NSString *const OLD_MasterCert =
@"-----BEGIN CERTIFICATE-----"
"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"
"C4yTJeJpa4x3WQmOXK8ikw=="
"-----END CERTIFICATE-----";

@interface BNSecurity ()

@property (nonatomic, strong) NSArray *pinnedCertificates;

@end

@implementation BNSecurity

- (instancetype)init {
    self = [super init];
    
    if (self) {
       // self.pinnedCertificates = [self getPinnedCertificates];
    }
    
    return self;
}

#pragma mark - Public methods

- (BOOL)evaluateServerTrust:(SecTrustRef)serverTrust
                  forDomain:(NSString *)domain {
    return YES;
}

//- (BOOL)evaluateServerTrust:(SecTrustRef)serverTrust
//                  forDomain:(NSString *)domain {
//    //APAC remove the ssl cert pinning.
//    return YES;
////    if (!self.pinnedCertificates || !domain || [self.pinnedCertificates count] == 0) {
////        return NO;
////    }
////
////    NSArray *securityPolicies = @[CFBridgingRelease(SecPolicyCreateSSL(true, (__bridge CFStringRef)domain))];
////    SecTrustSetPolicies(serverTrust, (__bridge CFArrayRef)(securityPolicies));
////
////    NSMutableArray *pinnedCertificates = [NSMutableArray array];
////    for (NSData *certificateData in self.pinnedCertificates) {
////        SecCertificateRef certRef = SecCertificateCreateWithData(NULL, (__bridge CFDataRef)certificateData);
////        if(certRef) {
////            [pinnedCertificates addObject:CFBridgingRelease(certRef)];
////        }
////    }
////
////    SecTrustSetAnchorCertificates(serverTrust, (__bridge CFArrayRef)pinnedCertificates);
////
////    NSUInteger trustedCertificateCount = 0;
////    for (NSData *trustChainCertificate in [self.class getTrustchainForTrustRef:serverTrust]) {
////        if ([self.pinnedCertificates containsObject:trustChainCertificate]) {
////            trustedCertificateCount++;
////        }
////    }
////
////    return trustedCertificateCount > 0 && [self.class validateTrustRef:serverTrust];
//}

//+ (BOOL)evaluateCert:(SecCertificateRef)certRef masterCert:(SecCertificateRef)secTrust {
//    //APAC remove the ssl cert pinning.
//    return YES;
//    NSData *masterCertData = [MasterCert getCertData];
//
//    if(!masterCertData || !certRef) {
//        return NO;
//    }
//
//    SecCertificateRef masterCertRef = secTrust ? secTrust :[BNCertUtils getCertificateRefFromData:masterCertData];
//
//    SecPolicyRef secPolicy = SecPolicyCreateBasicX509();
//    SecTrustRef certSecTrust;
//    SecTrustCreateWithCertificates(certRef, secPolicy, &certSecTrust);
//
//    NSArray *trustAnchors = @[CFBridgingRelease(masterCertRef)];
//    SecTrustSetAnchorCertificates(certSecTrust, (__bridge CFArrayRef)trustAnchors);
//
//    NSArray *securityPolicies = @[CFBridgingRelease(SecPolicyCreateBasicX509())];
//    SecTrustSetPolicies(certSecTrust, (__bridge CFArrayRef)(securityPolicies));
//
//    BOOL validTrustref = [self validateTrustRef:certSecTrust];
//
//    CFRelease(secPolicy);
//
//    return validTrustref;
//}
//
//- (void)overridePinnedCerts:(NSArray<NSData *> *)certs {
//    self.pinnedCertificates = certs;
//}
//
//#pragma mark - Private methods
//
//// Get an array of trust chains for SecTrustRef
//+ (NSArray *)getTrustchainForTrustRef:(SecTrustRef)trustRef {
//    CFIndex certificateCount = SecTrustGetCertificateCount(trustRef);
//    NSMutableArray *serverTrustChain = [NSMutableArray arrayWithCapacity:(NSUInteger)certificateCount];
//
//    for (CFIndex i = 0; i < certificateCount; i++) {
//        SecCertificateRef certificate = SecTrustGetCertificateAtIndex(trustRef, i);
//        [serverTrustChain addObject:CFBridgingRelease(SecCertificateCopyData(certificate))];
//    }
//
//    return serverTrustChain;
//}
//
//// Search the bundle for files with .cer file ending.
//- (NSArray *)getPinnedCertificates {
//    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
//
//    NSArray *rootPaths = [bundle pathsForResourcesOfType:@"cer" inDirectory:@"./BNPayment.bundle/"];
//    rootPaths = [rootPaths arrayByAddingObjectsFromArray:[bundle pathsForResourcesOfType:@"cer" inDirectory:@"."]];
//
//    NSMutableArray *certificates = [NSMutableArray arrayWithCapacity:[rootPaths count]];
//    for (NSString *path in rootPaths) {
//        NSData *certificateData = [NSData dataWithContentsOfFile:path];
//        [certificates addObject:certificateData];
//    }
//
//    return certificates;
//}
//
//// Validate a SecTrustRef
//+ (BOOL)validateTrustRef:(SecTrustRef)trustRef {
//    SecTrustResultType result;
//    SecTrustEvaluate(trustRef, &result);
//
//    return (result == kSecTrustResultUnspecified || result == kSecTrustResultProceed);
//}

@end
