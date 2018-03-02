//
//  Settings.m
//  DoNow
//
//  Created by Oskar Henriksson on 11/05/2016.
//  Copyright © 2016 Bambora. All rights reserved.
//

#import "AppSettings.h"
#import <BNPayment/BNPayment.h>
#import <BNPayment/BNSubmitSinglePaymentCardGuiSetting.h>
#import <BNPayment/BNCardRegistrationGuiSetting.h>


@interface AppSettings ()
@property (nonatomic) NSInteger runMode;
@property (nonatomic) NSInteger numberOfCardsSaved;
@property (nonatomic, strong) NSString *merchantGuid;
@property (nonatomic, strong) BNSubmitSinglePaymentCardGuiSetting *submitSinglePaymentCardGuiSetting;
@property (nonatomic, strong) BNCardRegistrationGuiSetting *cardRegistrationGuiSetting;


@end

#define kRunModeUndefined 0
#define kRunModeDev 1
#define kRunModeUAT 2
#define kRunModeProd 3
#define kRunModeDefault kRunModeUAT


#define kMaxCard (20)

static NSString *const DonationAmountKey = @"donationAmount";
static NSString *const ProfileNameKey = @"profileName";
static NSString *const FavoriteCardKey = @"FavoriteCard";
static NSString *const OfflineModeKey = @"OfflineMode";
static NSString *const TouchIDModeKey = @"TouchIDMode";
static NSString *const HPPModeKey = @"HPPMode";
static NSString *const velocityModeKey = @"velocityMode";
static NSString *const numberOfCardsSavedKey = @"numberOfCardsSaved";
static NSString *const payOnceModeKey = @"payOnceMode";
static NSString *const ScanVisualCuesHiddenKey = @"ScanVisualCuesHidden";
static NSString *const ScanCardHolderNameKey = @"ScanCardHolderName";
static NSString *const VisaCheckoutModeKey = @"VisaCheckoutMode";

@implementation AppSettings {
   
}

+ (AppSettings *)sharedInstance {
    static AppSettings *_sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[AppSettings alloc] init];
        _sharedInstance.runMode = kRunModeUndefined;
        _sharedInstance.numberOfCardsSaved = [_sharedInstance restoreNumberOfCardSaved];
    });
    
    return _sharedInstance;
}

- (instancetype)init {
    self = [super init];
    
    if (self != nil){
        //
    }
    
    return self;
}

- (NSString *)username {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userName = [userDefaults objectForKey:ProfileNameKey];
    return userName ? userName : @"Mattias Johansson";
}

- (void)setUsername:(NSString *)string {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:string forKey:ProfileNameKey];
}

- (void)updateDonatedAmount:(NSInteger)amount {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger donationAmount = [userDefaults integerForKey:DonationAmountKey];
    [userDefaults setInteger:donationAmount+amount forKey:DonationAmountKey];
}

- (NSInteger)donatedAmount {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults integerForKey:DonationAmountKey];
}

- (NSInteger)selectedCardIndex {
    return 0;
}


    //
    
    - (void)setOfflineMode:(BOOL)offlineMode {
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setBool:offlineMode forKey:OfflineModeKey];
    }
    
- (BOOL)offlineMode {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    return [userDefault boolForKey:OfflineModeKey];
}

    
- (void)setTouchIDMode:(BOOL)newTouchIDMode  newRunMode:(NSInteger) newRunMode{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setBool:newTouchIDMode forKey:TouchIDModeKey];
}

- (BOOL)getVisaCheckoutMode {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    return [userDefault boolForKey:VisaCheckoutModeKey];
}

- (void)setVisaCheckoutMode:(BOOL)newVisaCheckoutMode{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setBool:newVisaCheckoutMode forKey:VisaCheckoutModeKey];
}

- (BOOL)touchIDMode {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    return [userDefault boolForKey:TouchIDModeKey];
}



- (void)setHPPMode:(BOOL)hppMode {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setBool:hppMode forKey:HPPModeKey];
    [userDefault synchronize];
}

- (BOOL)HPPMode {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    return [userDefault boolForKey:HPPModeKey];
}

- (void)setVelocityMode:(BOOL)newVelocityMode newRunMode:(NSInteger) newRunMode {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setBool:newVelocityMode forKey:velocityModeKey];
    [userDefault synchronize];
}

- (BOOL)velocityMode {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    return [userDefault boolForKey:velocityModeKey];
}

- (void)persistNumberOfCardSaved:(NSInteger) cardNumber {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setInteger:cardNumber forKey:numberOfCardsSavedKey];
    [userDefault synchronize];
}

- (NSInteger) restoreNumberOfCardSaved {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSInteger n = [userDefault integerForKey:numberOfCardsSavedKey];
    return n;
}

-(BOOL) maxSavedCardReached
{
    BOOL b1 = (self.numberOfCardsSaved >= ((NSInteger) kMaxCard));
    return b1;
}

-(void) incrementNumberOfSavedCard;
{
    self.numberOfCardsSaved = self.numberOfCardsSaved + 1;
    [self persistNumberOfCardSaved:self.numberOfCardsSaved];
}

-(void) decrementNumberOfSavedCard;
{
    self.numberOfCardsSaved = self.numberOfCardsSaved - 1;
    [self persistNumberOfCardSaved:self.numberOfCardsSaved];
}

- (void)setPayOnceMode:(BOOL)velocityMode {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setBool:velocityMode forKey:payOnceModeKey];
    [userDefault synchronize];
}

- (BOOL)payOnceMode {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    return [userDefault boolForKey:payOnceModeKey];
}

- (BOOL)scanVisualCues {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    return ![userDefault boolForKey:ScanVisualCuesHiddenKey];
}

- (void)setScanVisualCues:(BOOL)scanVisualCues {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setBool:!scanVisualCues forKey:ScanVisualCuesHiddenKey];
    [userDefault synchronize];
}

- (BOOL)scanCardHolderName {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    return [userDefault boolForKey:ScanCardHolderNameKey];
}

- (void)setScanCardHolderName:(BOOL)scanCardHolderName {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setBool:scanCardHolderName forKey:ScanCardHolderNameKey];
    [userDefault synchronize];
}

- (NSInteger) getRunMode {
    if (_runMode == kRunModeUndefined){
      _runMode = [[NSUserDefaults standardUserDefaults] integerForKey:@"runMode"];
    }
    if (_runMode == kRunModeUndefined){
        _runMode = kRunModeDefault;
    }
    return _runMode;
}

- (NSInteger) getRunModeByName:(NSString*) name {
    NSDictionary<NSString*, NSNumber*> *map = @{
                                                       @"Dev":@(kRunModeDev),
                                                       @"UAT":@(kRunModeUAT),
                                                       @"Prod":@(kRunModeProd)};
    if ([[map allKeys] containsObject:name]){
        return [NSNumber numberWithInt:[map objectForKey:name]];
    }
    return kRunModeUndefined;
}

- (NSString*) getRunModeNameByLevel:(NSNumber*) level {
    NSDictionary< NSNumber*, NSString*> *map = @{
                                                @(kRunModeDev): @"Dev",
                                                @(kRunModeUAT): @"UAT",
                                                @(kRunModeProd): @"Prod"};
    if ([[map allKeys] containsObject:level]){
        return [map objectForKey:level];
    }
    return @"?";
}



- (void) setRunMode:(NSInteger) newRunMode {
    if (newRunMode <= kRunModeProd && newRunMode >= kRunModeDev){
        [[NSUserDefaults standardUserDefaults] setInteger:newRunMode forKey:@"runMode"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        _runMode = newRunMode;
    }
}


- (NSString *)getRunModeUrl {
    NSInteger i = [self getRunMode];
    NSNumber* runMode= [NSNumber numberWithInt:i];
    NSDictionary<NSNumber*,NSString*> *runModeUrls = @{
                                                       @(1):@"https://devsandbox.ippayments.com.au/rapi/",
                                                       @(2):@"https://uat.ippayments.com.au/rapi/",
                                                       @(3):@"https://www.ippayments.com.au/rapi/"};
    NSString* url = runModeUrls[runMode];
    return url;
}


- (NSString *)getCurrentRunModeMerchantGuid {
    if (_merchantGuid == nil){
        NSInteger runMode = [self getRunMode];
        _merchantGuid = [self getMerchantGuid: runMode];
    }
    if (_merchantGuid == nil){
        _merchantGuid = @"";
    }
    return _merchantGuid;
}

- (NSString *)getMerchantGuid: (NSInteger) runModeParam  {
      NSString* currentRunningModeMerchantGuidKey = [self getRunModeMerchantGuidKey: runModeParam];
      if (runModeParam==kRunModeDefault && [[NSUserDefaults standardUserDefaults] valueForKey: currentRunningModeMerchantGuidKey]==nil)
      {
          NSString* path = [[NSBundle mainBundle] pathForResource:@"MerchantID" ofType:@"txt"];
          NSString* defaultMerchantGuid = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
          return defaultMerchantGuid;
      }
    else
    {
        return [[NSUserDefaults standardUserDefaults] valueForKey: currentRunningModeMerchantGuidKey];
    }
}





- (NSString *)getRunModeMerchantGuidKey : (NSInteger) runModeParam{
    
    NSNumber* runMode= [NSNumber numberWithInt:runModeParam];
    NSDictionary<NSNumber*,NSString*> *runModeMerchantGuidKey = @{
                                                       @(1):@"MerchantGuid-Dev",
                                                       @(2):@"MerchantGuid-Uat",
                                                       @(3):@"MerchantGuid-Prod"};
    NSString* merchantGuidKey = runModeMerchantGuidKey[runMode];
    return merchantGuidKey;
}

- (void) setRunModeMerchantGuid:(NSInteger) newRunMode  newMerchantGuid:(NSString*) newMerchantGuid {
    if (newRunMode <= kRunModeProd && newRunMode >= kRunModeDev){
        NSString* merchantGuidKey = [self getRunModeMerchantGuidKey: newRunMode] ;
        [[NSUserDefaults standardUserDefaults] setValue: newMerchantGuid forKey: merchantGuidKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        _merchantGuid = newMerchantGuid;
    }
}


- (BNCardRegistrationGuiSetting* )getCardRegistrationGuiSetting{
    if(_cardRegistrationGuiSetting==nil)
    {
        _cardRegistrationGuiSetting = [[BNCardRegistrationGuiSetting alloc] init];
        _cardRegistrationGuiSetting.titleText =[[NSUserDefaults standardUserDefaults] valueForKey: [BNCardRegistrationGuiSetting GetGuiKey:registrationTitleText]];
        _cardRegistrationGuiSetting.cardHolderWatermark =[[NSUserDefaults standardUserDefaults] valueForKey: [BNCardRegistrationGuiSetting GetGuiKey:registrationCardHolderWatermark]];
        _cardRegistrationGuiSetting.cardNumberWatermark =[[NSUserDefaults standardUserDefaults] valueForKey: [BNCardRegistrationGuiSetting GetGuiKey:registrationCardNumberWatermark]];
        _cardRegistrationGuiSetting.expiryDateWatermark =[[NSUserDefaults standardUserDefaults] valueForKey: [BNCardRegistrationGuiSetting GetGuiKey:registrationExpiryDateWatermark]];
        _cardRegistrationGuiSetting.securityCodeWatermark =[[NSUserDefaults standardUserDefaults] valueForKey: [BNCardRegistrationGuiSetting GetGuiKey:registrationSecurityCodeWatermark]];
        _cardRegistrationGuiSetting.registrationButtonColor =[[NSUserDefaults standardUserDefaults] valueForKey: [BNCardRegistrationGuiSetting GetGuiKey:registrationButtonColor]];
        _cardRegistrationGuiSetting.registerButtonText =[[NSUserDefaults standardUserDefaults] valueForKey: [BNCardRegistrationGuiSetting GetGuiKey:registrationButtonText]];
        if([[[[NSUserDefaults standardUserDefaults] dictionaryRepresentation]allKeys] containsObject:[BNCardRegistrationGuiSetting GetGuiKey:registrationCardIODisable]])
        {
            _cardRegistrationGuiSetting.registrationCardIODisable =[[NSUserDefaults standardUserDefaults] boolForKey: [BNCardRegistrationGuiSetting GetGuiKey:registrationCardIODisable]];
        }
        else
        {
            _cardRegistrationGuiSetting.registrationCardIODisable=NO;
        }
        _cardRegistrationGuiSetting.registrationCardIOColor =[[NSUserDefaults standardUserDefaults] valueForKey: [BNCardRegistrationGuiSetting GetGuiKey:registrationCardIOColor]];
        
    }
    return _cardRegistrationGuiSetting;
}

- (BNSubmitSinglePaymentCardGuiSetting* )getSubmitSinglePaymentGuiSetting{
    if(_submitSinglePaymentCardGuiSetting==nil)
    {
        _submitSinglePaymentCardGuiSetting = [[BNSubmitSinglePaymentCardGuiSetting alloc] init];
        _submitSinglePaymentCardGuiSetting.titleText =[[NSUserDefaults standardUserDefaults] valueForKey: [BNSubmitSinglePaymentCardGuiSetting GetGuiKey:payTitleText]];
        _submitSinglePaymentCardGuiSetting.cardHolderWatermark =[[NSUserDefaults standardUserDefaults] valueForKey: [BNSubmitSinglePaymentCardGuiSetting GetGuiKey:payCardHolderWatermark]];
        _submitSinglePaymentCardGuiSetting.cardNumberWatermark =[[NSUserDefaults standardUserDefaults] valueForKey: [BNSubmitSinglePaymentCardGuiSetting GetGuiKey:payCardNumberWatermark]];
        _submitSinglePaymentCardGuiSetting.expiryDateWatermark =[[NSUserDefaults standardUserDefaults] valueForKey: [BNSubmitSinglePaymentCardGuiSetting GetGuiKey:payExpiryDateWatermark]];
        _submitSinglePaymentCardGuiSetting.securityCodeWatermark =[[NSUserDefaults standardUserDefaults] valueForKey: [BNSubmitSinglePaymentCardGuiSetting GetGuiKey:paySecurityCodeWatermark]];
        _submitSinglePaymentCardGuiSetting.switchButtonColor =[[NSUserDefaults standardUserDefaults] valueForKey: [BNSubmitSinglePaymentCardGuiSetting GetGuiKey:switchButtonColor]];
        _submitSinglePaymentCardGuiSetting.payButtonColor =[[NSUserDefaults standardUserDefaults] valueForKey: [BNSubmitSinglePaymentCardGuiSetting GetGuiKey:payButtonColor]];
        _submitSinglePaymentCardGuiSetting.payButtonText =[[NSUserDefaults standardUserDefaults] valueForKey: [BNSubmitSinglePaymentCardGuiSetting GetGuiKey:payButtonText]];
        _submitSinglePaymentCardGuiSetting.loadingBarColor =[[NSUserDefaults standardUserDefaults] valueForKey: [BNSubmitSinglePaymentCardGuiSetting GetGuiKey:loadingBarColor]];
        if([[[[NSUserDefaults standardUserDefaults] dictionaryRepresentation]allKeys] containsObject:[BNSubmitSinglePaymentCardGuiSetting GetGuiKey:cardIODisable]])
        {
            _submitSinglePaymentCardGuiSetting.cardIODisable =[[NSUserDefaults standardUserDefaults] boolForKey:[BNSubmitSinglePaymentCardGuiSetting GetGuiKey:cardIODisable]];
        }
        else
        {
            _submitSinglePaymentCardGuiSetting.cardIODisable=NO;
        }
        _submitSinglePaymentCardGuiSetting.cardIOColor =[[NSUserDefaults standardUserDefaults] valueForKey: [BNSubmitSinglePaymentCardGuiSetting GetGuiKey:cardIOColor]];
    }
    return _submitSinglePaymentCardGuiSetting;
}





//Set CardRegistrationGuiSetting to the NSUserDefaults, and catch as class property.
- (void) setCardRegistrationGuiSetting:(BNCardRegistrationGuiSetting*) guiSetting{
    if(guiSetting==nil)
        return;
   
    [[NSUserDefaults standardUserDefaults] setValue: guiSetting.titleText forKey:[BNCardRegistrationGuiSetting GetGuiKey:registrationTitleText]];
    [[NSUserDefaults standardUserDefaults] setValue: guiSetting.cardHolderWatermark forKey:[BNCardRegistrationGuiSetting GetGuiKey:registrationCardHolderWatermark]];
    [[NSUserDefaults standardUserDefaults] setValue: guiSetting.cardNumberWatermark forKey:[BNCardRegistrationGuiSetting GetGuiKey:registrationCardNumberWatermark]];
    [[NSUserDefaults standardUserDefaults] setValue: guiSetting.expiryDateWatermark forKey:[BNCardRegistrationGuiSetting GetGuiKey:registrationExpiryDateWatermark]];
    [[NSUserDefaults standardUserDefaults] setValue: guiSetting.securityCodeWatermark forKey:[BNCardRegistrationGuiSetting GetGuiKey:registrationSecurityCodeWatermark]];
    [[NSUserDefaults standardUserDefaults] setValue: guiSetting.registerButtonText forKey:[BNCardRegistrationGuiSetting GetGuiKey:registrationButtonText]];
    [[NSUserDefaults standardUserDefaults] setValue: guiSetting.registrationButtonColor forKey:[BNCardRegistrationGuiSetting GetGuiKey:registrationButtonColor]];
    [[NSUserDefaults standardUserDefaults] setBool:guiSetting.registrationCardIODisable forKey:[BNCardRegistrationGuiSetting GetGuiKey:registrationCardIODisable]];
    [[NSUserDefaults standardUserDefaults] setValue: guiSetting.registrationCardIOColor forKey:[BNCardRegistrationGuiSetting GetGuiKey:registrationCardIOColor]];
    [[NSUserDefaults standardUserDefaults] synchronize];
    _cardRegistrationGuiSetting = guiSetting;
}

//Set setSubmitSinglePaymentCardGuiSetting to the NSUserDefaults, and catch as class property.
- (void) setSubmitSinglePaymentCardGuiSetting:(BNSubmitSinglePaymentCardGuiSetting*) guiSetting{
    if(guiSetting==nil)
        return;
    [[NSUserDefaults standardUserDefaults] setValue: guiSetting.titleText forKey:[BNSubmitSinglePaymentCardGuiSetting GetGuiKey:payTitleText]];
    [[NSUserDefaults standardUserDefaults] setValue: guiSetting.cardHolderWatermark forKey:[BNSubmitSinglePaymentCardGuiSetting GetGuiKey:payCardHolderWatermark]];
    [[NSUserDefaults standardUserDefaults] setValue: guiSetting.cardNumberWatermark forKey:[BNSubmitSinglePaymentCardGuiSetting GetGuiKey:payCardNumberWatermark]];
    [[NSUserDefaults standardUserDefaults] setValue: guiSetting.expiryDateWatermark forKey:[BNSubmitSinglePaymentCardGuiSetting GetGuiKey:payExpiryDateWatermark]];
    [[NSUserDefaults standardUserDefaults] setValue: guiSetting.securityCodeWatermark forKey:[BNSubmitSinglePaymentCardGuiSetting GetGuiKey:paySecurityCodeWatermark]];
    [[NSUserDefaults standardUserDefaults] setValue: guiSetting.payButtonText forKey:[BNSubmitSinglePaymentCardGuiSetting GetGuiKey:payButtonText]];
    [[NSUserDefaults standardUserDefaults] setValue: guiSetting.payButtonColor forKey:[BNSubmitSinglePaymentCardGuiSetting GetGuiKey:payButtonColor]];
    [[NSUserDefaults standardUserDefaults] setValue: guiSetting.switchButtonColor forKey:[BNSubmitSinglePaymentCardGuiSetting GetGuiKey:switchButtonColor]];
    [[NSUserDefaults standardUserDefaults] setValue: guiSetting.loadingBarColor forKey:[BNSubmitSinglePaymentCardGuiSetting GetGuiKey:loadingBarColor]];
    [[NSUserDefaults standardUserDefaults] setBool:guiSetting.cardIODisable forKey:[BNSubmitSinglePaymentCardGuiSetting GetGuiKey:cardIODisable]];
    [[NSUserDefaults standardUserDefaults] setValue: guiSetting.cardIOColor forKey:[BNSubmitSinglePaymentCardGuiSetting GetGuiKey:cardIOColor]];
    [[NSUserDefaults standardUserDefaults] synchronize];
    _submitSinglePaymentCardGuiSetting = guiSetting;
}




- (NSString *)getTestUrl {
    return @"";
}

- (NSString *)getTestToken {
    return @"";
}

- (NSString *)getProdUrl {
    return @"";
}

- (NSString *)getProdToken {
    return @"";
}

- (NSString *)getCompileDate {
    return [NSString stringWithUTF8String:__DATE__];
}

- (NSString *)getCompileTime {
    return [NSString stringWithUTF8String:__TIME__];
}



- (BNAuthorizedCreditCard *)selectedCard {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSInteger selectedIndex = [userDefault integerForKey:FavoriteCardKey];
    NSArray *cards = [[BNPaymentHandler sharedInstance] authorizedCards];
    
    if(selectedIndex < cards.count) {
        return cards[selectedIndex];
    }
    
    return nil;
}


-(NSDictionary*) readJsonFromResource:(NSString*) resourceName
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:resourceName ofType:@"json"];
    NSError *deserializingError;
    NSURL *localFileURL = [NSURL fileURLWithPath:filePath];
    NSData *contentOfLocalFile = [NSData dataWithContentsOfURL:localFileURL];
    id object = [NSJSONSerialization JSONObjectWithData:contentOfLocalFile
                                                options:kNilOptions
                                                  error:&deserializingError];
    
    return object;
}


-(NSDictionary*) retrieveJsonDataforKey:(NSString*)key
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString* jsonText = [userDefault stringForKey:key];
    if (jsonText != nil || [jsonText length]>0 ){
        
        NSData *data = [jsonText dataUsingEncoding:NSUTF8StringEncoding];
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        return json;
    } else {
    
        NSDictionary* data = [self readJsonFromResource:key];
        return data;
    }
    return nil;
}

-(void) persistJsonDataRegistration:(NSString*) s forKey:(NSString*)key
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:s forKey:key];
    [userDefault synchronize];
}


- (BNPaymentParams *) createMockPaymentParameters:(NSNumber*) amount comment:(NSString*) comment token:(NSString*) token{
    NSString* paymentIdentifier = [NSString stringWithFormat:@"%u", arc4random_uniform(INT_MAX)];
    BNPaymentParams *mockObject = [BNPaymentParams paymentParamsWithId:paymentIdentifier currency:@"AUD" amount:amount token:token comment:comment];

    NSDictionary* data = [self retrieveJsonDataforKey:kPaymentData];
    [mockObject setPaymentJsonData: data];
    
    
    return mockObject;
}

- (BNPaymentParams *) createMockSinglePaymentParameters:(NSNumber*) amount comment:(NSString*) comment{
    NSString* paymentIdentifier = [NSString stringWithFormat:@"%u", arc4random_uniform(INT_MAX)];
    BNPaymentParams *mockObject = [BNPaymentParams paymentParamsWithId:paymentIdentifier currency:@"AUD" amount:amount token:@"" comment:comment];
    
    NSDictionary* data = [self retrieveJsonDataforKey:kPaymentData];
    [mockObject setPaymentJsonData: data];
    
    
    return mockObject;
}
@end
