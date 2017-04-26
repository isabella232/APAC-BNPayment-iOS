//
//  BPSCrypto.m
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

#import "BNCrypto.h"
#import <CommonCrypto/CommonCryptor.h>

@implementation BNCrypto


+ (NSData *)generateRandomKey:(NSInteger)keyLength {
    uint8_t randomBytes[keyLength];
    /*!
     @function SecRandomCopyBytes
     @abstract Return count random bytes in *bytes, allocated by the caller. 
     
     IT IS CRITICAL TO CHECK THE RETURN VALUE FOR ERROR
     
     @result Return 0 on success or -1 if something went wrong, 
     
     CHECK ERRNO TO FIND OUT THE REAL ERROR.
     */
    int zeroForSuccess = SecRandomCopyBytes(kSecRandomDefault, keyLength, randomBytes);
    if(zeroForSuccess == 0) {
        return [NSData dataWithBytes:randomBytes length:sizeof(randomBytes)];
    }
    
    // cannot generate secure data, return nil
    return nil;
}

+ (NSData *)AES128Data:(NSData *)data
                   key:(NSData *)symmetricKey
             operation:(BNCryptoMode)operation
                 error:(NSError **)error {
    if(data.length == 0) {
        return nil;
    }
    
    CCCryptorStatus ccStatus;
    size_t cryptBytes;
    
    NSMutableData *dataOut = [NSMutableData dataWithLength:data.length + kCCBlockSizeAES128];
    
    ccStatus = CCCrypt(operation,
                       kCCAlgorithmAES,
                       kCCOptionPKCS7Padding,
                       symmetricKey.bytes,
                       kCCKeySizeAES128,
                       symmetricKey.bytes,
                       data.bytes,
                       data.length,
                       dataOut.mutableBytes,
                       dataOut.length,
                       &cryptBytes);
    
    if (ccStatus == kCCSuccess) {
        dataOut.length = cryptBytes;
    }else {
        if (error) {
            *error = [NSError errorWithDomain:@"kEncryptionError" code:ccStatus userInfo:nil];
        }
        dataOut = nil;
    }
    
    return dataOut;
}

+ (NSData *)RSAEncryptData:(NSData *)data
                     key:(SecKeyRef)key {
    
    
    if(data.length == 0) {
        return nil;
    }
    
    OSStatus status = noErr;

    // Input
    size_t plainDataSize = [data length];
    uint8_t *plainData = (uint8_t *)[data bytes];

    // Output
    size_t cipherBufferSize = SecKeyGetBlockSize(key);
    uint8_t *cipherBuffer = malloc(cipherBufferSize);

    status = SecKeyEncrypt(key,
                           kSecPaddingPKCS1,
                           plainData,
                           plainDataSize,
                           cipherBuffer,
                           &cipherBufferSize);
    
    if(status != noErr) {
        free(cipherBuffer);
        return nil;
    }
    
    NSData *encryptedData = [NSData dataWithBytes:cipherBuffer length:cipherBufferSize];
    free(cipherBuffer);

    return encryptedData;
}

+ (NSData *)RSADecryptData:(NSData *)data
                    key:(SecKeyRef)key {
  
    if(data.length == 0) {
        return nil;
    }
    
    OSStatus status = noErr;
    
    // Input
    size_t cipherBufferSize = SecKeyGetBlockSize(key);
    uint8_t *cipherBuffer = (uint8_t *)[data bytes];
    
    // Output
    size_t plainBufferSize = SecKeyGetBlockSize(key);
    uint8_t *plainBuffer = malloc(plainBufferSize);

    status = SecKeyDecrypt(key,
                           kSecPaddingPKCS1,
                           cipherBuffer,
                           cipherBufferSize,
                           plainBuffer,
                           &plainBufferSize);
    
    if(status != noErr) {
        free(plainBuffer);
        return nil;
    }
    
    NSData *decryptedData = [NSData dataWithBytes:plainBuffer length:plainBufferSize];
    free(plainBuffer);

    return decryptedData;
}

@end
