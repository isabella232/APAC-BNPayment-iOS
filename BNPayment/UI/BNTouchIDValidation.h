//
//  BNTouchIDValidation.h
//  BNPayment
//
//  Created by Max Mattini on 1/05/2017.
//  Copyright © 2017 Bambora. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BNTouchIDValidation: NSObject


/**
 *  Enable Touch ID payment validation by the SDK.
 *
 *  Note: It is not enough to enable Touch ID validation for the Touch ID dialog to appear.
 *  The 'makePaymentExtWithParams' method in BNPaymentHandler, should set the 'requirePaymentValidation' parameter.
 *
 * IMPORTANT NOTE
 * The SDK has no control on where the app developer will put the ‘pay button’ in the UI.
 * A priori, payment could be initiated from a alert dialog box, by clicking a cell in a list, from a normal page, etc…
 * In some cases, the app may not be able to present the ‘standard Apple Touch Id Dialog’ 
 * (e.g. if payment is initiated from a modal dialog box for example). In those cases, touch ID validation should be disabled
 */
+(void) enable;

/**
 *  disable Touch ID payment validation by the SDK.
 */
+(void) disable;
@end
