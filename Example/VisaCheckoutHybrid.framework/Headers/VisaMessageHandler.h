/**
 Copyright © 2017 Visa. All rights reserved.
 */

#import <Foundation/Foundation.h>

@interface VisaMessageHandler : NSObject
- (instancetype)init NS_UNAVAILABLE;
@property (class, nonatomic, readonly) NSString *configureVisaCheckoutPlugin;
@property (class, nonatomic, readonly) NSString *launchVisaCheckout;
@end
