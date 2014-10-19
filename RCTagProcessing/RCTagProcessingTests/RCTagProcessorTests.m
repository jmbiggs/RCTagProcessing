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

- (void)testAttributedStringForText {
    NSString *stringWithTags = @"<b>Bold</b> <sup>sup</sup> <sub>sub</sub> <u>Underline</u> <strike>strike</strike> <i>Italic</i> <small>small</small> <b><u>Underline+Bold</u></b>";
    NSAttributedString *attributedString = [[RCTagProcessor defaultInstance] attributedStringForText:stringWithTags];
    NSMutableAttributedString *expectedResult = [[NSMutableAttributedString alloc] initWithString:@"Bold sup sub Underline strike Italic small Underline+Bold"];
    //bold
    [expectedResult addAttribute:NSFontAttributeName value:[[RCTagProcessor defaultInstance] boldFont] range:NSMakeRange(0, 4)];
    //superscript
    [expectedResult addAttribute:NSFontAttributeName value:[[RCTagProcessor defaultInstance] smallFont] range:NSMakeRange(5, 3)];
    [expectedResult addAttribute:NSBaselineOffsetAttributeName value:[NSNumber numberWithFloat:rc_defaultSuperscriptOffsetFactor * [[RCTagProcessor defaultInstance] regularFont].pointSize] range:NSMakeRange(5, 3)];
    //subscript
    [expectedResult addAttribute:NSFontAttributeName value:[[RCTagProcessor defaultInstance] smallFont] range:NSMakeRange(9, 3)];
    [expectedResult addAttribute:NSBaselineOffsetAttributeName value:[NSNumber numberWithFloat:-rc_defaultSubscriptOffsetFactor * [[RCTagProcessor defaultInstance] regularFont].pointSize] range:NSMakeRange(9, 3)];
    //underline
    [expectedResult addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:1] range:NSMakeRange(13, 9)];
    //strikethrough
    [expectedResult addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInt:1] range:NSMakeRange(23, 6)];
    //italic
    [expectedResult addAttribute:NSObliquenessAttributeName value:[NSNumber numberWithFloat:rc_defaultObliquenessOffsetFactor] range:NSMakeRange(30, 6)];
    //small
    [expectedResult addAttribute:NSFontAttributeName value:[[RCTagProcessor defaultInstance] smallFont] range:NSMakeRange(37, 5)];
    //underline+bold
    [expectedResult addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:1] range:NSMakeRange(43, 14)];
    [expectedResult addAttribute:NSFontAttributeName value:[[RCTagProcessor defaultInstance] boldFont] range:NSMakeRange(43, 14)];
    
    XCTAssertTrue([attributedString isEqualToAttributedString:expectedResult]);

    //Test closing opened tags
    stringWithTags = @"<b>Bold</b> <sup>sup</sup> <sub>sub</sub> <u>Underline</u> <strike>strike</strike> <i>Italic</i> <small>small</small> <b><u>Underline+Bold";
    attributedString = [[RCTagProcessor defaultInstance] attributedStringForText:stringWithTags];
    XCTAssertTrue([attributedString isEqualToAttributedString:expectedResult]);
}

- (void)testAttributedStringForText_withParameters {
    NSString *stringWithTags = @"<b>Bold</b> <sup>sup</sup> <sub>sub</sub> <u>Underline</u> <strike>strike</strike> <i>Italic</i> <small>small</small> <b><u>Underline+Bold</u></b>";
    UIFont *smallFont = [UIFont systemFontOfSize:10];
    UIFont *regularFont = [UIFont systemFontOfSize:15];
    UIFont *boldFont = [UIFont boldSystemFontOfSize:15];
    NSAttributedString *attributedString = [[RCTagProcessor defaultInstance] attributedStringForText:stringWithTags withRegularFont:regularFont boldFont:boldFont andSmallFont:smallFont];
    NSMutableAttributedString *expectedResult = [[NSMutableAttributedString alloc] initWithString:@"Bold sup sub Underline strike Italic small Underline+Bold"];
    //bold
    [expectedResult addAttribute:NSFontAttributeName value:boldFont range:NSMakeRange(0, 4)];
    //superscript
    [expectedResult addAttribute:NSFontAttributeName value:smallFont range:NSMakeRange(5, 3)];
    [expectedResult addAttribute:NSBaselineOffsetAttributeName value:[NSNumber numberWithFloat:rc_defaultSuperscriptOffsetFactor * regularFont.pointSize] range:NSMakeRange(5, 3)];
    //subscript
    [expectedResult addAttribute:NSFontAttributeName value:smallFont range:NSMakeRange(9, 3)];
    [expectedResult addAttribute:NSBaselineOffsetAttributeName value:[NSNumber numberWithFloat:-rc_defaultSubscriptOffsetFactor * regularFont.pointSize] range:NSMakeRange(9, 3)];
    //underline
    [expectedResult addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:1] range:NSMakeRange(13, 9)];
    //strikethrough
    [expectedResult addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInt:1] range:NSMakeRange(23, 6)];
    //italic
    [expectedResult addAttribute:NSObliquenessAttributeName value:[NSNumber numberWithFloat:rc_defaultObliquenessOffsetFactor] range:NSMakeRange(30, 6)];
    //small
    [expectedResult addAttribute:NSFontAttributeName value:smallFont range:NSMakeRange(37, 5)];
    //underline+bold
    [expectedResult addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:1] range:NSMakeRange(43, 14)];
    [expectedResult addAttribute:NSFontAttributeName value:boldFont range:NSMakeRange(43, 14)];
    
    XCTAssertTrue([attributedString isEqualToAttributedString:expectedResult]);
    
    //Test closing opened tags
    stringWithTags = @"<b>Bold</b> <sup>sup</sup> <sub>sub</sub> <u>Underline</u> <strike>strike</strike> <i>Italic</i> <small>small</small> <b><u>Underline+Bold";
    attributedString = [[RCTagProcessor defaultInstance] attributedStringForText:stringWithTags withRegularFont:regularFont boldFont:boldFont andSmallFont:smallFont];
    XCTAssertTrue([attributedString isEqualToAttributedString:expectedResult]);
}

- (void)testPerformance_attributedStringForText {
    
    NSMutableString *stringWithTags = [@"" mutableCopy];
    for (int i = 0; i < 100; i++) {
        [stringWithTags appendFormat:@"<b>asdf</b>"];
    }
    UIFont *smallFont = [UIFont systemFontOfSize:10];
    UIFont *regularFont = [UIFont systemFontOfSize:15];
    UIFont *boldFont = [UIFont boldSystemFontOfSize:15];
    
    [self measureBlock:^{
        for (int i = 0; i < 10; i++) {
            NSAttributedString *attributedString = [[RCTagProcessor defaultInstance] attributedStringForText:stringWithTags withRegularFont:regularFont boldFont:boldFont andSmallFont:smallFont];
            attributedString = nil;
        }
    }];
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
