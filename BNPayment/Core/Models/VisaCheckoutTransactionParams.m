#import "VisaCheckoutTransactionParams.h"

@implementation VisaCheckoutTransactionParams

+ (NSDictionary *)JSONMappingDictionary {
    return @{
             @"encPaymentData" : @"encPaymentData",
             @"callid" : @"callid",
             @"encKey" : @"encKey",
             @"paymentJsonData" : @"paymentJsonData"
             };
}

@end
