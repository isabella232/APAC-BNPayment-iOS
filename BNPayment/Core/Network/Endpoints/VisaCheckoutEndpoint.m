#import "VisaCheckoutEndpoint.h"

@implementation VisaCheckoutEndpoint

+(NSURLSessionDataTask *)getVisaCheckoutWithCompletionHandler:(void(^)(VisaCheckoutLaunchParams* visaCheckoutLaunchParams,NSError* error))completionHandler{

    BNHTTPClient *httpClient = [[BNPaymentHandler sharedInstance] getHttpClient];
    
    NSString *endpointURL = @"visacheckout_params";

    NSURLSessionDataTask *dataTask = [httpClient GET:endpointURL parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSError *error;
        
        VisaCheckoutLaunchParams* visaCheckoutLaunchParams= [[VisaCheckoutLaunchParams alloc]initWithJSONDictionary:responseObject error:&error];
        
        completionHandler(visaCheckoutLaunchParams, error);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completionHandler(nil, error);
    }];
    
  return dataTask;
}


+(NSURLSessionDataTask *)processTransactionFromVisaCheckout:(VisaCheckoutTransactionParams*)visaCheckoutTransactionParams WithCompletionHandler:(void(^)(VisaCheckoutResponse* visaCheckoutResponse,NSError* error))completionHandler{

    BNHTTPClient *httpClient = [[BNPaymentHandler sharedInstance] getHttpClient];
    
    NSString *endpointURL = @"visacheckout_transaction";
    
    NSURLSessionDataTask *dataTask = [httpClient POST:endpointURL parameters:[visaCheckoutTransactionParams JSONDictionary] success:^(NSURLSessionDataTask *task, id responseObject) {
        NSError *error;
        
        VisaCheckoutResponse* visaCheckoutResponse= [[VisaCheckoutResponse alloc]initWithJSONDictionary:responseObject error:&error];
        
        completionHandler(visaCheckoutResponse, error);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completionHandler(nil, error);
    }];
    return dataTask;
}
@end
