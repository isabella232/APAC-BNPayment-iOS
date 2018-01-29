#import "VisaCheckOutButton.h"


@interface VisaCheckOutButton ()<WKNavigationDelegate,WKScriptMessageHandler>

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@end

@implementation VisaCheckOutButton


- (instancetype)init {
    self = [super init];
    
    if(self) {
        self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        
        [self addSubview:self.activityIndicator];
        
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    self.activityIndicator.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    
}

-(void)loadUIWithViewController:(UIViewController *)viewController andData:(VisaCheckoutLaunchParams *)visaCheckoutLaunchParams andLoadingColor:(UIColor *)color{
    [self.activityIndicator setColor:color];
    [self.activityIndicator startAnimating];
    [self setBackgroundColor:[UIColor clearColor]];
    [self.scrollView setHidden:YES];
    
    [NSHTTPCookieStorage sharedHTTPCookieStorage].cookieAcceptPolicy
    = NSHTTPCookieAcceptPolicyAlways;
   
    [VisaCheckoutPlugin configure:self.configuration.userContentController viewController:viewController];
    self.scrollView.scrollEnabled=NO;
    self.navigationDelegate = self;

     NSBundle *bundle = [NSBundle bundleForClass:self.class];
    NSString* path = [bundle pathForResource:@"VisaCheckOutConnector" ofType:@"html"];
    NSString* content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];

    content=[NSString stringWithFormat: content,visaCheckoutLaunchParams.apikey,visaCheckoutLaunchParams.externalClientId,visaCheckoutLaunchParams.externalProfileId,visaCheckoutLaunchParams.currencyCode,visaCheckoutLaunchParams.subtotal,visaCheckoutLaunchParams.total,visaCheckoutLaunchParams.locale,visaCheckoutLaunchParams.collectShipping,visaCheckoutLaunchParams.message,visaCheckoutLaunchParams.buttonAction,visaCheckoutLaunchParams.buttonImageUrl,visaCheckoutLaunchParams.jsLibraryUrl];

    [self loadHTMLString:content baseURL:nil];
    
    
}


- (void)dealloc{
    [self.configuration.userContentController removeScriptMessageHandlerForName:@"callBackCancel"];
    [self.configuration.userContentController removeScriptMessageHandlerForName:@"callBackSuccess"];
    [self.configuration.userContentController removeScriptMessageHandlerForName:@"callBackError"];
}


- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
    if(![webView isLoading])
    {
        [self.activityIndicator stopAnimating];
        [self.scrollView setHidden:NO];
        
        [self.configuration.userContentController addScriptMessageHandler:self name:@"callBackCancel"];
        [self.configuration.userContentController addScriptMessageHandler:self name:@"callBackSuccess"];
        [self.configuration.userContentController addScriptMessageHandler:self name:@"callBackError"];
        
        [self.resultDelegate VisaCheckoutSetupComplete];
    }
    
}



- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    
    if([message.name isEqualToString:@"callBackSuccess"])
    {
        NSError *deserializingError;
        NSData *data=[message.body dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *VisaCheckoutPayment = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&deserializingError];
        [self.resultDelegate VisaCheckoutSuccess:VisaCheckoutPayment];
    }
    else if([message.name isEqualToString:@"callBackError"])
    {
        [self.resultDelegate VisaCheckoutFail:message.body];
    }

}




@end
