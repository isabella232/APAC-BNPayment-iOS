//
//  BNCacheManager.m
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

#import "BNCacheManager.h"
#import "NSString+BNStringUtils.h"

static NSString *const CacheDir = @"BNCacheDir";

@implementation BNCacheManager {
    NSString *_cacheDir;
}

+ (BNCacheManager *)sharedCache{
    static dispatch_once_t once;
    static BNCacheManager *sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)init{
    self = [super init];
    if (self){
        _cacheDir = [NSString stringWithFormat:@"%@/%@",[self getRootDirectory], CacheDir];
        
        if ( ![[NSFileManager defaultManager] fileExistsAtPath:_cacheDir] ) {
            [[NSFileManager defaultManager] createDirectoryAtPath:_cacheDir
                                      withIntermediateDirectories:YES
                                                       attributes:nil
                                                            error:NULL];
        }
    }
    return self;
}

- (BOOL)saveObject:(NSObject *)object withName:(NSString *)name {
    if (object && name) {
        NSString* filename = [_cacheDir stringByAppendingPathComponent:name];
        return [NSKeyedArchiver archiveRootObject:object toFile:filename];
    }

    return NO;
}

- (id<NSCoding>)getObjectWithName:(NSString *)name {
    if (name) {
        NSString *filename = [_cacheDir stringByAppendingPathComponent:name];
        return [NSKeyedUnarchiver unarchiveObjectWithFile:filename];
    }
    
    return nil;
}

-(NSString *)getRootDirectory{
    return [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) lastObject];
}

@end
