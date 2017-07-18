//
//  BNViewController.m
//  BNPayment
//
//  Created by Bambora On Mobile AB on 11/12/2015.
//  Copyright (c) 2015 Bambora On Mobile AB. All rights reserved.
//

#import "ViewController.h"
#import <BNPayment/BNPayment.h>

@interface ViewController () <BNPaymentWebviewDelegate>

@end

@implementation ViewController {
    BNCCHostedRegistrationFormVC *ccHostedRegistrationVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)registerCreditCard:(id)sender {
    
    BNCreditCardRegistrationVC *vc = [BNCreditCardRegistrationVC new];
    vc.completionBlock = ^(BNCCRegCompletion completion, BNAuthorizedCreditCard *card){
        [self.navigationController popViewControllerAnimated:YES];
        [self displaAliasAlertWithAuthorizedCard:card];
    };
    
    [self.navigationController pushViewController:vc animated:YES];
}

-(IBAction)registerCreditCardHostedForm:(id)sender {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 50)];
    
    ccHostedRegistrationVC = [[BNCCHostedRegistrationFormVC alloc] initWithHostedFormParams:[BNCCHostedFormParams mockObject]];
    ccHostedRegistrationVC.webviewDelegate = self;
    [ccHostedRegistrationVC addHeaderView:headerView];
    
    [self.navigationController pushViewController:ccHostedRegistrationVC animated:YES];
}

-(IBAction)unregisterCreditCard:(id)sender {
    NSArray *authorizedCards = [[BNPaymentHandler sharedInstance] authorizedCards];
    
    if (authorizedCards.count > 0) {
        
        NSMutableArray *actions = [[NSMutableArray alloc] initWithCapacity:authorizedCards.count+1];
        
        
        [authorizedCards enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            __weak BNAuthorizedCreditCard *cc = obj;
            NSString *actionTitle = cc.creditCardAlias ? cc.creditCardAlias : cc.creditCardNumber;

            UIAlertAction *action = [UIAlertAction actionWithTitle:actionTitle
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * _Nonnull action) {
                                                               [[BNPaymentHandler sharedInstance] removeAuthorizedCreditCard:cc];
                                                           }];
            [actions addObject:action];
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel
                                                             handler:nil];
        [actions addObject:cancelAction];
        
        [self displayAlertControllerWithStyle:UIAlertControllerStyleActionSheet
                                        title:@"Choose credit card"
                                      message:nil
                                       action:actions];
        
    } else {
        UIAlertAction* confirmAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:nil];
        [self displayAlertControllerWithStyle:UIAlertControllerStyleAlert
                                        title:@"No credit card registered"
                                      message:@"There is nothing to remove."
                                       action:@[confirmAction]];
    }
}

-(IBAction)makePurchase:(id)sender {
    NSArray *authorizedCards = [[BNPaymentHandler sharedInstance] authorizedCards];
    
    if(authorizedCards.count > 0) {
        
        NSMutableArray *actions = [[NSMutableArray alloc] initWithCapacity:authorizedCards.count+1];
        
        [authorizedCards enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            __weak BNAuthorizedCreditCard *cc = obj;
            NSString *actionTitle = cc.creditCardAlias ? cc.creditCardAlias : cc.creditCardNumber;
            
            UIAlertAction *action = [UIAlertAction actionWithTitle:actionTitle
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * _Nonnull action) {
                                                               [self makePaymentWithCard:cc];
                                                           }];
            [actions addObject:action];
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel
                                                              handler:nil];
        [actions addObject:cancelAction];
        
        [self displayAlertControllerWithStyle:UIAlertControllerStyleActionSheet
                                        title:@"Choose credit card"
                                      message:nil
                                       action:actions];
        
    } else {
        UIAlertAction* confirmAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel
                                                              handler:nil];
        [self displayAlertControllerWithStyle:UIAlertControllerStyleAlert
                                        title:@"No credit card registered"
                                      message:@"Please register a credit card in order to make a purchase."
                                       action:@[confirmAction]];
    }
}

- (void)makePaymentWithCard:(BNAuthorizedCreditCard *)card {
    BNPaymentParams *params = [BNPaymentParams mockObject];
    params.token = card.creditCardToken;
    
    [[BNPaymentHandler sharedInstance] makePaymentExtWithParams:params
                                                      result:^(NSDictionary<NSString*, NSString*>* response, BNPaymentResult result, NSError *error) {
                                                          BOOL success = result == BNPaymentSuccess;
                                                          NSString *title = success ? @"Success" : @"Failure";
                                                          
                                                          NSString* receipt = @"?";
                                                          if (response){
                                                              receipt = [response objectForKey:@"receipt"];
                                                          }
                                                          
                                                          NSString *message = success ?
                                                          [NSString stringWithFormat:@"The payment succeeded. receipt= %@", receipt]:
                                                          [NSString stringWithFormat:@"The payment did not succeed."];
                                                          
                                                          UIAlertAction* confirmAction = [UIAlertAction actionWithTitle:@"Ok"
                                                                                                                  style:UIAlertActionStyleDefault
                                                                                                                handler:nil];
                                                          
                                                          [self displayAlertControllerWithStyle:UIAlertControllerStyleAlert
                                                                                          title:title
                                                                                        message:message
                                                                                         action:@[confirmAction]];
                                                      }];
}


- (void)displaAliasAlertWithAuthorizedCard:(BNAuthorizedCreditCard *) __weak card {
    NSString *title = card ? @"Name" : @"No card";
    NSString *message = card ? @"Please name the credit card." : @"No credit card was registered!";
    
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if(card) {
            UITextField *aliasTextField = alertController.textFields.firstObject;
            card.creditCardAlias = aliasTextField.text.length > 0 ? aliasTextField.text : card.creditCardNumber;
            [[BNPaymentHandler sharedInstance] saveAuthorizedCreditCard:card];
        }
    }];
    
    if (card) {
        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"Name";
        }];
    }
    
    [alertController addAction:action];
    
    dispatch_async(dispatch_get_main_queue(), ^(){
        [self presentViewController:alertController animated:YES completion:nil];
    });
}

- (void)displayAlertControllerWithStyle:(UIAlertControllerStyle)style
                                  title:(NSString *)title
                                message:(NSString *)message
                                 action:(NSArray *)actions {
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:style];

    for (UIAlertAction *action in actions) {
        [alert addAction:action];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^(){
        [self presentViewController:alert animated:YES completion:nil];
    });
}

#pragma mark - BNPaymentWebviewDelegate methods

- (void)BNPaymentWebview:(BNPaymentWebview *)webview didRegisterAuthorizedCard:(BNAuthorizedCreditCard *)authorizedCard {
    dispatch_async(dispatch_get_main_queue(), ^(){
        [self.navigationController popViewControllerAnimated:YES];
        [self displaAliasAlertWithAuthorizedCard:authorizedCard];
    });
}

- (void)BNPaymentWebview:(BNPaymentWebview *)webview didStartOperation:(BNPaymentWebviewOperation)operation {
    if(operation == BNPWVOperationSubmitCCData) {
        [ccHostedRegistrationVC setWebViewLoading:YES];
    }
}

- (void)BNPaymentWebview:(BNPaymentWebview *)webview didFinishOperation:(BNPaymentWebviewOperation)operation {
    if(operation == BNPWVOperationSubmitCCData) {
        [ccHostedRegistrationVC setWebViewLoading:NO];
    }
}

- (void)BNPaymentWebview:(BNPaymentWebview *)webview didFailOperation:(BNPaymentWebviewOperation)operation withError:(NSError *)error {
    
    if (error.code == EPAYSubmissionDeclined) {
        [ccHostedRegistrationVC setWebViewLoading:NO];
        return;
    }
    
    UIAlertAction* confirmAction = [UIAlertAction actionWithTitle:@"Ok"
                                                            style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                                                dispatch_async(dispatch_get_main_queue(), ^(){
                                                                    [ccHostedRegistrationVC setWebViewLoading:NO];
                                                                    [self.navigationController popViewControllerAnimated:YES];
                                                                });
                                                            }];

    [self displayAlertControllerWithStyle:UIAlertControllerStyleAlert title:@"Error" message:@"Error" action:@[confirmAction]];
}

@end
