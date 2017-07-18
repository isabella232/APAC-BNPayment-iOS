//
//  AppDelegate.m
//  BNPayment-Example
//
//  Created by Bambora On Mobile AB on 11/12/2015.
//  Copyright (c) 2015 Bambora On Mobile AB. All rights reserved.
//

#import "AppDelegate.h"
#import "BNPayment/BNPayment.h"

#import "BNPayment_Example-Swift.h"
#import "AppSettings.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    NSError *error;
    
    [BNPaymentHandler setupWithMerchantAccount:[[AppSettings sharedInstance] getCurrentRunModeMerchantGuid] 
                                       baseUrl:[[AppSettings sharedInstance] getRunModeUrl]
                                         debug:YES
                                         error:&error];
    
    
    [BNTouchIDValidation enable];
    
    NSDictionary* data = [[AppSettings sharedInstance] retrieveJsonDataforKey:kRegistrationData];
    [BNRegisterCCParams setRegistrationJsonData: data];

    UITabBarController* Tcontroller =(UITabBarController*)self.window.rootViewController;
        
    Tcontroller.tabBar.barTintColor= BNColor.purple;
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor grayColor] }
                                             forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor] }
                                             forState:UIControlStateSelected];
    
    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
    
    [[UISegmentedControl appearance] setTintColor:[BNColor purple]];
    
    return YES;
}

@end
