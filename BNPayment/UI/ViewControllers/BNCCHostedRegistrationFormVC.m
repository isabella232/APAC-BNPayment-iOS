//
//  BNCCHostedRegistrationFormVC.m
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

#import "BNBundleUtils.h"
#import "BNCCFormInputGroup.h"
#import "BNCCHostedFormParams.h"
#import "EPAYHostedFormStateChange.h"
#import "BNCCHostedRegistrationFormVC.h"
#import "BNPaymentHandler.h"
#import "BNPaymentWebview.h"
#import "UIView+BNUtils.h"
#import "BNAuthorizedCreditCard.h"
#import "BNHostedRegistrationFormFooter.h"

@interface BNCCHostedRegistrationFormVC  () <BNPaymentWebviewDelegate, WKNavigationDelegate>

@property (nonatomic, strong) IBOutlet UIScrollView *contentView;
@property (nonatomic, strong) IBOutlet UIView *headerContainerView;
@property (nonatomic, strong) IBOutlet UIView *webviewContainerView;
@property (nonatomic, strong) IBOutlet UIView *footerContainerView;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *headerHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *webviewHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *footerHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *contentViewBottomMargin;

@property (strong, nonatomic) NSURLSessionDataTask *webviewURLDataTask;

@property (nonatomic, assign) CGFloat headerViewHeight;
@property (nonatomic, assign) CGFloat footerViewHeight;

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) BNPaymentWebview *webView;
@property (nonatomic, strong) UIView *footerView;

@property (nonatomic, strong) BNCCHostedFormParams *requestParams;

@property (nonatomic, assign) BOOL keyboardShowing;
@property (nonatomic, assign) BOOL isCardRegistered;

@end

@implementation BNCCHostedRegistrationFormVC

static int kObservingContentSizeChangesContext;
static float AnimationDuration = 0.2f;

- (instancetype)initWithHostedFormParams:(BNCCHostedFormParams *)params {
    self = [super initWithNibName:@"BNCCHostedRegistrationFormVC" bundle:[BNBundleUtils paymentLibBundle]];
    
    if (self) {
        self.webviewDelegate = self;
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.requestParams = params;
        
    }
    
    return self;
}

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupWebview];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupHeaderAndFooterView];
    [self.webView.scrollView addObserver:self forKeyPath:@"contentSize" options:0 context:&kObservingContentSizeChangesContext];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.webviewURLDataTask cancel];
    self.webView.scrollView.delegate = nil;
    [self.webView.scrollView removeObserver:self forKeyPath:@"contentSize" context:&kObservingContentSizeChangesContext];
}

- (void)setupHeaderAndFooterView {
    if (self.headerView) {
        [self.headerView setWidth:CGRectGetWidth(self.headerContainerView.frame)];
        [self.headerContainerView addSubview:self.headerView];
        self.headerViewHeight = CGRectGetHeight(self.headerView.frame);
        self.headerHeight.constant = self.headerViewHeight;
    }

    if (self.footerView) {
        [self.footerView setWidth:CGRectGetWidth(self.footerContainerView.frame)];
        [self.footerContainerView addSubview:self.footerView];
        self.footerViewHeight = CGRectGetHeight(self.footerView.frame);
        self.footerHeight.constant = self.footerViewHeight;
    }
}

#pragma mark - Public methods

- (void)addHeaderView:(UIView *)headerView {
    self.headerView = headerView;
    self.headerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
}

- (void)addFooterView:(UIView *)footerView {
    self.footerView = footerView;
    self.footerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context == &kObservingContentSizeChangesContext) {
        CGSize contentSize = ((UIScrollView *)object).contentSize;
        if (contentSize.height != self.webviewHeight.constant && contentSize.width == self.webView.frame.size.width) {
            [self animateWebviewContentWithContentSize:contentSize];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - Handle keyboard

- (void)onKeyboardWillShow:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    self.keyboardShowing = YES;

    if (userInfo) {
        CGSize kbSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
        CGFloat animationDuration = [[userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        
        [self animateContentViewBottomMargin:kbSize.height duration:animationDuration];
    }
}

- (void)onKeyboardWillHide:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    self.keyboardShowing = NO;
    
    if (userInfo) {
        CGFloat animationDuration = [[userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];

        // Ugly fix for avoiding doing an extra animation when the webview changes input
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_MSEC), dispatch_get_main_queue(), ^{
            [self animateContentViewBottomMargin:0 duration:animationDuration];
        });
    }
}

#pragma mark - Animation methods

- (void)animateContentViewBottomMargin:(CGFloat)bottomMagin duration:(CGFloat)duration {
 
    // Prevent unecessary animation
    if ((self.keyboardShowing && bottomMagin == 0) || (bottomMagin == self.contentViewBottomMargin.constant)) {
        return;
    }

    self.headerHeight.constant = [self calculateHeaderHeight:bottomMagin];
    self.contentViewBottomMargin.constant = bottomMagin;
    
    [UIView animateWithDuration:duration delay:0  options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
}

- (void)animateWebviewContentWithContentSize:(CGSize)contentSize {
    [UIView animateWithDuration:0 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.webviewHeight.constant = contentSize.height;
        [self.webView setHeight:contentSize.height];
        self.webviewContainerView.clipsToBounds = YES;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished){
        self.webviewContainerView.clipsToBounds = NO;

        [UIView animateWithDuration:AnimationDuration delay:AnimationDuration options:UIViewAnimationOptionCurveEaseIn animations:^{
            [self setWebViewLoading:self.webView.loading];
        } completion:^(BOOL finished) {
            
        }];
    }];
}

- (CGFloat)calculateHeaderHeight:(CGFloat) bottomMargin {
    if (bottomMargin > 0) {
        CGFloat contentViewContentOffset = self.contentView.contentOffset.y;
        return self.headerViewHeight - MAX(0, self.headerViewHeight-contentViewContentOffset);
    }
    
    return self.headerViewHeight;
}

#pragma mark - Handling webview

- (void)setupWebview {
    if(!self.webView) {
        self.webView = [[BNPaymentWebview alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), self.webviewHeight.constant)];
        self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.webView.translatesAutoresizingMaskIntoConstraints = NO;
        self.webView.scrollView.scrollEnabled = NO;
        self.webView.scrollView.clipsToBounds = NO;
        self.webView.delegate = self.webviewDelegate;
        [self addBNWebview];
    }
}

- (void)addBNWebview {
    [self.webviewContainerView addSubview:self.webView];
    [self.webviewContainerView bringSubviewToFront:self.activityIndicator];
    [self setWebViewLoading:YES];
    [self.webView loadPaymentWebviewWithParams:self.requestParams];
}

- (void)setWebViewLoading:(BOOL)isLoading {
    CGFloat webviewAplha = isLoading ? 0 : 1.f;
    
    if (isLoading) {
        [self.activityIndicator startAnimating];
    }else {
        [self.activityIndicator stopAnimating];
    }
    
    self.activityIndicator.alpha = 1-webviewAplha;
    self.webView.alpha = webviewAplha;
}

#pragma mark - BNPaymentWebviewDelegate methods

- (void)BNPaymentWebview:(BNPaymentWebview *)webview didRegisterAuthorizedCard:(BNAuthorizedCreditCard *)authorizedCard {
    [self setWebViewLoading:self.webView.isLoading];
}

- (void)BNPaymentWebview:(BNPaymentWebview *)webview didStartOperation:(BNPaymentWebviewOperation)operation {
    [self setWebViewLoading:self.webView.isLoading];
}

- (void)BNPaymentWebview:(BNPaymentWebview *)webview didFinishOperation:(BNPaymentWebviewOperation)operation {
    [self setWebViewLoading:self.webView.isLoading];
}

- (void)BNPaymentWebview:(BNPaymentWebview *)webview didFailOperation:(BNPaymentWebviewOperation)operation withError:(NSError *)error {
    [self setWebViewLoading:self.webView.isLoading];
}

@end
