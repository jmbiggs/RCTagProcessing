//
//  RCTagProcessorTests.m
//  RCTagProcessing
//
//  Created by Radu Ciobanu on 19/10/2014.
//  Copyright (c) 2014 Radu Ciobanu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "RCTagProcessor.h"
#import "HTMLTag.h"

@interface RCTagProcessorTests : XCTestCase

@end

@implementation RCTagProcessorTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testRCTagProcessor {
    //some basic tests
    XCTAssertNotNil([RCTagProcessor defaultInstance]);
}

- (void)testRCTagProcessor_getTagsFromString_valid {
    NSArray *tagsArray = nil;
    HTMLTag *tag1 = nil;
    HTMLTag *tag2 = nil;
    
    XCTAssertEqualObjects([[RCTagProcessor defaultInstance] getTagsFromString:nil], @[]);
    XCTAssertEqualObjects([[RCTagProcessor defaultInstance] getTagsFromString:@""], @[]);
    XCTAssertEqualObjects([[RCTagProcessor defaultInstance] getTagsFromString:@"asdf"], @[]);
    
    tagsArray = [[RCTagProcessor defaultInstance] getTagsFromString:@"<testTag>aaa</testTag>"];
    XCTAssertEqual(1, tagsArray.count);
    tag1 = [tagsArray objectAtIndex:0];
    XCTAssertEqualObjects(tag1, [[HTMLTag alloc] initFromString:@"<testTag>"]);
    XCTAssertEqual(tag1.startLocation, 0);
    XCTAssertEqual(tag1.endLocation, 3);
    
    
    tagsArray = [[RCTagProcessor defaultInstance] getTagsFromString:@"<u>a</u><i>b</i>"];
    XCTAssertEqual(2, tagsArray.count);
    [tagsArray containsObject:tag1];
    tag1 = [tagsArray objectAtIndex:0];
    tag2 = [[HTMLTag alloc] initFromString:@"<u>"];
    tag2.startLocation = 0;
    tag2.endLocation = 1;
    XCTAssertTrue([tag1 isEqual:tag2 considerLocation:YES]);
    tag1 = [tagsArray objectAtIndex:1];
    tag2 = [[HTMLTag alloc] initFromString:@"<i>"];
    tag2.startLocation = 1;
    tag2.endLocation = 2;
    XCTAssertTrue([tag1 isEqual:tag2 considerLocation:YES]);

    
    tagsArray = [[RCTagProcessor defaultInstance] getTagsFromString:@"<u>a</u>0123456789<i>b</i>"];
    XCTAssertEqual(2, tagsArray.count);
    tag1 = [tagsArray objectAtIndex:0];
    tag2 = [[HTMLTag alloc] initFromString:@"<u>"];
    tag2.startLocation = 0;
    tag2.endLocation = 1;
    XCTAssertTrue([tag1 isEqual:tag2 considerLocation:YES]);
    tag1 = [tagsArray objectAtIndex:1];
    tag2 = [[HTMLTag alloc] initFromString:@"<i>"];
    tag2.startLocation = 11;
    tag2.endLocation = 12;
    XCTAssertTrue([tag1 isEqual:tag2 considerLocation:YES]);
    
    
    tagsArray = [[RCTagProcessor defaultInstance] getTagsFromString:@"<i><u>a</u></i>"];
    XCTAssertEqual(2, tagsArray.count);
    [tagsArray containsObject:tag1];
    tag1 = [tagsArray objectAtIndex:0];
    tag2 = [[HTMLTag alloc] initFromString:@"<i>"];
    tag2.startLocation = 0;
    tag2.endLocation = 1;
    XCTAssertTrue([tag1 isEqual:tag2 considerLocation:YES]);
    tag1 = [tagsArray objectAtIndex:1];
    tag2 = [[HTMLTag alloc] initFromString:@"<u>"];
    tag2.startLocation = 0;
    tag2.endLocation = 1;
    XCTAssertTrue([tag1 isEqual:tag2 considerLocation:YES]);
    
    
    tagsArray = [[RCTagProcessor defaultInstance] getTagsFromString:@"<i><u><b>a</b></u></i>"];
    XCTAssertEqual(3, tagsArray.count);
    [tagsArray containsObject:tag1];
    tag1 = [tagsArray objectAtIndex:0];
    tag2 = [[HTMLTag alloc] initFromString:@"<i>"];
    tag2.startLocation = 0;
    tag2.endLocation = 1;
    XCTAssertTrue([tag1 isEqual:tag2 considerLocation:YES]);
    tag1 = [tagsArray objectAtIndex:1];
    tag2 = [[HTMLTag alloc] initFromString:@"<u>"];
    tag2.startLocation = 0;
    tag2.endLocation = 1;
    XCTAssertTrue([tag1 isEqual:tag2 considerLocation:YES]);
    tag1 = [tagsArray objectAtIndex:2];
    tag2 = [[HTMLTag alloc] initFromString:@"<b>"];
    tag2.startLocation = 0;
    tag2.endLocation = 1;
    XCTAssertTrue([tag1 isEqual:tag2 considerLocation:YES]);
}

- (void)testRCTagProcessor_getTagsFromString_invalid {
    XCTAssertNil([[RCTagProcessor defaultInstance] getTagsFromString:@"asdf<a>asdf</b>"]);
    XCTAssertNil([[RCTagProcessor defaultInstance] getTagsFromString:@"asdf</a>asdf"]);
    XCTAssertNil([[RCTagProcessor defaultInstance] getTagsFromString:@"asdf<a><b></a></b>asdf"]);
    
    //Not supporting comments, quoting and other fancy stuff
    XCTAssertNil([[RCTagProcessor defaultInstance] getTagsFromString:@"asdf<a>\"</a>\"</a>"]);
    XCTAssertNil([[RCTagProcessor defaultInstance] getTagsFromString:@"asdf<a>'</a>'</a>"]);
}

- (void)testPerformance_parseSerialTags {
    NSMutableString *string = [@"" mutableCopy];
    for (int i = 0; i < 1000; i++) {
        [string appendFormat:@"<a%d>asdf</a%d>", i, i];
    }
    
    [self measureBlock:^{
        NSArray *tagArray = [[RCTagProcessor defaultInstance] getTagsFromString:string];
        tagArray = nil;
    }];
}

- (void)testPerformance_parseNestedTags {
    // This is an example of a performance test case.
    
    NSMutableString *string = [@"" mutableCopy];
    for (int i = 0; i < 1000; i++) {
        [string appendFormat:@"<a%d>asdf", i];
    }
    for (int i = 999; i >= 0; i--) {
        [string appendFormat:@"</a%d>", i];
    }
    
    [self measureBlock:^{
        NSArray *tagArray = [[RCTagProcessor defaultInstance] getTagsFromString:string];
        tagArray = nil;
    }];
}


@end
