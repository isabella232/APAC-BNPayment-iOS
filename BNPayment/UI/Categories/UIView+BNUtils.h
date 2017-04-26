//
//  UIView+BNUtils.h
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

#import <UIKit/UIKit.h>

@interface UIView (BNUtils)

/**
 *  A method for changing origin y of an `UIView`.
 *
 *  @param yOffset New y origin of the view
 */
- (void)setYoffset:(NSInteger)yOffset;

/**
 *  A method for changing origin x of an `UIView`.
 *
 *  @param xOffset New x origin of the view
 */
- (void)setXoffset:(NSInteger)xOffset;

/**
 *  A method for setting height of an `UIView`.
 *
 *  @param height New height of the view
 */
- (void)setHeight:(NSInteger)height;

/**
 *  A method for setting width of an `UIView`.
 *
 *  @param width New width of the view.
 */
- (void)setWidth:(NSInteger)width;

/**
 *  A method for setting a corner radius of an `UIView`
 *
 *  @param cornerRadius New corner radius of the view.
 */
- (void)setCornerRadius:(NSInteger)cornerRadius;

@end
