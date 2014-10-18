//
//  HTMLTag.m
//  RCTagProcessing
//
//  Created by Radu Ciobanu on 18/10/2014.
//  Copyright (c) 2014 Radu Ciobanu. All rights reserved.
//

#import "HTMLTag.h"
#import "RCTagProcessor.h"

@interface HTMLTag ()

@property (nonatomic, strong, readwrite) NSMutableArray *attributeNames;
@property (nonatomic, strong, readwrite) NSMutableArray *attributeValues;

@end

@implementation HTMLTag

- (instancetype)initFromString:(NSString *)stringContainingTag {
    self = [super init];
    if (self) {
        //TODO: add support for parametrized tags (e.g. <font color=red>)
        //TODO: add support for self-closed tags (e.g. </br>)
        _value = [stringContainingTag substringWithRange:NSMakeRange(1, stringContainingTag.length - 2)];
        [self setUpAttributeNameAndValue];
    }
    return self;
}

- (NSString *)startTag {
    return [NSString stringWithFormat:@"<%@>", self.value];
}


- (NSString *)endTag {
    return [NSString stringWithFormat:@"</%@>", self.value];
}

- (NSRange)range {
    NSUInteger length = self.endLocation - self.startLocation;
    NSRange range = NSMakeRange(self.startLocation, length);
    return range;
}

- (void)setRegularFont:(UIFont *)regularFont {
    _regularFont = regularFont;
    [self setUpAttributeNameAndValue];
}

- (void)setBoldFont:(UIFont *)boldFont {
    _boldFont = boldFont;
    [self setUpAttributeNameAndValue];
}

- (void)setUpAttributeNameAndValue {
    _attributeNames = [NSMutableArray new];
    _attributeValues = [NSMutableArray new];
    if ([self.value isEqualToString:@"b"]) {
        [_attributeNames addObject:NSFontAttributeName];
        if (!_boldFont) {
            [_attributeValues addObject:[RCTagProcessor kBoldFont]];
        } else {
            [_attributeValues addObject:_boldFont];
        }
    } else if ([self.value isEqualToString:@"sup"]) {
        [_attributeNames addObject:NSBaselineOffsetAttributeName];
        if (!_regularFont) {
            [_attributeValues addObject:[NSNumber numberWithFloat:[RCTagProcessor kSupOffset]]];
        } else {
            [_attributeValues addObject:[NSNumber numberWithFloat:_regularFont.pointSize * 0.5]];
        }
        
        [_attributeNames addObject:NSFontAttributeName];
        if (!_regularFont) {
            [_attributeValues addObject:[RCTagProcessor kSmallFont]];
        } else {
            [_attributeValues addObject:[UIFont fontWithName:_regularFont.fontName size:_regularFont.pointSize * 0.75]];
        }
    } else if ([self.value isEqualToString:@"sub"]) {
        [_attributeNames addObject:NSBaselineOffsetAttributeName];
        if (!_regularFont) {
            [_attributeValues addObject:[NSNumber numberWithFloat:[RCTagProcessor kSubOffset]]];
        } else {
            [_attributeValues addObject:[NSNumber numberWithFloat:_regularFont.pointSize * (-0.25)]];
        }
        
        [_attributeNames addObject:NSFontAttributeName];
        if (!_regularFont) {
            [_attributeValues addObject:[RCTagProcessor kSmallFont]];
        } else {
            [_attributeValues addObject:[UIFont fontWithName:_regularFont.fontName size:_regularFont.pointSize * 0.75]];
        }
    } else if ([self.value isEqualToString:@"u"]) {
        [_attributeNames addObject:NSUnderlineStyleAttributeName];
        [_attributeValues addObject:[NSNumber numberWithInt:NSUnderlineStyleSingle]];
    } else if ([self.value isEqualToString:@"strike"]) {
        [_attributeNames addObject:NSStrikethroughStyleAttributeName];
        [_attributeValues addObject:[NSNumber numberWithInt:1]];
    } else if ([self.value isEqualToString:@"i"]) {
        [_attributeNames addObject:NSObliquenessAttributeName];
        [_attributeValues addObject:[NSNumber numberWithFloat:0.33]];
    }
}

@end
