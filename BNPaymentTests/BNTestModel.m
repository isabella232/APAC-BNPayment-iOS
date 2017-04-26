//
//  BNTestModel.m
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

#import "BNTestModel.h"

@interface BNTestModel ()

@property (nonatomic, copy) NSString *modelId;
@property (nonatomic, assign) NSInteger totalAmount;
@property (nonatomic, assign) BOOL isValid;
@property (nonatomic, copy) BNTestModel *customModel;
@property (nonatomic, strong) NSArray<BNTestModel *> *customModels;

@end

@implementation BNTestModel

+ (NSDictionary *)JSONMappingDictionary {
    return @{
             @"modelId": @"model_id",
             @"totalAmount": @"total_amount",
             @"isValid": @"is_valid",
             @"customModel": @"custom_model",
             @"customModels": @"custom_models"
             };
}

- (instancetype)initWithJSONDictionary:(NSDictionary *)JSONDictionary error:(NSError *__autoreleasing *)error {
    self = [super initWithJSONDictionary:JSONDictionary error:error];
    
    if (self) {
        if (self.customModels) {
            NSMutableArray *newArray = [[NSMutableArray alloc] initWithCapacity:[self.customModels count]];
            for(NSDictionary *dict in self.customModels) {
                BNTestModel *test = [[BNTestModel alloc] initWithJSONDictionary:dict error:error];
                [newArray addObject:test];
            }
            self.customModels = newArray;
        }
    }
    
    return self;
}

+ (BNTestModel *)correctMockObject {
    NSError *error;
    return [[BNTestModel alloc] initWithJSONDictionary:[self.class correctJSONDictionary] error:&error];
}

+ (BNTestModel *)missingParamsMockObject {
    NSError *error;
    return [[BNTestModel alloc] initWithJSONDictionary:[self.class missingParamsJSONDictionary] error:&error];
}

+ (BNTestModel *)extraParamsMockObject {
    NSError *error;
    return [[BNTestModel alloc] initWithJSONDictionary:[self.class extraParamsJSONDictionary] error:&error];
}

+ (NSDictionary *)correctJSONDictionary {
    NSDictionary *dict = @{
                           @"model_id" : @"ID0",
                           @"total_amount" : @100,
                           @"is_valid" : @YES,
                           @"custom_model": @{
                                   @"model_id" : @"ID1",
                                   @"total_amount" : @1000,
                                   @"is_valid" : @YES
                                   },
                           @"custom_models": @[@{
                                                   @"model_id" : @"ID4",
                                                   @"total_amount" : @1000,
                                                   @"is_valid" : @YES
                                                 },
                                               @{
                                                   @"model_id" : @"ID5",
                                                   @"total_amount" : @1000,
                                                   @"is_valid" : @YES
                                                 }
                                               ]
                           };
    
    return dict;
}

+ (NSDictionary *)missingParamsJSONDictionary {
    NSDictionary *dict = @{
                           @"model_id" : @"ID0",
                           @"total_amount" : @100,
                           @"custom_model": @{
                                   @"model_id" : @"ID1",
                                   @"is_valid" : @YES
                                   },
                           @"custom_models": @[@{
                                                   @"model_id" : @"ID4",
                                                   @"total_amount" : @1000,
                                                   @"is_valid" : @YES
                                                   },
                                               @{
                                                   @"model_id" : @"ID5",
                                                   @"total_amount" : @1000,
                                                   @"is_valid" : @YES
                                                   }
                                               ]
                           };
    return dict;
}

+ (NSDictionary *)extraParamsJSONDictionary {
    NSDictionary *dict = @{
                           @"model_id" : @"ID0",
                           @"total_amount" : @100,
                           @"is_valid" : @YES,
                           @"extra_param" : @"extraParam",
                           @"custom_model": @{
                                   @"model_id" : @"ID1",
                                   @"total_amount" : @1000,
                                   @"is_valid" : @YES
                                   },
                           @"custom_models": @[@{
                                                   @"model_id" : @"ID4",
                                                   @"total_amount" : @1000,
                                                   @"is_valid" : @YES
                                                   },
                                               @{
                                                   @"model_id" : @"ID5",
                                                   @"total_amount" : @1000,
                                                   @"is_valid" : @YES
                                                   }
                                               ]
                           };
    
    return dict;
}

@end
