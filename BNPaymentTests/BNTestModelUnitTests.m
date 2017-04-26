//
//  BNTestModelUnitTests.m
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
#import "BNPayment.h"
#import <XCTest/XCTest.h>

@interface BNTestModelUnitTests : XCTestCase

@end

@implementation BNTestModelUnitTests

- (void)testInitTestModelWithJSONDict {

    // When:
    BNTestModel *testModel = [BNTestModel correctMockObject];

    // Then:
    XCTAssertNotNil(testModel, "The testModel object should not be nil.");
    XCTAssertTrue([testModel isKindOfClass:[BNTestModel class]], "The class type of the testModel object should be BNTestModel.");
    XCTAssertEqualObjects(testModel.modelId, @"ID0", "The model id (testModel.modelId) should be ID0.");
    XCTAssertEqual(testModel.totalAmount, 100, "The total amount (testModel.totalAmount) should be 100.");
    XCTAssertTrue(testModel.isValid, "The testModel object should be valid (in other words, testModel.isValid should be TRUE).");
    XCTAssertTrue([testModel.customModel isKindOfClass:[BNTestModel class]], "The class type of the custom model (testModel.customModel) should be BNTestModel.");
}

- (void)testInitTestModelWithJSONDictExtraParams {

    // When:
    BNTestModel *testModel = [BNTestModel extraParamsMockObject];

    // Then:
    XCTAssertNotNil(testModel, "The testModel object should not contain nil.");
    XCTAssertTrue([testModel isKindOfClass:[BNTestModel class]], "The class type of the testModel object should be BNTestModel.");
    XCTAssertEqualObjects(testModel.modelId, @"ID0", "The model id (testModel.modelId) should be ID0.");
    XCTAssertEqual(testModel.totalAmount, 100, "The total amount (testModel.totalAmount) should be 100.");
    XCTAssertTrue(testModel.isValid, "The testModel object should be valid (in other words, testModel.isValid should be TRUE).");
    XCTAssertTrue([testModel.customModel isKindOfClass:[BNTestModel class]], "The class type of the custom model (testModel.customModel) should be BNTestModel.");
}

- (void)testInitTestModelWithNilDictionary {

    // When:
    NSError *error;
    BNTestModel *testModel = [[BNTestModel alloc] initWithJSONDictionary:nil error:&error];

    // Then:
    XCTAssertNil(error);
    XCTAssertNotNil(testModel, "The testModel object should not be nil.");
    XCTAssertTrue([testModel isKindOfClass:[BNTestModel class]], "The class type of the testModel object should be BNTestModel.");
    XCTAssertNil(testModel.modelId, "The model id (testModel.modelId) should be nil.");
    XCTAssertEqual(testModel.totalAmount, 0, "The total amount (testModel.totalAmount) should be 0.");
    XCTAssertFalse(testModel.isValid, "The testModel object should be invalid (in other words, testModel.isValid should be FALSE).");
    XCTAssertNil(testModel.customModel, "The custom model (testModel.customModel) should be nil.");

}

- (void)testInitTestModelWithJSONDictMissingParams {

    // When:
    BNTestModel *testModel = [BNTestModel missingParamsMockObject];

    // Then:
    XCTAssertNotNil(testModel, "The testModel variable should not contain nil.");
    XCTAssertTrue([testModel isKindOfClass:[BNTestModel class]], "The class type of the testModel variable should be BNTestModel.");
    XCTAssertEqualObjects(testModel.modelId, @"ID0", "The model id (testModel.modelId) should be ID0.");
    XCTAssertEqual(testModel.totalAmount, 100, "The total amount (testModel.totalAmount) should be 100.");
    XCTAssertFalse(testModel.isValid, "The value of the testModel.isValid property should be FALSE.");
    XCTAssertTrue([testModel.customModel isKindOfClass:[BNTestModel class]], "The class type of the custom model (testModel.customModel) should be BNTestModel.");
}

- (void)testGenerateNSDictionaryWithJSONMappingFormat {

    // Given:
    BNTestModel *testModel = [BNTestModel correctMockObject];

    // When:
    NSDictionary *dictionaryFromClass = [BNTestModel correctJSONDictionary];
    NSDictionary *dictionaryFromObject = [testModel JSONDictionary];

    // Then:
    XCTAssertEqualObjects(dictionaryFromClass, dictionaryFromObject, "The dictionary from the BNTestModel class (dictionaryFromClass) should be equal to the dictionary from the testModel object (dictionaryFromObject).");
}

- (void)testThatTwoTestModelObjectsAreEqual {

    // When:
    BNTestModel *testModel = [BNTestModel correctMockObject];
    BNTestModel *anotherTestModel = [BNTestModel correctMockObject];

    // Then:
    XCTAssertEqualObjects(testModel, anotherTestModel, "The objects testModel and anotherTestModel should be equal (they should differ in name only).");
}

- (void)testCopyTestModel {

    // Given:
    BNTestModel *testModel = [BNTestModel correctMockObject];

    // When:
    BNTestModel *copyOfTestModel = [testModel copy];

    // Then:
    XCTAssertEqualObjects(testModel, copyOfTestModel, "The original test model (testModel) should be equal to its copy (copyOfTestModel). They should differ in name only.");
}

- (void)testSerialization {
    
    // Given:
    BNCacheManager *sharedCache = [BNCacheManager sharedCache];
    BNTestModel *testModel = [BNTestModel correctMockObject];
    
    // When:
    [sharedCache saveObject:testModel withName:@"testObject"];
    BNTestModel *decodedObject = (BNTestModel *)[sharedCache getObjectWithName:@"testObject"];
    
    // Then:
    XCTAssertNotNil(decodedObject, "The decoded object (decodedObject) should not be nil.");
    XCTAssertEqualObjects(testModel, decodedObject, "The test model (testModel) should be equal to the decoded object (decodedObject). They should differ in name only.");

}

@end