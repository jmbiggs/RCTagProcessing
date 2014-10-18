//
//  RCTagProcessingTests.m
//  RCTagProcessingTests
//
//  Created by Radu Ciobanu on 11/10/2014.
//  Copyright (c) 2014 Radu Ciobanu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "HTMLTag.h"

@interface RCTagProcessingTests : XCTestCase

@end

@implementation RCTagProcessingTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testHTMLTag {
    HTMLTag *tag = nil;
    
    XCTAssertThrows([[HTMLTag alloc] initFromString:nil regularFont:nil boldFont:nil smallFont:nil]);
    XCTAssertThrows([[HTMLTag alloc] initFromString:@"" regularFont:nil boldFont:nil smallFont:nil]);
    
    tag = [[HTMLTag alloc] initFromString:@"<unknownTag>" regularFont:[UIFont fontWithName:@"CourierNew" size:13] boldFont:[UIFont fontWithName:@"CourierNew-Bold" size:13] smallFont:[UIFont fontWithName:@"CourierNew" size:6]];
    
    XCTAssertEqualObjects(tag.value, @"unknownTag");
    XCTAssertEqual(tag.attributeNames.count, 0);
    XCTAssertEqual(tag.attributeNames.count, tag.attributeValues.count);
    XCTAssertEqualObjects(tag.startTag, @"<unknownTag>");
    XCTAssertEqualObjects(tag.endTag, @"</unknownTag>");

    
    //Test range
    XCTAssertEqual(tag.startLocation, 0);
    XCTAssertEqual(tag.endLocation, 0);
    XCTAssertTrue(NSEqualRanges(tag.range, NSMakeRange(0, 0)));
    tag.startLocation = 1;
    tag.endLocation = 1000;
    XCTAssertEqual(tag.startLocation, 1);
    XCTAssertEqual(tag.endLocation, 1000);
    XCTAssertTrue(NSEqualRanges(tag.range, NSMakeRange(1, 999)));

    XCTAssert(YES, @"Pass");
}

- (void)testHTMLTag_bold {
    
    UIFont *boldFont = [UIFont fontWithName:@"Courier-Bold" size:13];
    HTMLTag *tag = [[HTMLTag alloc] initFromString:@"<b>" regularFont:[UIFont fontWithName:@"Courier" size:13] boldFont:boldFont smallFont:[UIFont fontWithName:@"Courier" size:6]];
    
    XCTAssertEqualObjects(tag.value, @"b");
    XCTAssertEqual(tag.attributeNames.count, 1);
    XCTAssertEqual(tag.attributeNames.count, tag.attributeValues.count);
    XCTAssertEqualObjects(tag.startTag, @"<b>");
    XCTAssertEqualObjects(tag.endTag, @"</b>");
    XCTAssertEqualObjects([tag.attributeNames objectAtIndex:0], NSFontAttributeName);
    XCTAssertEqualObjects([tag.attributeValues objectAtIndex:0], boldFont);
}

- (void)testHTMLTag_underline {

    HTMLTag *tag = [[HTMLTag alloc] initFromString:@"<u>" regularFont:[UIFont fontWithName:@"Courier" size:13] boldFont:[UIFont fontWithName:@"Courier-Bold" size:13] smallFont:[UIFont fontWithName:@"Courier" size:6]];

    XCTAssertEqualObjects(tag.value, @"u");
    XCTAssertEqual(tag.attributeNames.count, 1);
    XCTAssertEqual(tag.attributeNames.count, tag.attributeValues.count);
    XCTAssertEqualObjects(tag.startTag, @"<u>");
    XCTAssertEqualObjects(tag.endTag, @"</u>");
    XCTAssertEqualObjects([tag.attributeNames objectAtIndex:0], NSUnderlineStyleAttributeName);
    XCTAssertEqualObjects([tag.attributeValues objectAtIndex:0], [NSNumber numberWithInt:1]);
}

- (void)testHTMLTag_italic {
    HTMLTag *tag = [[HTMLTag alloc] initFromString:@"<i>" regularFont:[UIFont fontWithName:@"Courier" size:13] boldFont:[UIFont fontWithName:@"Courier-Bold" size:13] smallFont:[UIFont fontWithName:@"Courier" size:6]];
    
    XCTAssertEqualObjects(tag.value, @"i");
    XCTAssertEqual(tag.attributeNames.count, 1);
    XCTAssertEqual(tag.attributeNames.count, tag.attributeValues.count);
    XCTAssertEqualObjects(tag.startTag, @"<i>");
    XCTAssertEqualObjects(tag.endTag, @"</i>");
    XCTAssertEqualObjects([tag.attributeNames objectAtIndex:0], NSObliquenessAttributeName);
    XCTAssertEqualObjects([tag.attributeValues objectAtIndex:0], [NSNumber numberWithFloat:0.33]);
}

- (void)testHTMLTag_superscript {
    
    UIFont *smallFont = [UIFont fontWithName:@"Courier" size:6];
    UIFont *regularFont = [UIFont fontWithName:@"Courier" size:13];
    HTMLTag *tag = [[HTMLTag alloc] initFromString:@"<sup>" regularFont:regularFont boldFont:[UIFont fontWithName:@"Courier-Bold" size:13] smallFont:smallFont];
    tag.superscriptOffsetFactor = 0.4;
    
    XCTAssertEqualObjects(tag.value, @"sup");
    XCTAssertEqual(tag.attributeNames.count, 2);
    XCTAssertEqual(tag.attributeNames.count, tag.attributeValues.count);
    XCTAssertEqualObjects(tag.startTag, @"<sup>");
    XCTAssertEqualObjects(tag.endTag, @"</sup>");
    XCTAssertEqualObjects([tag.attributeNames objectAtIndex:0], NSBaselineOffsetAttributeName);
    XCTAssertEqualObjects([tag.attributeValues objectAtIndex:0], [NSNumber numberWithFloat:regularFont.pointSize * 0.4]);
    XCTAssertEqualObjects([tag.attributeNames objectAtIndex:1], NSFontAttributeName);
    XCTAssertEqualObjects([tag.attributeValues objectAtIndex:1], smallFont);
}

- (void)testHTMLTag_subscript {
    UIFont *smallFont = [UIFont fontWithName:@"Courier" size:6];
    UIFont *regularFont = [UIFont fontWithName:@"Courier" size:13];
    HTMLTag *tag = [[HTMLTag alloc] initFromString:@"<sub>" regularFont:regularFont boldFont:[UIFont fontWithName:@"Courier-Bold" size:13] smallFont:smallFont];
    tag.subscriptOffsetFactor = 0.4;
    
    XCTAssertEqualObjects(tag.value, @"sub");
    XCTAssertEqual(tag.attributeNames.count, 2);
    XCTAssertEqual(tag.attributeNames.count, tag.attributeValues.count);
    XCTAssertEqualObjects(tag.startTag, @"<sub>");
    XCTAssertEqualObjects(tag.endTag, @"</sub>");
    XCTAssertEqualObjects([tag.attributeNames objectAtIndex:0], NSBaselineOffsetAttributeName);
    XCTAssertEqualObjects([tag.attributeValues objectAtIndex:0], [NSNumber numberWithFloat:-regularFont.pointSize * 0.4]);
    XCTAssertEqualObjects([tag.attributeNames objectAtIndex:1], NSFontAttributeName);
    XCTAssertEqualObjects([tag.attributeValues objectAtIndex:1], smallFont);
}

- (void)testHTMLTag_striketrhough {
    HTMLTag *tag = [[HTMLTag alloc] initFromString:@"<strike>" regularFont:[UIFont fontWithName:@"Courier" size:13] boldFont:[UIFont fontWithName:@"Courier-Bold" size:13] smallFont:[UIFont fontWithName:@"Courier" size:6]];
    
    XCTAssertEqualObjects(tag.value, @"strike");
    XCTAssertEqual(tag.attributeNames.count, 1);
    XCTAssertEqual(tag.attributeNames.count, tag.attributeValues.count);
    XCTAssertEqualObjects(tag.startTag, @"<strike>");
    XCTAssertEqualObjects(tag.endTag, @"</strike>");
    XCTAssertEqualObjects([tag.attributeNames objectAtIndex:0], NSStrikethroughStyleAttributeName);
    XCTAssertEqualObjects([tag.attributeValues objectAtIndex:0], [NSNumber numberWithInt:1]);
}

- (void)testHTMLTagPerformance {

    UIFont *smallFont = [UIFont fontWithName:@"Courier" size:6];
    UIFont *regularFont = [UIFont fontWithName:@"Courier" size:13];
    UIFont *boldFont = [UIFont fontWithName:@"Courier-Bold" size:13];
    NSString *string = @"<u>";
    
    //Baseline for 100000 allocations: 0.257s
    //on a 2011, 2.2 GHz Core i7 Macbook Pro
    [self measureBlock:^{
        for (int i = 0; i < 100000; i++) {
            HTMLTag *tag = [[HTMLTag alloc] initFromString:string regularFont:regularFont boldFont:boldFont smallFont:smallFont];
        }
    }];
}

@end
