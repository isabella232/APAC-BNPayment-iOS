#import <UIKit/UIKit.h>
#import <VisaCheckoutHybrid/VisaCheckoutHybrid.h>
#import "VisaCheckoutLaunchParams.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "BNBundleUtils.h"
@protocol VisaCheckOutButtonDelegate <NSObject>

-(void)VisaCheckoutSuccess:(NSDictionary *)VisaCheckoutPayment;

-(void)VisaCheckoutFail:(NSString *)info;

-(void)VisaCheckoutSetupComplete;

@end


@interface VisaCheckOutButton_iOS10 : UIWebView


-(void)loadUIWithViewController:(UIViewController *)viewController andData:(VisaCheckoutLaunchParams *)visaCheckoutLaunchParams andLoadingColor:(UIColor *)color;

@property (nonatomic,weak) id <VisaCheckOutButtonDelegate> resultDelegate;


@end
