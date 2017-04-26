//
//  BPSCrypto.h
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

typedef enum BNCryptoMode : NSUInteger {
    BNCryptoModeEncrypt = 0,
    BNCryptoModeDecrypt
} BNCryptoMode;

@interface BNCrypto : NSObject

/**
 *  A method for generating a cryptographically secure random key of length (in bytes)
 *  specified by the input parameter keyLength.
 *
 *  @param keyLength `NSInteger` representing the length of the key in bytes.
 *
 *  @return `NSData` representing the key.
 */
+ (NSData *)generateRandomKey:(NSInteger)keyLength;

/**
 *  A method for encryption and decryption of a `NSData` block using AES128.
 *  The length of the key provided must be 32 bytes long (128 bits).
 *
 *  @param data         `NSData` to encrypt/decrypt.
 *  @param symmetricKey `NSData` the symetric key used for encryption/decryption.
 *  @param operation    `BNCryptoMode` specifying whether to decrypt of encrypt.
 *  @param error        `NSError` representing potential error in encryption/decryption.
 *
 *  @return `NSData` encrypted/decrypted with the key provided using AES128.
 */
+ (NSData *)AES128Data:(NSData *)data
                   key:(NSData *)symmetricKey
             operation:(BNCryptoMode)operation
                 error:(NSError **)error;

/**
 *  A method for encryption with RSA. The key provided is usually a public key.
 *
 *  @param data `NSData` the data to encrypt.
 *  @param key  `NSData` the key used for encryption.
 *
 *  @return `NSData` encrypted with the key provided.
 */
+ (NSData *)RSAEncryptData:(NSData *)data
                       key:(SecKeyRef)key;

/**
 *  A method for decryption with RSA. The key provided is usually a private key.
 *
 *  @param data `NSData` the data to decrypt.
 *  @param key  `NSData` the key used for decryption.
 *
 *  @return `NSData` decrypted with the key provided.
 */
+ (NSData *)RSADecryptData:(NSData *)data
                       key:(SecKeyRef)key;

@end
