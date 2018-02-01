#import "VisaCheckOutButton_iOS10.h"
#import <VisaCheckoutHybrid/VisaCheckoutHybrid.h>
@interface VisaCheckOutButton_iOS10 ()<UIWebViewDelegate>

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@end


@implementation VisaCheckOutButton_iOS10

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



-(void)loadUIWithViewController:(UIViewController *)viewController andData:(VisaCheckoutLaunchParams *)visaCheckoutLaunchParams andLoadingColor:(UIColor *)color;{
    [self.activityIndicator  setColor:color];
    [self.activityIndicator startAnimating];
    [self setBackgroundColor:[UIColor clearColor]];
    [self setOpaque:NO];
    [self.scrollView setHidden:YES];
    
    [NSHTTPCookieStorage sharedHTTPCookieStorage].cookieAcceptPolicy
    = NSHTTPCookieAcceptPolicyAlways;
    
   [VisaCheckoutPlugin configureWithWebView:self viewController:viewController];
    self.scrollView.scrollEnabled=NO;

    self.delegate = self;
    
    NSBundle *bundle = [BNBundleUtils getBundleFromCocoaPod];
    if(!bundle)
    {
        bundle=[BNBundleUtils paymentLibBundle];
    }
    NSString* path = [bundle pathForResource:@"VisaCheckOutConnector_iOS10" ofType:@"html"];
    NSString* content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
    
    content=[NSString stringWithFormat: content,visaCheckoutLaunchParams.apikey,visaCheckoutLaunchParams.externalClientId,visaCheckoutLaunchParams.externalProfileId,visaCheckoutLaunchParams.currencyCode,visaCheckoutLaunchParams.subtotal,visaCheckoutLaunchParams.total,visaCheckoutLaunchParams.locale,visaCheckoutLaunchParams.collectShipping,visaCheckoutLaunchParams.message,visaCheckoutLaunchParams.buttonAction,visaCheckoutLaunchParams.buttonImageUrl,visaCheckoutLaunchParams.jsLibraryUrl];
    
    [self loadHTMLString:content baseURL:nil];
}

- (BOOL)webView:(UIWebView* )webView shouldStartLoadWithRequest:(nonnull NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    if([VisaCheckoutPlugin shouldHandleRequest:request])
    {
        [VisaCheckoutPlugin handleRequest:request];
        return false;
    }
    return true;
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    if(![webView isLoading])
    {
        [self.activityIndicator stopAnimating];
        [self.scrollView setHidden:NO];

        JSContext *context=[webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
        
        context[@"visaCheckoutCallBackSuccess"] = ^() {
            JSValue *response=[JSContext currentArguments].firstObject;
            NSError *deserializingError;
            NSData *data=[[response toString] dataUsingEncoding:NSUTF8StringEncoding];
            
            NSDictionary *VisaCheckoutPayment = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&deserializingError];

            [self.resultDelegate VisaCheckoutSuccess:VisaCheckoutPayment];
        };
        
        context[@"visaCheckoutCallBackError"] = ^() {
            NSString *response=[JSContext currentArguments].firstObject;
            [self.resultDelegate VisaCheckoutFail:response];
        };
        
        context[@"visaCheckoutCallBackCancel"] = ^() {
            NSString *response=[JSContext currentArguments].firstObject;
        };
        
        [self.resultDelegate VisaCheckoutSetupComplete];
    }
}


@end
