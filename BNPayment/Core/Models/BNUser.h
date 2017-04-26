//
//  BNUser.h
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

#import "BNBaseModel.h"

/**
 * `BNUser` is a class containing information about the user that you want to register.
 * `BNUser` is provided in the registration API call.
 */
@interface BNUser : BNBaseModel

///------------------------------------------------
/// @name Properties
///------------------------------------------------

/**
*  Add your own reference to the user that you want to register.
*/
@property (strong, nonatomic) NSString *reference;

/**
 *  Add an email to the user.
 */
@property (strong, nonatomic) NSString *email;

/**
 *  Add a phone number to the user.
 */
@property (strong, nonatomic) NSString *phoneNumber;

/**
 *  Add a name to the user.
 */
@property (strong, nonatomic) NSString *name;

@end
