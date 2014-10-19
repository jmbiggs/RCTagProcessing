//
//  HTMLTagTests.m
//  HTMLTagTests
//
//  Created by Radu Ciobanu on 11/10/2014.
//  Copyright (c) 2014 Radu Ciobanu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "HTMLTag.h"

@interface HTMLTagTests : XCTestCase

@property (nonatomic, strong) UIFont *regularFont;
@property (nonatomic, strong) UIFont *boldFont;
@property (nonatomic, strong) UIFont *smallFont;

@end

@implementation HTMLTagTests

- (void)setUp {
    [super setUp];
    
    self.regularFont = [UIFont fontWithName:@"Courier" size:13];
    self.boldFont = [UIFont fontWithName:@"Courier-Bold" size:13];
    self.smallFont = [UIFont fontWithName:@"Courier" size:6];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testHTMLTag {
    HTMLTag *tag = nil;
    
    //Basic invalid tag tests
    XCTAssertThrows([[HTMLTag alloc] initFromString:nil]);
    XCTAssertThrows([[HTMLTag alloc] initFromString:@""]);
    XCTAssertThrows([[HTMLTag alloc] initFromString:@"<>"]);
    XCTAssertThrows([[HTMLTag alloc] initFromString:@"</>"]);
    
    tag = [[HTMLTag alloc] initFromString:@"<unknownTag>"];
    
    XCTAssertEqualObjects(tag.value, @"unknownTag");
    XCTAssertEqual(tag.attributeNames.count, 0);
    XCTAssertEqual(tag.attributeNames.count, tag.attributeValues.count);
    XCTAssertEqualObjects(tag.startTag, @"<unknownTag>");
    XCTAssertEqualObjects(tag.endTag, @"</unknownTag>");
    XCTAssertEqual(tag.superscriptOffsetFactor, rc_defaultSuperscriptOffsetFactor);
    XCTAssertEqual(tag.subscriptOffsetFactor, rc_defaultSubscriptOffsetFactor);
    XCTAssertEqual(tag.obliquenessFactor, rc_defaultObliquenessOffsetFactor);
    
    //Test range
    XCTAssertEqual(tag.startLocation, 0);
    XCTAssertEqual(tag.endLocation, 0);
    XCTAssertTrue(NSEqualRanges(tag.range, NSMakeRange(0, 0)));
    tag.startLocation = 1;
    tag.endLocation = 1000;
    XCTAssertEqual(tag.startLocation, 1);
    XCTAssertEqual(tag.endLocation, 1000);
    XCTAssertTrue(NSEqualRanges(tag.range, NSMakeRange(1, 999)));

    //Test closing tag
    tag = [[HTMLTag alloc] initFromString:@"</unknownTag>"];
    XCTAssertEqualObjects(tag.value, @"unknownTag");
}

- (void)testHTMLTag_bold {
    
    HTMLTag *tag = [[HTMLTag alloc] initFromString:@"<b>"];
    tag.regularFont = self.regularFont;
    tag.boldFont = self.boldFont;
    tag.smallFont = self.smallFont;
    
    XCTAssertEqualObjects(tag.value, @"b");
    XCTAssertEqual(tag.attributeNames.count, 1);
    XCTAssertEqual(tag.attributeNames.count, tag.attributeValues.count);
    XCTAssertEqualObjects(tag.startTag, @"<b>");
    XCTAssertEqualObjects(tag.endTag, @"</b>");
    XCTAssertEqualObjects([tag.attributeNames objectAtIndex:0], NSFontAttributeName);
    XCTAssertEqualObjects([tag.attributeValues objectAtIndex:0], self.boldFont);
}

- (void)testHTMLTag_underline {

    HTMLTag *tag = [[HTMLTag alloc] initFromString:@"<u>"];
    tag.regularFont = self.regularFont;
    tag.boldFont = self.boldFont;
    tag.smallFont = self.smallFont;

    XCTAssertEqualObjects(tag.value, @"u");
    XCTAssertEqual(tag.attributeNames.count, 1);
    XCTAssertEqual(tag.attributeNames.count, tag.attributeValues.count);
    XCTAssertEqualObjects(tag.startTag, @"<u>");
    XCTAssertEqualObjects(tag.endTag, @"</u>");
    XCTAssertEqualObjects([tag.attributeNames objectAtIndex:0], NSUnderlineStyleAttributeName);
    XCTAssertEqualObjects([tag.attributeValues objectAtIndex:0], [NSNumber numberWithInt:1]);
}

- (void)testHTMLTag_italic {
    HTMLTag *tag = [[HTMLTag alloc] initFromString:@"<i>"];
    tag.regularFont = self.regularFont;
    tag.boldFont = self.boldFont;
    tag.smallFont = self.smallFont;
    
    XCTAssertEqualObjects(tag.value, @"i");
    XCTAssertEqual(tag.attributeNames.count, 1);
    XCTAssertEqual(tag.attributeNames.count, tag.attributeValues.count);
    XCTAssertEqualObjects(tag.startTag, @"<i>");
    XCTAssertEqualObjects(tag.endTag, @"</i>");
    XCTAssertEqualObjects([tag.attributeNames objectAtIndex:0], NSObliquenessAttributeName);
    XCTAssertEqualObjects([tag.attributeValues objectAtIndex:0], [NSNumber numberWithFloat:0.33]);
}

- (void)testHTMLTag_superscript {
    HTMLTag *tag = [[HTMLTag alloc] initFromString:@"<sup>"];
    tag.regularFont = self.regularFont;
    tag.boldFont = self.boldFont;
    tag.smallFont = self.smallFont;
    tag.superscriptOffsetFactor = 0.4;
    
    XCTAssertEqualObjects(tag.value, @"sup");
    XCTAssertEqual(tag.attributeNames.count, 2);
    XCTAssertEqual(tag.attributeNames.count, tag.attributeValues.count);
    XCTAssertEqualObjects(tag.startTag, @"<sup>");
    XCTAssertEqualObjects(tag.endTag, @"</sup>");
    XCTAssertEqualObjects([tag.attributeNames objectAtIndex:0], NSBaselineOffsetAttributeName);
    XCTAssertEqualObjects([tag.attributeValues objectAtIndex:0], [NSNumber numberWithFloat:self.regularFont.pointSize * 0.4]);
    XCTAssertEqualObjects([tag.attributeNames objectAtIndex:1], NSFontAttributeName);
    XCTAssertEqualObjects([tag.attributeValues objectAtIndex:1], self.smallFont);
}

- (void)testHTMLTag_subscript {
    HTMLTag *tag = [[HTMLTag alloc] initFromString:@"<sub>"];
    tag.regularFont = self.regularFont;
    tag.boldFont = self.boldFont;
    tag.smallFont = self.smallFont;
    
    tag.subscriptOffsetFactor = 0.4;
    
    XCTAssertEqualObjects(tag.value, @"sub");
    XCTAssertEqual(tag.attributeNames.count, 2);
    XCTAssertEqual(tag.attributeNames.count, tag.attributeValues.count);
    XCTAssertEqualObjects(tag.startTag, @"<sub>");
    XCTAssertEqualObjects(tag.endTag, @"</sub>");
    XCTAssertEqualObjects([tag.attributeNames objectAtIndex:0], NSBaselineOffsetAttributeName);
    XCTAssertEqualObjects([tag.attributeValues objectAtIndex:0], [NSNumber numberWithFloat:-self.regularFont.pointSize * 0.4]);
    XCTAssertEqualObjects([tag.attributeNames objectAtIndex:1], NSFontAttributeName);
    XCTAssertEqualObjects([tag.attributeValues objectAtIndex:1], self.smallFont);
}

- (void)testHTMLTag_striketrhough {
    HTMLTag *tag = [[HTMLTag alloc] initFromString:@"<strike>"];
    
    XCTAssertEqualObjects(tag.value, @"strike");
    XCTAssertEqual(tag.attributeNames.count, 1);
    XCTAssertEqual(tag.attributeNames.count, tag.attributeValues.count);
    XCTAssertEqualObjects(tag.startTag, @"<strike>");
    XCTAssertEqualObjects(tag.endTag, @"</strike>");
    XCTAssertEqualObjects([tag.attributeNames objectAtIndex:0], NSStrikethroughStyleAttributeName);
    XCTAssertEqualObjects([tag.attributeValues objectAtIndex:0], [NSNumber numberWithInt:1]);
}

- (void)testHTMLTag_isEqual {
    HTMLTag *tag1 = [[HTMLTag alloc] initFromString:@"<strike>"];
    HTMLTag *tag2 = [[HTMLTag alloc] initFromString:@"<small>"];
    XCTAssertNotEqualObjects(tag1, tag2);
    tag2 = [[HTMLTag alloc] initFromString:@"</strike>"];
    XCTAssertEqualObjects(tag1, tag2);
    tag2 = [[HTMLTag alloc] initFromString:@"<strike>"];
    XCTAssertEqualObjects(tag1, tag2);
    tag1.regularFont = self.regularFont;
    XCTAssertNotEqualObjects(tag1, tag2);
    tag2.regularFont = self.regularFont;
    XCTAssertEqualObjects(tag1, tag2);
    tag1.boldFont = self.boldFont;
    XCTAssertNotEqualObjects(tag1, tag2);
    tag2.boldFont = self.boldFont;
    XCTAssertEqualObjects(tag1, tag2);
    tag1.smallFont = self.smallFont;
    XCTAssertNotEqualObjects(tag1, tag2);
    tag2.smallFont = self.smallFont;
    XCTAssertEqualObjects(tag1, tag2);
    tag1.superscriptOffsetFactor = rc_defaultSuperscriptOffsetFactor + 1.0;
    XCTAssertNotEqualObjects(tag1, tag2);
    tag2.superscriptOffsetFactor = rc_defaultSuperscriptOffsetFactor + 1.0;
    XCTAssertEqualObjects(tag1, tag2);
    tag1.subscriptOffsetFactor = rc_defaultSubscriptOffsetFactor + 1.0;
    XCTAssertNotEqualObjects(tag1, tag2);
    tag2.subscriptOffsetFactor = rc_defaultSubscriptOffsetFactor + 1.0;
    XCTAssertEqualObjects(tag1, tag2);
    tag1.obliquenessFactor = rc_defaultObliquenessOffsetFactor + 1.0;
    XCTAssertNotEqualObjects(tag1, tag2);
    tag2.obliquenessFactor = rc_defaultObliquenessOffsetFactor + 1.0;
    XCTAssertEqualObjects(tag1, tag2);

    //test that start/end locations aren't considered
    tag1.startLocation = 1;
    tag1.endLocation = 1;
    tag2.startLocation = 2;
    tag2.endLocation = 2;
    XCTAssertEqualObjects(tag1, tag2);
}

- (void)testHTMLTag_performance {
    NSString *string = @"<u>";
    
    //Baseline for 100k allocations: 0.257s
    //on a 2011, 2.2 GHz Core i7 Macbook Pro
    [self measureBlock:^{
        //reducing allocations to 10000 to shorten the test
        for (int i = 0; i < 10000; i++) {
            HTMLTag *tag = [[HTMLTag alloc] initFromString:string];
            tag = nil; //disable 'unused variable' warning
        }
    }];
    

}

- (void)testHTMLTag_parsingPerformance {
    UIFont *smallFont = [UIFont fontWithName:@"Courier" size:6];
    UIFont *regularFont = [UIFont fontWithName:@"Courier" size:13];
    UIFont *boldFont = [UIFont fontWithName:@"Courier-Bold" size:13];
    NSString *string = @"<u>";
    
    [self measureBlock:^{
        for (int i = 0; i < 10000; i++) {
            HTMLTag *tag = [[HTMLTag alloc] initFromString:string];
            tag.regularFont = regularFont;
            tag.boldFont = boldFont;
            tag.smallFont = smallFont;
            
            NSArray *array = tag.attributeNames;
            array = tag.attributeNames;
        }
    }];
}
@end
