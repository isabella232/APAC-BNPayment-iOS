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
    
    [BNPaymentHandler setupWithMerchantAccount:@"CF3A111E-CB1A-4B98-814B-250EC4FD71E5" // This is a public test merchant number which should be replaced once you have your own.
                                       baseUrl:@"https://uat.ippayments.com.au/rapi/"
                                         debug:YES
                                         error:&error];
    NSDictionary* data = @{
                 @"Username": @"bn-secure.rest.api.dev",
                 @"Password": @"MobileIsGr8",
                 @"TokenisationAlgorithmId": @2};
    
    [BNRegisterCCParams setRegistrationJsonData: data];

    UITabBarController* Tcontroller =(UITabBarController*)self.window.rootViewController;
        
    Tcontroller.tabBar.barTintColor= BNColor.purple;
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor grayColor] }
                                             forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor] }
                                             forState:UIControlStateSelected];
    
    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
    
    return YES;
}

@end
