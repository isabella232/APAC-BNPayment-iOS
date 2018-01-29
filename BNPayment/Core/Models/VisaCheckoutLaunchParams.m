#import "VisaCheckoutLaunchParams.h"

@implementation VisaCheckoutLaunchParams

+ (NSDictionary *)JSONMappingDictionary {
    return @{
             @"apikey" : @"apikey",
             @"currencyCode" : @"currencyCode",
             @"subtotal" : @"subtotal",
             @"externalClientId" : @"externalClientId",
             @"externalProfileId" : @"externalProfileId",
             @"total" : @"total",
             @"locale" : @"locale",
             @"collectShipping" : @"collectShipping",
             @"message" : @"message",
             @"buttonAction" : @"buttonAction",
             @"buttonImageUrl" : @"buttonImageUrl",
             @"jsLibraryUrl" : @"jsLibraryUrl",
             };
}

-(void)setAmount:(NSNumber *)amount{
   
    self.total =  [NSString stringWithFormat: @"%f",[amount floatValue]/100.00];
    self.subtotal = self.total;
    
}

@end
