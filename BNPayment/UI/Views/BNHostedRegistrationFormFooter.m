
//
//  BNHostedRegistrationFormFooter.m
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

#import "BNHostedRegistrationFormFooter.h"

@interface BNHostedRegistrationFormFooter ()

@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation BNHostedRegistrationFormFooter


- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        CGFloat width = CGRectGetWidth(frame);
        CGFloat height = CGRectGetHeight(frame);
        
        self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.textLabel.numberOfLines = 0;
        self.textLabel.textColor = [UIColor lightGrayColor];
        self.textLabel.font = [UIFont systemFontOfSize:12.f];
        self.textLabel.text = @"Secure payments provided by Bambora\nVISA and MasterCard are accepted";
        self.textLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        [self addSubview:self.textLabel];
    }
    
    return self;
}


@end
