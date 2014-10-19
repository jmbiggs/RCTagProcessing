//
//  RCTagProcessor.m
//  RCTagProcessing
//
//  Created by Radu Ciobanu on 11/10/2014.
//  Copyright (c) 2014 Radu Ciobanu. All rights reserved.
//

#import "RCTagProcessor.h"
#import "HTMLTag.h"

@implementation RCTagProcessor

+ (instancetype)defaultInstance {
    static RCTagProcessor *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[RCTagProcessor alloc] init];
    });
    
    return _sharedInstance;
}

- (NSAttributedString *)attributedStringForText:(NSString *)plainText {
    return [self attributedStringForText:plainText withRegularFont:nil boldFont:nil andSmallFont:nil];
}

- (NSAttributedString *)attributedStringForText:(NSString *)plainText withRegularFont:(UIFont *)regularFont boldFont:(UIFont *)boldFont andSmallFont:(UIFont *)smallFont {
    if (!plainText) {
        return nil;
    }
    
    if (!regularFont) {
        regularFont = [self regularFont];
    }
    
    if (!boldFont) {
        boldFont = [self boldFont];
    }
    
    if (!smallFont) {
        smallFont = [self smallFont];
    }

    NSArray *tagsArray = [self getTagsFromString:plainText];
    plainText = [self removeTagsFromString:plainText];
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:plainText];
    
    for (HTMLTag *tag in tagsArray) {
        tag.regularFont = regularFont;
        tag.boldFont = boldFont;
        tag.smallFont = smallFont;
        for (int i = 0; i < tag.attributeNames.count;i++) {
            [attributedText addAttribute:[tag.attributeNames objectAtIndex:i] value:[tag.attributeValues objectAtIndex:i] range:tag.range];
        }
    }
    
    return attributedText;
}

- (NSArray *)getTagsFromString:(NSString *)stringWithTags {
    NSError *error;
    NSString *regexMatchingStartOrEndTags = @"<\\/?[A-Z][A-Z0-9]*>";
    
    NSMutableArray *tagsArray = [@[] mutableCopy];
    NSMutableArray *tagsQueue = [@[] mutableCopy];
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexMatchingStartOrEndTags options:NSRegularExpressionCaseInsensitive error:&error];
    NSTextCheckingResult *match = nil;
    
    while ((match = [regex firstMatchInString:stringWithTags options:0 range:NSMakeRange(0, stringWithTags.length)])) {
        NSString *tagString = [stringWithTags substringWithRange:match.range];
        if (tagsQueue.count > 0) {
            HTMLTag *currentTag = tagsQueue.lastObject;
            if ([tagString isEqualToString:currentTag.endTag]) {
                currentTag.endLocation = match.range.location;
                [tagsQueue removeLastObject]; //pop from queue
                stringWithTags = [stringWithTags stringByReplacingCharactersInRange:match.range withString:@""];
                continue;
            }
        }

        HTMLTag *tag = [[HTMLTag alloc] initFromString:tagString];
        tag.startLocation = match.range.location;
        stringWithTags = [stringWithTags stringByReplacingCharactersInRange:match.range withString:@""];
        [tagsArray addObject:tag];
        [tagsQueue addObject:tag]; //push to queue
    }

    return tagsArray;
}

- (NSString *)removeTagsFromString:(NSString *)stringWithTags {
    NSError *error;
    NSString *regexMatchingStartOrEndTags = @"<\\/?[A-Z][A-Z0-9]*>";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexMatchingStartOrEndTags options:NSRegularExpressionCaseInsensitive error:&error];
    return [regex stringByReplacingMatchesInString:stringWithTags options:0 range:NSMakeRange(0, [stringWithTags length]) withTemplate:@""];
}

- (UIFont *)regularFont {
    static UIFont *regularFontConstant = nil;
    if (!regularFontConstant) {
        regularFontConstant = [UIFont systemFontOfSize:10.42];
    }
    return regularFontConstant;
}

- (UIFont *)boldFont {
    static UIFont *boldFontConstant = nil;
    if (!boldFontConstant) {
        boldFontConstant = [UIFont boldSystemFontOfSize:10.42];
    }
    return boldFontConstant;
}

- (UIFont *)smallFont {
    static UIFont *smallFontConstant = nil;
    if (!smallFontConstant) {
        smallFontConstant = [UIFont systemFontOfSize:5.42];
    }
    return smallFontConstant;
}

@end
