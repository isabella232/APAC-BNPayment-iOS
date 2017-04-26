//
//  BNLoaderButton.m
//  BNPayment
//
//  Created by Oskar Henriksson on 27/06/2016.
//  Copyright © 2016 Bambora. All rights reserved.
//

#import "BNLoaderButton.h"

@interface BNLoaderButton ()

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@end

@implementation BNLoaderButton

- (instancetype)init {
    self = [super init];
    
    if(self) {
        self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [self addSubview:self.activityIndicator];
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    NSLog(@"Draw rect");
    self.activityIndicator.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
}

- (void)setLoading:(BOOL)loading {
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.enabled = !loading;
        self.alpha = loading ? .5f : 1.f;
        self.titleLabel.alpha = loading ? 0.f : 1.f;
        if(loading) {
            [self.activityIndicator startAnimating];
        }else {
            [self.activityIndicator stopAnimating];
        }
    } completion:nil];
}

@end
