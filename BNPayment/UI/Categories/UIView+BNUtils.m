//
//  UIView+BNUtils.m
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

#import "UIView+BNUtils.h"

@implementation UIView (BNUtils)

- (void)setYoffset:(NSInteger)yOffset {
    CGRect tmpRect = self.frame;
    tmpRect.origin.y = yOffset;
    self.frame = tmpRect;
}

- (void)setXoffset:(NSInteger)xOffset {
    CGRect tmpRect = self.frame;
    tmpRect.origin.x = xOffset;
    self.frame = tmpRect;
}

- (void)setHeight:(NSInteger)height {
    CGRect tmpRect = self.frame;
    tmpRect.size.height = height;
    self.frame = tmpRect;
}

- (void)setWidth:(NSInteger)width {
    CGRect tmpRect = self.frame;
    tmpRect.size.width = width;
    self.frame = tmpRect;
}

- (void)setCornerRadius:(NSInteger)cornerRadius {
    self.layer.cornerRadius = cornerRadius;
    self.clipsToBounds = YES;
}

@end
