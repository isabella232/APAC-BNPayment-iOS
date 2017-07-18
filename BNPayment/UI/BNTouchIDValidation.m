//
//  BNTouchIDValidation.m
//  BNPayment
//
//  Created by Max Mattini on 1/05/2017.
//  Copyright © 2017 Bambora. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BNTouchIDValidation.h"
#import "BNPaymentHandler.h"
#import  <LocalAuthentication/LocalAuthentication.h>

@implementation BNTouchIDValidation

+(void) disable {
    [[BNPaymentHandler sharedInstance] registerExtraPaymentValidationHook:nil];
}
     
+(void) enable {
    [[BNPaymentHandler sharedInstance] registerExtraPaymentValidationHook:^(){
        
        LAContext *myContext = [[LAContext alloc] init];
        __block NSError *authError = nil;
        NSString *myLocalizedReasonString = @"Payment requires touch ID authentication";
        
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        
        if ([myContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError]) {
            [myContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                      localizedReason:myLocalizedReasonString
                                reply:^(BOOL success, NSError *error) {
                                    if (success) {
                                        // User authenticated successfully, take appropriate action
                                        
                                    } else {
                                        authError = error;
                                        // User did not authenticate successfully, look at error and take appropriate action
                                    }
                                    dispatch_semaphore_signal(sema);
                                }];
        } else {
            // Device cannot use TouchID
            dispatch_semaphore_signal(sema);
        }
        
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        return authError;
    }
     ];
}


@end
