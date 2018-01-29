#import <Foundation/Foundation.h>
#import "BNPaymentHandler.h"
#import "VisaCheckoutTransactionParams.h"
#import "VisaCheckoutResponse.h"
#import "VisaCheckoutLaunchParams.h"

@import Foundation;

@class VisaCheckoutLaunchParams;
@class VisaCheckoutResponse;
@class VisaCheckoutTransactionParams;

@interface VisaCheckoutEndpoint : NSObject

+(NSURLSessionDataTask *)getVisaCheckoutWithCompletionHandler:(void(^)(VisaCheckoutLaunchParams* visaCheckoutLaunchParams,NSError* error))completionHandler;

+(NSURLSessionDataTask *)processTransactionFromVisaCheckout:(VisaCheckoutTransactionParams*)visaCheckoutTransactionParams WithCompletionHandler:(void(^)(VisaCheckoutResponse* visaCheckoutResponse,NSError* error))completionHandler;

@end
