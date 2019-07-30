#import <UIKit/UIKit.h>
#import "VisaCheckoutLaunchParams.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "BNBundleUtils.h"
@protocol VisaCheckOutButtonDelegate10 <NSObject>

-(void)VisaCheckoutSuccess:(NSDictionary *)VisaCheckoutPayment;

-(void)VisaCheckoutFail:(NSString *)info;

-(void)VisaCheckoutSetupComplete;

@end


@interface VisaCheckOutButton_iOS10 : UIWebView


-(void)loadUIWithViewController:(UIViewController *)viewController andData:(VisaCheckoutLaunchParams *)visaCheckoutLaunchParams andLoadingColor:(UIColor *)color;

@property (nonatomic,weak) id <VisaCheckOutButtonDelegate10> resultDelegate;


@end
