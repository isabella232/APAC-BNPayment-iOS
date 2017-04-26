//
//  BNCertManager.m
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

#import "BNCertManager.h"
#import "BNEncryptionCertificate.h"
#import "NSString+BNCrypto.h"
#import "BNCacheManager.h"
#import "BNUtils.h"

NSString *const EncryptionCertificatesCacheName = @"EncryptionCertificatesCacheName";

@implementation BNCertManager {
    NSArray *_encryptionCertificates;
}

+ (BNCertManager *)sharedInstance {
    static BNCertManager *_sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[BNCertManager alloc] init];
    });
    
    return _sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if(self) {
        _encryptionCertificates = [self getEncryptionCertificates];
        
        if(!_encryptionCertificates) {
            _encryptionCertificates = [self getCertificatesFromBundle:[NSBundle bundleForClass:self.class]];
        }
    }
    return self;
}

- (void)replaceEncryptionCertificates:(NSArray<BNEncryptionCertificate *> *)encryptionCertificates {
    [[BNCacheManager sharedCache] saveObject:encryptionCertificates
                                    withName:EncryptionCertificatesCacheName];
    
    
    
    _encryptionCertificates = encryptionCertificates;
}

- (NSArray<BNEncryptionCertificate *> *)getEncryptionCertificates {
    if(!_encryptionCertificates) {
        _encryptionCertificates = (NSArray<BNEncryptionCertificate *> *)[[BNCacheManager sharedCache] getObjectWithName:EncryptionCertificatesCacheName];
    }
    
    return _encryptionCertificates;
}

- (BOOL)shouldUpdateCertificates {
    
    if(!_encryptionCertificates || _encryptionCertificates.count == 0) {
        return YES;
    }
    
    for(BNEncryptionCertificate *cert in _encryptionCertificates) {
        if([cert shouldUpdate]) {
            return YES;
        }
    }
    
    return NO;
}

- (NSArray<BNEncryptionCertificate *> *)getCertificatesFromBundle:(NSBundle *)bundle {
    NSArray *rootPaths = [bundle pathsForResourcesOfType:@"cer" inDirectory:@"."];
    
    NSMutableArray *certificates = [NSMutableArray arrayWithCapacity:[rootPaths count]];
    for (NSString *path in rootPaths) {
        NSError *error;
        NSString *certString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
        NSData *certificateData = [certString getCertData];

        BNEncryptionCertificate *cert = [BNEncryptionCertificate new];
        cert.base64Representation = [certificateData base64EncodedStringWithOptions:0];
        cert.fingerprint = [[BNUtils sha1:certificateData] uppercaseString];
        
        if([cert isTrusted]) {
            [certificates addObject:cert];            
        }
    }
    
    return certificates;
}

@end

