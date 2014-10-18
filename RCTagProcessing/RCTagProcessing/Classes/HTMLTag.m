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

- (instancetype)initFromString:(NSString *)stringContainingTag regularFont:(UIFont *)regularFont boldFont:(UIFont *)boldFont smallFont:(UIFont *)smallFont {
    self = [super init];
    if (self) {
        //TODO: add support for parametrized tags (e.g. <font color=red>)
        //TODO: add support for self-closed tags (e.g. </br>)
        _value = [stringContainingTag substringWithRange:NSMakeRange(1, stringContainingTag.length - 2)];
        [self setUpAttributeNameAndValueWithRegularFont:regularFont boldFont:boldFont smallFont:smallFont];
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

- (void)setUpAttributeNameAndValueWithRegularFont:(UIFont *)regularFont boldFont:(UIFont *)boldFont smallFont:(UIFont *)smallFont {
    _attributeNames = [NSMutableArray new];
    _attributeValues = [NSMutableArray new];
    if ([self.value isEqualToString:@"b"]) {
        if (boldFont) {
            [_attributeNames addObject:NSFontAttributeName];
            [_attributeValues addObject:boldFont];
        }
    } else if ([self.value isEqualToString:@"sup"]) {
        if (regularFont) {
            [_attributeNames addObject:NSBaselineOffsetAttributeName];
            [_attributeValues addObject:[NSNumber numberWithFloat:regularFont.pointSize * 0.5]];
        }
        
        if (smallFont) {
            [_attributeNames addObject:NSFontAttributeName];
            [_attributeValues addObject:smallFont];
        }
    } else if ([self.value isEqualToString:@"sub"]) {
        if (regularFont) {
            [_attributeNames addObject:NSBaselineOffsetAttributeName];
            [_attributeValues addObject:[NSNumber numberWithFloat:regularFont.pointSize * (-0.25)]];
        }
        if (smallFont) {
            [_attributeNames addObject:NSFontAttributeName];
            [_attributeValues addObject:smallFont];
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
