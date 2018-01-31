#import "BNBaseModel.h"

@interface VisaCheckoutTransactionParams : BNBaseModel

@property (nonatomic, strong) NSString *encPaymentData;
@property (nonatomic, strong) NSString *callid;
@property (nonatomic, strong) NSString *encKey;
@property (nonatomic, strong) NSDictionary *paymentJsonData;

@end
