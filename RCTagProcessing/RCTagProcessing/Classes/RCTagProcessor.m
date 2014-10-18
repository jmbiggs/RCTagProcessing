//
//  RCTagProcessor.m
//  RCTagProcessing
//
//  Created by Radu Ciobanu on 11/10/2014.
//  Copyright (c) 2014 Radu Ciobanu. All rights reserved.
//

#import "RCTagProcessor.h"

@interface HTMLTag : NSObject

@property (nonatomic, assign) NSUInteger startLocation;
@property (nonatomic, assign) NSUInteger endLocation;
@property (nonatomic, strong) NSString *value;
@property (nonatomic, strong) UIFont *regularFont;
@property (nonatomic, strong) UIFont *boldFont;
@property (nonatomic, strong, readonly) NSString *startTag;
@property (nonatomic, strong, readonly) NSString *endTag;
@property (nonatomic, assign, readonly) NSRange range;
@property (nonatomic, strong, readonly) NSMutableArray *attributeNames;
@property (nonatomic, strong, readonly) NSMutableArray *attributeValues;

- (instancetype)initFromString:(NSString *)stringContainingTag;

@end

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


@implementation RCTagProcessor

+ (NSAttributedString *)attributedStringForText:(NSString *)plainText {
    return [self attributedStringForText:plainText withRegularFont:nil andBoldFont:nil];
}

+ (NSAttributedString *)attributedStringForText:(NSString *)plainText withRegularFont:(UIFont *)regularFont andBoldFont:(UIFont *)boldFont {
    if (!plainText) {
        return nil;
    }
    
    NSError *error;
    NSString *regexMatchingStartTags = @"<[A-Z][A-Z0-9]*>";
    
    NSMutableArray *tagsArray = [@[] mutableCopy];
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexMatchingStartTags options:NSRegularExpressionCaseInsensitive error:&error];
    NSTextCheckingResult *match = nil;
    
    while ((match = [regex firstMatchInString:plainText options:0 range:NSMakeRange(0, plainText.length)])) {
        HTMLTag *tag = [[HTMLTag alloc] initFromString:[plainText substringWithRange:match.range]];
        tag.regularFont = regularFont;
        tag.boldFont = boldFont;
        tag.startLocation = match.range.location;
        
        plainText = [plainText stringByReplacingCharactersInRange:match.range withString:@""];
        
        NSRange range = [plainText rangeOfString:tag.endTag];
        if (range.location != NSNotFound) {
            tag.endLocation = range.location;
            plainText = [plainText stringByReplacingCharactersInRange:range withString:@""];
        }
        [tagsArray addObject:tag];
    }
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:plainText];

    for (HTMLTag *tag in tagsArray) {
        for (int i = 0; i < tag.attributeNames.count;i++) {
            [attributedText addAttribute:[tag.attributeNames objectAtIndex:i] value:[tag.attributeValues objectAtIndex:i] range:tag.range];
        }
    }
    
    return attributedText;
}

+ (UIFont *)kBoldFont {
    static UIFont *boldFontConstant = nil;
    if (!boldFontConstant) {
        boldFontConstant = [UIFont boldSystemFontOfSize:10.42];
    }
    return boldFontConstant;
}

+ (UIFont *)kSmallFont {
    static UIFont *smallFontConstant = nil;
    if (!smallFontConstant) {
        smallFontConstant = [UIFont boldSystemFontOfSize:5.42];
    }
    return smallFontConstant;
}


+ (CGFloat)kSupOffset {
    return 10.42;
}

+ (CGFloat)kSubOffset {
    return -[self kSupOffset]/2;
}

@end
