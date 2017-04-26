//
//  NSString+BPSCrypto.m
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

#import "NSString+BNCrypto.h"
#import "BNCrypto.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation NSString (BNCrypto)

- (NSString *)AES128EncryptWithKey:(NSData *)key {
    NSError *error;
    NSData *encryptedData = [BNCrypto AES128Data:[self dataUsingEncoding:NSUTF8StringEncoding]
                                             key:key
                                       operation:BNCryptoModeEncrypt
                                           error:&error];
    
    if(!error) {
        return [encryptedData base64EncodedStringWithOptions:0];
    }
    
    return nil;
}

- (NSString *)AES128DecryptWithKey:(NSData *)key {
    NSError *error;

    NSData *encryptedData = [BNCrypto AES128Data:[[NSData alloc] initWithBase64EncodedString:self options:0]
                                             key:key
                                       operation:BNCryptoModeDecrypt
                                           error:&error];
    
    if(!error) {
        return [[NSString alloc] initWithData:encryptedData
                                     encoding:NSUTF8StringEncoding];
    }
    
    return nil;
}

- (NSData *)getCertData {
    NSString *certString = self.copy;
    
    certString = [certString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    certString = [certString stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    certString = [certString stringByReplacingOccurrencesOfString:@"-----BEGIN CERTIFICATE-----" withString:@""];
    certString = [certString stringByReplacingOccurrencesOfString:@"-----END CERTIFICATE-----" withString:@""];
    
    return [[NSData alloc] initWithBase64EncodedString:certString options:0];
}

@end
