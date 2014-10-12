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
@property (nonatomic, strong, readonly) NSString *startTag;
@property (nonatomic, strong, readonly) NSString *endTag;
@property (nonatomic, assign, readonly) NSRange range;
@property (nonatomic, strong, readonly) NSString *attributeName;
@property (nonatomic, strong, readonly) id attributeValue;

- (instancetype)initFromString:(NSString *)stringContainingTag;

@end

@implementation HTMLTag

- (instancetype)initFromString:(NSString *)stringContainingTag {
    self = [super init];
    if (self) {
        _value = [stringContainingTag substringWithRange:NSMakeRange(1, stringContainingTag.length - 2)];
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

- (NSString *)attributeName {
    if ([self.value isEqualToString:@"b"]) {
        return NSFontAttributeName;
    }
    if ([self.value isEqualToString:@"sup"]) {
        return NSBaselineOffsetAttributeName;
    }
    if ([self.value isEqualToString:@"u"]) {
        return NSUnderlineStyleAttributeName;
    }
    return nil;
}

- (id)attributeValue {
    if ([self.value isEqualToString:@"b"]) {
        return [RCTagProcessor kBoldFont];
    }
    if ([self.value isEqualToString:@"sup"]) {
        return [NSNumber numberWithFloat:10];
    }
    if ([self.value isEqualToString:@"u"]) {
        return [NSNumber numberWithInt:NSUnderlineStyleSingle];
    }
    return nil;
}

@end


@implementation RCTagProcessor

+ (NSAttributedString *)attributedStringForText:(NSString *)plainText {
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
        [attributedText addAttribute:[tag attributeName] value:[tag attributeValue] range:tag.range];
    }
    
    return attributedText;
}

+ (UIFont *)kBoldFont {
    static UIFont *boldFontConstant = nil;
    if (!boldFontConstant) {
        boldFontConstant = [UIFont boldSystemFontOfSize:42.42];
    }
    return boldFontConstant;
}

@end
