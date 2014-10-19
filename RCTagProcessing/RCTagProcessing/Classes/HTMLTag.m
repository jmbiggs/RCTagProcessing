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

@property (nonatomic, strong, readwrite) NSString *value;
@property (nonatomic, strong, readwrite) NSMutableArray *attributeNames;
@property (nonatomic, strong, readwrite) NSMutableArray *attributeValues;
@property (nonatomic, assign) BOOL namesAndValuesObsoleted;

@end

@implementation HTMLTag

const CGFloat rc_defaultSuperscriptOffsetFactor = 0.5;
const CGFloat rc_defaultSubscriptOffsetFactor = 0.25;
const CGFloat rc_defaultObliquenessOffsetFactor = 0.33;

- (instancetype)initFromString:(NSString *)stringContainingTag {
    self = [super init];
    if (self) {
        //TODO: add support for parametrized tags (e.g. <font color=red>)
        //TODO: add support for self-closed tags (e.g. </br>)
        //too expensive to validate by regex
        if (stringContainingTag.length < 3) {
            [NSException raise:@"Invalid tag string" format:@"A valid tag must be at least 3 caracters long"];
        }
        if ([[stringContainingTag substringWithRange:NSMakeRange(1, 1)] isEqualToString:@"/"]) {
            //closing tag, probably
            if (stringContainingTag.length < 4) {
                [NSException raise:@"Invalid tag string" format:@"A valid closing must be at least 4 caracters long"];
            }
            _value = [stringContainingTag substringWithRange:NSMakeRange(2, stringContainingTag.length - 3)];
        } else {
            _value = [stringContainingTag substringWithRange:NSMakeRange(1, stringContainingTag.length - 2)];
        }
        _superscriptOffsetFactor = rc_defaultSuperscriptOffsetFactor;
        _subscriptOffsetFactor = rc_defaultSubscriptOffsetFactor;
        _obliquenessFactor = rc_defaultObliquenessOffsetFactor;
        _namesAndValuesObsoleted = YES;
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

- (NSMutableArray *)attributeValues {
    if (!self.namesAndValuesObsoleted) {
        return _attributeValues;
    } else {
        [self setUpAttributeNamesAndValues];
        return _attributeValues;
    }
}

- (NSMutableArray *)attributeNames {
    if (!self.namesAndValuesObsoleted) {
        return _attributeNames;
    } else {
        [self setUpAttributeNamesAndValues];
        return _attributeNames;
    }
}

- (void)setSuperscriptOffsetFactor:(CGFloat)superscriptOffsetFactor {
    _superscriptOffsetFactor = superscriptOffsetFactor;
    _namesAndValuesObsoleted = YES;
}

- (void)setSubscriptOffsetFactor:(CGFloat)subscriptOffsetFactor {
    _subscriptOffsetFactor = subscriptOffsetFactor;
    _namesAndValuesObsoleted = YES;
}

- (void)setObliquenessFactor:(CGFloat)obliquenessFactor {
    _obliquenessFactor = obliquenessFactor;
    _namesAndValuesObsoleted = YES;
}

- (void)setRegularFont:(UIFont *)regularFont {
    _regularFont = regularFont;
    _namesAndValuesObsoleted = YES;
}

- (void)setBoldFont:(UIFont *)boldFont {
    _boldFont = boldFont;
    _namesAndValuesObsoleted = YES;
}

- (void)setSmallFont:(UIFont *)smallFont {
    _smallFont = smallFont;
    _namesAndValuesObsoleted = YES;
}

- (void)setUpAttributeNamesAndValues {
    _attributeNames = [NSMutableArray new];
    _attributeValues = [NSMutableArray new];
    
    _namesAndValuesObsoleted = NO;
    
    if ([self.value isEqualToString:@"b"]) {
        if (_boldFont) {
            [_attributeNames addObject:NSFontAttributeName];
            [_attributeValues addObject:_boldFont];
        }
    } else if ([self.value isEqualToString:@"sup"]) {
        if (_regularFont) {
            [_attributeNames addObject:NSBaselineOffsetAttributeName];
            [_attributeValues addObject:[NSNumber numberWithFloat:_regularFont.pointSize * _superscriptOffsetFactor]];
        }
        
        if (_smallFont) {
            [_attributeNames addObject:NSFontAttributeName];
            [_attributeValues addObject:_smallFont];
        }
    } else if ([self.value isEqualToString:@"sub"]) {
        if (_regularFont) {
            [_attributeNames addObject:NSBaselineOffsetAttributeName];
            [_attributeValues addObject:[NSNumber numberWithFloat:_regularFont.pointSize * -_subscriptOffsetFactor]];
        }
        if (_smallFont) {
            [_attributeNames addObject:NSFontAttributeName];
            [_attributeValues addObject:_smallFont];
        }
    } else if ([self.value isEqualToString:@"u"]) {
        [_attributeNames addObject:NSUnderlineStyleAttributeName];
        [_attributeValues addObject:[NSNumber numberWithInt:NSUnderlineStyleSingle]];
    } else if ([self.value isEqualToString:@"strike"]) {
        [_attributeNames addObject:NSStrikethroughStyleAttributeName];
        [_attributeValues addObject:[NSNumber numberWithInt:1]];
    } else if ([self.value isEqualToString:@"i"]) {
        [_attributeNames addObject:NSObliquenessAttributeName];
        [_attributeValues addObject:[NSNumber numberWithFloat:_obliquenessFactor]];
    }
}

@end
