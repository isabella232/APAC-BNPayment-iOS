#import <BNPayment/BNPayment.h>

@interface VisaCheckoutLaunchParams : BNBaseModel

@property (nonatomic, strong) NSString *apikey;
@property (nonatomic, strong) NSString *currencyCode;
@property (nonatomic, strong) NSString *subtotal;
@property (nonatomic, strong) NSString *externalClientId;
@property (nonatomic, strong) NSString *externalProfileId;
@property (nonatomic, strong) NSString *total;
@property (nonatomic, strong) NSString *locale;
@property (nonatomic, strong) NSString *collectShipping;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *buttonAction;
@property (nonatomic, strong) NSString *buttonImageUrl;
@property (nonatomic, strong) NSString *jsLibraryUrl;

-(void)setAmount:(NSNumber *)amount;

@end
