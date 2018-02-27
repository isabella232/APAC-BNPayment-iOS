//
//  Settings.h
//  DoNow
//
//  Created by Oskar Henriksson on 11/05/2016.
//  Copyright © 2016 Bambora. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <BNPayment/BNSubmitSinglePaymentCardGuiSetting.h>
#import <BNPayment/BNCardRegistrationGuiSetting.h>
#import <UIKit/UIKit.h>

@class BNAuthorizedCreditCard;
@class BNPaymentParams;
@interface AppSettings : NSObject

+ (AppSettings *)sharedInstance;

@property (nonatomic, strong) NSString *username;
@property (nonatomic) BOOL offlineMode;
@property (nonatomic) BOOL touchIDMode;

@property (nonatomic) BOOL HPPMode;
@property (nonatomic) BOOL velocityMode;
@property (nonatomic) BOOL payOnceMode;

@property (nonatomic) BOOL scanVisualCues;
@property (nonatomic) BOOL scanCardHolderName;

@property (nonatomic, strong) NSString *sban;
@property (nonatomic, strong) NSString *pban;



- (void)updateDonatedAmount:(NSInteger)amount;
- (NSInteger)donatedAmount;
- (NSInteger)selectedCardIndex;

- (void) setTouchIDMode:(BOOL) newTouchIDMode  newRunMode:(NSInteger) newRunMode;
- (void) setVelocityMode:(BOOL) newVelocityMode  newRunMode:(NSInteger) newRunMode;
- (void) setRunMode:(NSInteger) runMode;
- (void) setRunModeMerchantGuid:(NSInteger) newRunMode  newMerchantGuid:(NSString*) newMerchantGuid;
- (void) setVisaCheckoutMode:(BOOL) newVisaCheckoutMode;
- (BOOL) getVisaCheckoutMode;

- (void) setCardRegistrationGuiSetting:(BNCardRegistrationGuiSetting*) guiSetting;
- (void) setSubmitSinglePaymentCardGuiSetting:(BNSubmitSinglePaymentCardGuiSetting*) guiSetting;


- (BNCardRegistrationGuiSetting* )getCardRegistrationGuiSetting;
- (BNSubmitSinglePaymentCardGuiSetting* )getSubmitSinglePaymentGuiSetting;

- (NSInteger) getRunMode;
- (NSString *)getRunModeUrl;
- (NSString *)getCurrentRunModeMerchantGuid;
- (NSString *)getMerchantGuid: (NSInteger) runModeParam;


- (NSString*) getRunModeNameByLevel:(NSNumber*) level;
- (NSInteger) getRunModeByName:(NSString*) name;
- (NSString*) getRunModeMerchantGuidKey:(NSInteger) newRunMode;
- (NSString*) getTestUrl;
- (NSString*) getTestToken;

- (NSString*) getProdUrl;
- (NSString*) getProdToken;

- (NSString*) getCompileDate;
- (NSString*) getCompileTime;

- (BNAuthorizedCreditCard *)selectedCard;


-(BOOL) maxSavedCardReached;
-(void) incrementNumberOfSavedCard;
-(void) decrementNumberOfSavedCard;
        
    
- (BNPaymentParams *) createMockPaymentParameters:(NSNumber*) amount comment:(NSString*) comment token:(NSString*) token;

#define kRegistrationData @"registrationData"
#define kPaymentData      @"paymentData"


-(NSDictionary*) retrieveJsonDataforKey:(NSString*)key;

-(void) persistJsonDataRegistration:(NSString*) s forKey:(NSString*)key;

@end

