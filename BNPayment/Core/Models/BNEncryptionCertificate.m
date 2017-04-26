//
//  BNEncryptionCertificate.m
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

#import "BNEncryptionCertificate.h"
#import "BNCrypto.h"
#import "BNSecurity.h"
#import "BNKeyUtils.h"
#import "BNCertUtils.h"
#import "NSString+BNCrypto.h"
#import "NSDate+BNUtils.h"

@implementation BNEncryptionCertificate

+ (NSDictionary *)JSONMappingDictionary {
    return @{
             @"fingerprint" : @"fingerprint",
             @"base64Representation" : @"certificate",
             @"validFrom" : @"validFrom",
             @"validTo" : @"validTo",
             @"updateInterval" : @"updateInterval"
             };
}

- (NSString *)encryptSessionKey:(NSData *)sessionKey {
    NSData *encryptedSessionKey = [BNCrypto RSAEncryptData:sessionKey key:[self getKeyRef]];
    return [encryptedSessionKey base64EncodedStringWithOptions:0];
}

- (SecKeyRef)getKeyRef {
    NSData *certData = [self.base64Representation getCertData];
    
    if(certData) {
        return [BNKeyUtils getPublicKeyRefFromCertData:certData];
    }
    
    return nil;
}

- (BOOL)isTrusted {
    NSData *certData = [self.base64Representation getCertData];
    SecCertificateRef certRef = [BNCertUtils getCertificateRefFromData:certData];
    return [BNSecurity evaluateCert:certRef masterCert:nil];
}

- (BOOL)shouldUpdate {
    if(self.validTo && self.updateInterval) {
        NSDate *expirationDate = [NSDate dateFromISO8601String:self.validTo];
        NSInteger daysValid = [expirationDate timeIntervalSinceNow]/(3600*24);
        return daysValid < self.updateInterval-1;
    }
    
    return NO;
}

@end
