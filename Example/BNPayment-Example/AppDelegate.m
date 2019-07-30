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
#import "OHHTTPStubs.h"
#import "OHHTTPStubsResponse.h"
#import "OHPathHelpers.h"

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
        
    Tcontroller.tabBar.barTintColor = UIColor.purpleColor;
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor grayColor] }
                                             forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor] }
                                             forState:UIControlStateSelected];
    
    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
    
    [[UISegmentedControl appearance] setTintColor:UIColor.purpleColor];
    
    [self mockVisaCheckParams];
    [self mockVisaCheckoutTransaction];
    
    return YES;
}


-(void)mockVisaCheckParams{
    
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return [request.URL.path isEqualToString:@"/rapi/visacheckout_params"];
    } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
        NSString *filePath = OHPathForFile(@"VisaCheckoutParams.json", self.class);
        OHHTTPStubsResponse *response = [[OHHTTPStubsResponse responseWithFileAtPath:filePath statusCode:200 headers:@{@"Content-Type":@"application/json"}] responseTime:1];
        return response;
    }];
    
}



-(void)mockVisaCheckoutTransaction{
    
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return [request.URL.path isEqualToString:@"/rapi/visacheckout_transaction"];
    } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
        NSString *filePath = OHPathForFile(@"VisaCheckoutTransaction.json", self.class);
        OHHTTPStubsResponse *response = [[OHHTTPStubsResponse responseWithFileAtPath:filePath statusCode:200 headers:@{@"Content-Type":@"application/json"}] responseTime:3];
        return response;
    }];
    
}

@end
