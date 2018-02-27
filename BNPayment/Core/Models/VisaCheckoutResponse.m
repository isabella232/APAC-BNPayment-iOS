#import "VisaCheckoutResponse.h"

@implementation VisaCheckoutResponse

+ (NSDictionary *)JSONMappingDictionary {
    return @{
             @"region" : @"region",
             @"merchant" : @"merchant",
             @"payment" : @"payment",
             @"state" : @"state",
             @"currency" : @"currency",
             @"amount" : @"amount",
             @"comment" : @"comment",
             @"captures" : @"captures",
             @"receipt" : @"receipt",
             @"creditCardToken" : @"creditCardToken",
             @"cardHolderName" : @"cardHolderName",
             @"truncatedCard" : @"truncatedCard",
             @"cardType" : @"cardType",
             
             };
}

@end
