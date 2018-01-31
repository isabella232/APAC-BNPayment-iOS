#import "BNBaseModel.h"

@interface VisaCheckoutResponse : BNBaseModel

@property (nonatomic, strong) NSString *region;
@property (nonatomic, strong) NSString *merchant;
@property (nonatomic, strong) NSString *payment;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *currency;
@property (nonatomic, strong) NSNumber *amount;
@property (nonatomic, strong) NSString *comment;
@property (nonatomic, strong) NSArray *captures;
@property (nonatomic, strong) NSString *receipt;
@property (nonatomic, strong) NSString *cardType;
@property (nonatomic, strong) NSString *cardHolderName;
@property (nonatomic, strong) NSString *creditCardToken;
@property (nonatomic, strong) NSString *truncatedCard;

@end
