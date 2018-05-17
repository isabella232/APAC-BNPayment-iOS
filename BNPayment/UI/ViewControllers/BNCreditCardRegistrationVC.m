            //
//  BNCreditCardRegistrationVC.m
//  Copyright (c) 2016 Bambora ( http://bambora.com/ )
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "BNCreditCardRegistrationVC.h"
#import "BNBaseTextField.h"
#import "BNCreditCardNumberTextField.h"
#import "BNCreditCardExpiryTextField.h"
#import "UIView+BNUtils.h"
#import "UIColor+BNColors.h"
#import "UITextField+BNCreditCard.h"
#import "BNLoaderButton.h"
#import "CardIO.h"
#import <AVFoundation/AVCaptureDevice.h>
NSInteger const TextFieldHeight = 50;
NSInteger const ButtonHeight = 50;
NSInteger const Padding = 15;
NSInteger const TitleHeight = 30;

@interface BNCreditCardRegistrationVC ()

@property (nonatomic, strong) UIScrollView *formScrollView;
@property (nonatomic, strong) UILabel *titleLabel;


@property (nonatomic, strong) BNCreditCardHolderTextField *cardHolderTextField;
@property (nonatomic, strong) BNCreditCardNumberTextField *cardNumberTextField;
@property (nonatomic, strong) BNCreditCardExpiryTextField *cardExpiryTextField;
@property (nonatomic, strong) BNBaseTextField *cardCVCTextField;
@property (nonatomic, strong) UIButton *cardIOButton;
@property (nonatomic, strong) UIColor *cardIOColor;
@property (nonatomic, strong) BNLoaderButton *submitButton;
@property (nonatomic, strong) NSBundle *bundle;
@property (nonatomic, strong) NSString* alertContent;
@end

@implementation BNCreditCardRegistrationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.alertContent=@"";
    self.bundle = [BNBundleUtils getBundleFromCocoaPod];
    if(!self.bundle)
    {
    self.bundle=[BNBundleUtils paymentLibBundle];
    }
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupCreditCardForm];
   
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self layoutCreditCardForm];
    [self guiCustomisation];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [UIView setAnimationsEnabled:NO];
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        [UIView setAnimationsEnabled:YES];
        [self layoutCreditCardForm];
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
    }];
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];

}

- (void)layoutCreditCardForm {
    CGRect viewRect = self.view.bounds;
    
    self.formScrollView.frame = viewRect;
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(resignKeyboard)];
    [self.formScrollView addGestureRecognizer:panGestureRecognizer];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignKeyboard)];
    [self.formScrollView addGestureRecognizer:tapGestureRecognizer];
    
    self.titleLabel.frame = CGRectMake(Padding,
                                       Padding,
                                       CGRectGetWidth(viewRect)-2*Padding,
                                       TitleHeight);
    
    NSInteger inputWidth = floorf(CGRectGetWidth(viewRect)-2*Padding);
    inputWidth -= inputWidth % 2;
    
    self.cardHolderTextField.frame = CGRectMake(Padding,
                                                CGRectGetMaxY(self.titleLabel.frame)+5,
                                                inputWidth,
                                                TextFieldHeight);
    
    self.cardNumberTextField.frame = CGRectMake(Padding,
                                    CGRectGetMaxY(self.cardHolderTextField.frame)-1,
                                                inputWidth,
                                                TextFieldHeight);
    
    self.cardIOButton.frame = CGRectMake(Padding+inputWidth-60-TextFieldHeight*0.6,
                                         CGRectGetMinY(self.cardNumberTextField.frame)+TextFieldHeight*0.2,
                                         TextFieldHeight*0.6,
                                         TextFieldHeight*0.6);
    
    self.cardExpiryTextField.frame = CGRectMake(Padding,
                                                CGRectGetMaxY(self.cardNumberTextField.frame)-1,
                                                ceilf((inputWidth)/2.f),
                                                TextFieldHeight);
    
    self.cardCVCTextField.frame = CGRectMake(CGRectGetMaxX(self.cardExpiryTextField.frame)-1,
                                                CGRectGetMaxY(self.cardNumberTextField.frame)-1,
                                                ceilf((inputWidth)/2.f)+1,
                                                TextFieldHeight);
    
    self.submitButton.frame =   CGRectMake(0,CGRectGetMaxY(self.cardCVCTextField.frame)+30,
                                         CGRectGetWidth(viewRect),
                                         ButtonHeight);
}

- (void)setupCreditCardForm {
    self.formScrollView = [UIScrollView new];
    self.formScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:self.formScrollView];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = NSLocalizedString(@"ENTER CARD DETAILS", @"Card details");
    self.titleLabel.textColor = [UIColor BNTextColor];
    self.titleLabel.font = [UIFont systemFontOfSize:12.f weight:UIFontWeightMedium];
    [self.formScrollView addSubview:self.titleLabel];
    
    self.cardHolderTextField = [[BNCreditCardHolderTextField alloc] init];
    self.cardHolderTextField.placeholder = NSLocalizedString(@"Card Holder Name", @"Placeholder");
    // .* = .{0,} = match any char zero or more times
    self.cardHolderTextField.inputRegex = @".{0,}";
    self.cardHolderTextField.validRegex = @".{0,}";

    [self.cardHolderTextField applyAlphaNumericalStyle];
    [self.cardHolderTextField addTarget:self action:@selector(validateFields) forControlEvents:UIControlEventEditingChanged];
    [self.formScrollView addSubview:self.cardHolderTextField];

    
    self.cardNumberTextField = [[BNCreditCardNumberTextField alloc] init];
    self.cardNumberTextField.placeholder = NSLocalizedString(@"5555 5555 5555 5555", @"Placeholder");
    [self.cardNumberTextField applyStyle];
    [self.cardNumberTextField addTarget:self action:@selector(validateFields) forControlEvents:UIControlEventEditingChanged];
    [self.formScrollView addSubview:self.cardNumberTextField];
    
    self.cardIOButton=[[UIButton alloc] init];
    [self.cardIOButton addTarget:self
                          action:@selector(cardIOLaunch:)
                forControlEvents:UIControlEventTouchUpInside];
    UIImage *cameraImage = [UIImage loadImageWithName:@"camera"
                                    fromBundle:self.bundle];
    [self.cardIOButton setImage:cameraImage forState:UIControlStateNormal];
    [self.formScrollView addSubview:self.cardIOButton];
    
    self.cardExpiryTextField = [[BNCreditCardExpiryTextField alloc] init];
    self.cardExpiryTextField.placeholder = NSLocalizedString(@"MM/YY", @"Placeholder");
    [self.cardExpiryTextField applyStyle];
    [self.cardExpiryTextField addTarget:self action:@selector(validateFields) forControlEvents:UIControlEventEditingChanged];
    [self.formScrollView addSubview:self.cardExpiryTextField];
    
    self.cardCVCTextField = [[BNBaseTextField alloc] init];
    self.cardCVCTextField.placeholder = NSLocalizedString(@"000(0)", @"Placeholder");
    self.cardCVCTextField.inputRegex = @"^[0-9]{0,4}$";
    self.cardCVCTextField.validRegex = @"^[0-9]{3,4}$";
    [self.cardCVCTextField applyStyle];
    [self.cardCVCTextField addTarget:self action:@selector(validateFields) forControlEvents:UIControlEventEditingChanged];
    [self.formScrollView addSubview:self.cardCVCTextField];
    
    self.submitButton = [BNLoaderButton new];
    [self.submitButton setBackgroundColor:[UIColor BNPurpleColor]];
    [self.submitButton setTitle:NSLocalizedString(@"Save card", @"") forState:UIControlStateNormal];
    [self.submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.submitButton addTarget:self
                          action:@selector(submitCreditCardInformation:)
                forControlEvents:UIControlEventTouchUpInside];
    self.submitButton.enabled = NO;
    self.submitButton.alpha = .5f;
    [self.formScrollView addSubview:self.submitButton];
}

- (void)guiCustomisation {
    [self titleCustomisation];
    [self cardHolderNameCustomisation];
    [self cardNumberCustomisation];
    [self expiryDateCustomisation];
    [self securityCodeCustomisation];
    [self securityCodeCustomisation];
    [self registerButtonCustomisation];
    [self cardIOCustomisation];
    if(self.alertContent.length>0)
    {
        [self sendAlertWithContent:self.alertContent];
    }
}

- (void)titleCustomisation {
    if(_guiSetting==nil)
        return;
    if(_guiSetting.titleText!=nil &&
       _guiSetting.titleText.length>0 &&
       _titleLabel !=nil)
    {
       _titleLabel.text = NSLocalizedString(_guiSetting.titleText, @"Card details");

    }
}

- (void)cardHolderNameCustomisation {
    if(_guiSetting==nil)
        return;
    if(_guiSetting.cardHolderWatermark!=nil &&
       _guiSetting.cardHolderWatermark.length>0 &&
       _cardHolderTextField !=nil)
    {
        _cardHolderTextField.placeholder = NSLocalizedString(_guiSetting.cardHolderWatermark, @"Placeholder");
    }
}

- (void)cardNumberCustomisation {
    if(_guiSetting==nil)
        return;
    if(_guiSetting.cardNumberWatermark!=nil &&
       _guiSetting.cardNumberWatermark.length>0 &&
       _cardNumberTextField !=nil)
    {
        _cardNumberTextField.placeholder = NSLocalizedString(_guiSetting.cardNumberWatermark, @"Placeholder");
    }
}

- (void)expiryDateCustomisation {
    if(_guiSetting==nil)
        return;
    if(_guiSetting.expiryDateWatermark!=nil &&
       _guiSetting.expiryDateWatermark.length>0 &&
       _cardExpiryTextField !=nil)
    {
        _cardExpiryTextField.placeholder = NSLocalizedString(_guiSetting.expiryDateWatermark, @"Placeholder");
    }
}

- (void)securityCodeCustomisation {
    if(_guiSetting==nil)
        return;
    if(_guiSetting.securityCodeWatermark!=nil &&
       _guiSetting.securityCodeWatermark.length>0 &&
       _cardCVCTextField !=nil)
    {
        _cardCVCTextField.placeholder = NSLocalizedString(_guiSetting.securityCodeWatermark, @"Placeholder");
    }
}

- (void)registerButtonCustomisation {
    if(_guiSetting==nil || _submitButton==nil)
        return;
    if(_guiSetting.registerButtonText!=nil &&
       _guiSetting.registerButtonText.length>0)
    {
        [self.submitButton setTitle:NSLocalizedString(_guiSetting.registerButtonText, @"") forState:UIControlStateNormal];
    }
    if(_guiSetting.registrationButtonColor!=nil && _guiSetting.registrationButtonColor.length>0)
    {
        if([self checkColorValueWithColor:_guiSetting.registrationButtonColor])
        {
           [self.submitButton setBackgroundColor:[BNUtils colorFromHexString:_guiSetting.registrationButtonColor]];
        }
        else
        {
            self.alertContent = [NSString stringWithFormat:@"%@\n%@",self.alertContent,@"Registration Button Color is invalid!"];
        }
    }
}

-(void)sendAlertWithContent:(NSString *)content{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:content
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Ok"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              
                                                          }];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}


-(BOOL)checkColorValueWithColor:(NSString*)color{
    NSString *colorRegex = @"^#[A-Fa-f0-9]{6}$";
    NSPredicate *colorTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",colorRegex];
    return [colorTest evaluateWithObject:color];
}

- (void)cardIOCustomisation{
    if(_guiSetting!=nil && _cardIOButton!=nil)
    {
        if(!_guiSetting.registrationCardIODisable)
        {
            if(_guiSetting.registrationCardIOColor!=nil && _guiSetting.registrationCardIOColor.length>0)
            {
                if([self checkColorValueWithColor:_guiSetting.registrationCardIOColor])
                {
                    self.cardIOColor=[BNUtils colorFromHexString:_guiSetting.registrationCardIOColor];
                }
                else
                {
                    self.alertContent = [NSString stringWithFormat:@"%@\n%@",self.alertContent,@"CardIO Frame Color is invalid!"];
                    self.cardIOColor=[UIColor BNPurpleColor];
                }
            }
            else{
                self.cardIOColor=[UIColor BNPurpleColor];
            }
        }
        else
        {
            [_cardIOButton removeFromSuperview];
        }
    }
}


- (void)showAlertViewWithTitle:(NSString*)title message:(NSString*)message {

    NSString *closeButtonTitle = NSLocalizedString(@"OK", nil);
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message
                                                       delegate:nil
                                              cancelButtonTitle:closeButtonTitle
                                              otherButtonTitles:nil];
    [alertView show];
}

- (void)submitCreditCardInformation:(UIButton *)sender {
 
    BNCreditCard *creditCard = [BNCreditCard new];
    creditCard.holderName = [self.cardHolderTextField getCardHolderName];
    creditCard.cardNumber = [self.cardNumberTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    creditCard.expMonth = [self.cardExpiryTextField getExpiryMonth];
    creditCard.expYear = [self.cardExpiryTextField getExpiryYear];
    creditCard.cvv = self.cardCVCTextField.text;
    
    BNRegisterCCParams *params = [[BNRegisterCCParams alloc] initWithCreditCard:creditCard];
    
    [self.submitButton setLoading:YES];
    
    [[BNPaymentHandler sharedInstance] registerCreditCard:params completion:^(BNAuthorizedCreditCard *card, NSError *error) {
        if(self.completionBlock && card) {
            self.completionBlock(BNCCRegCompletionDone, card);
        }
        else {
            NSString *title = NSLocalizedString(@"Card registration failed", nil);
            NSString *detail = [BNHTTPResponseSerializer extractErrorDetail:error];
            NSString *m = [NSString stringWithFormat:@"%@\nPlease try again", detail];
            NSString *message = NSLocalizedString(m, nil);
            [self showAlertViewWithTitle:title message:message];
        }
        [self.submitButton setLoading:NO];
    }];
}

#pragma mark - Handle keyboard events

//- (void)onKeyboardWillHide:(NSNotification *)notification {
//    NSDictionary *userInfo = notification.userInfo;
//    if (userInfo) {
//        CGSize kbSize = [userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
//        CGFloat animationDuration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//
//        [self animateKeyboardVisible:NO kbSize:kbSize duration:animationDuration];
//    }
//}
//
//- (void)onKeyboardWillShow:(NSNotification *)notification {
//    NSDictionary *userInfo = notification.userInfo;
//    if (userInfo) {
//        CGSize kbSize = [userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
//        CGFloat animationDuration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//
//        [self animateKeyboardVisible:YES kbSize:kbSize duration:animationDuration];
//    }
//}
//
//- (void)animateKeyboardVisible:(BOOL)visible kbSize:(CGSize)kbSize duration:(CGFloat)duration {
//
//    CGFloat kbHeight = kbSize.height;
//    CGFloat viewHeight = CGRectGetHeight(self.view.frame);
//    CGFloat height = visible ? viewHeight-kbHeight + ButtonHeight : viewHeight;
//
//    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
//        int a = height-ButtonHeight;
//        int b = CGRectGetMaxY(self.cardCVCTextField.frame)+Padding;
//        [self.submitButton setYoffset:MAX(a,b)];
//        [self.formScrollView setHeight:height];
//    } completion:^(BOOL finished) {
//        [self.formScrollView setContentSize:CGSizeMake(CGRectGetWidth(self.view.frame), CGRectGetMaxY(self.submitButton.frame))];
//    }];
//}

- (void)validateFields {
    BOOL validCardNumber = [self.cardNumberTextField validCardNumber];
    BOOL validExpiry = [self.cardExpiryTextField validExpiryDate];
    
    BOOL validCVC = YES; // By default it is optional
    if ([self.cardCVCTextField.text length] != 0){
        validCVC = [self.cardCVCTextField validCVC];
    }
    
    
    
    // Now CVC is optional
    if(validCardNumber && validExpiry && validCVC) {
        self.submitButton.enabled = YES;
        self.submitButton.alpha = 1.f;
    }else {
        self.submitButton.enabled = NO;
        self.submitButton.alpha = 0.5f;
    }
}

- (void)resignKeyboard
{
    [self.cardHolderTextField resignFirstResponder];
    [self.cardNumberTextField resignFirstResponder];
    [self.cardExpiryTextField resignFirstResponder];
    [self.cardCVCTextField resignFirstResponder];
}

- (void)cardIOLaunch:(UIButton *)sender {
    AVAuthorizationStatus AVstatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (AVstatus) {
        case AVAuthorizationStatusAuthorized:
            [self startCardIO];
            break;
        case AVAuthorizationStatusDenied:
            [self askForCameraPermission];
            break;
        case AVAuthorizationStatusNotDetermined:
            [self startCardIO];
            break;
        case AVAuthorizationStatusRestricted:
            [self askForCameraPermission];
            break;
        default:
            break;
    }
}

-(void)askForCameraPermission{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:@"To scan your card, you need to enable the camera access."
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                                                              [[UIApplication sharedApplication] openURL:url];
                                                          }];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * action) {}];
    [alert addAction:cancelAction];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)startCardIO{
    CardIOPaymentViewController *scanViewController = [[CardIOPaymentViewController alloc] initWithPaymentDelegate:self];
    [scanViewController setCollectCVV:NO];
    [scanViewController setCollectCardholderName:NO];
    [scanViewController setScanExpiry:YES];
    [scanViewController setCollectExpiry:YES];
    [scanViewController setHideCardIOLogo:YES];
    [scanViewController setDisableManualEntryButtons:YES];
    [scanViewController setGuideColor:self.cardIOColor];
    [scanViewController setSuppressScannedCardImage:NO];
    [self presentViewController:scanViewController animated:YES completion:nil];
}

- (void)userDidCancelPaymentViewController:(CardIOPaymentViewController *)scanViewController {
    [scanViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)userDidProvideCreditCardInfo:(CardIOCreditCardInfo *)info inPaymentViewController:(CardIOPaymentViewController *)scanViewController {
    [self.cardNumberTextField setText:info.cardNumber];
    [self.cardNumberTextField sendActionsForControlEvents:UIControlEventEditingChanged];
    [self.cardNumberTextField resignFirstResponder];
    
    NSString *expiryMonth=[NSString stringWithFormat:@"%@",@(info.expiryMonth)];
    if(expiryMonth.length==1)
    {
        expiryMonth=[NSString stringWithFormat:@"0%@",@(info.expiryMonth)];
    }
    NSString *expiryYear=[[NSString stringWithFormat:@"%@", @(info.expiryYear)] substringWithRange:NSMakeRange(2,2)];
    [self.cardExpiryTextField setText:[NSString stringWithFormat:@"%@/%@",expiryMonth,expiryYear]];
    [self.cardExpiryTextField resignFirstResponder];
    
    [self validateFields];
    [scanViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
