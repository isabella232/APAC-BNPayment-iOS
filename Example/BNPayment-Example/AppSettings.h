//
//  Settings.h
//  DoNow
//
//  Created by Oskar Henriksson on 11/05/2016.
//  Copyright © 2016 Bambora. All rights reserved.
//

#import <Foundation/Foundation.h>
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


- (void)updateDonatedAmount:(NSInteger)amount;
- (NSInteger)donatedAmount;
- (NSInteger)selectedCardIndex;

- (void) setRunMode:(NSInteger) newRunMode;
- (NSInteger) getRunMode;
- (NSString *)getRunModeUrl;

- (NSString*) getRunModeNameByLevel:(NSNumber*) level;
- (NSInteger) getRunModeByName:(NSString*) name;

- (NSString *)getTestUrl;
- (NSString *)getTestToken;

- (NSString *)getProdUrl;
- (NSString *)getProdToken;

- (BNAuthorizedCreditCard *)selectedCard;


-(BOOL) maxSavedCardReached;
-(void) incrementNumberOfSavedCard;
-(void) decrementNumberOfSavedCard;
    
    
- (BNPaymentParams *) createMockPaymentParameters;
    
@end

