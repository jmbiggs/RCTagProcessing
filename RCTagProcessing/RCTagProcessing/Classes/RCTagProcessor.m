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

+ (NSAttributedString *)attributedStringForText:(NSString *)plainText {
    return [self attributedStringForText:plainText withRegularFont:nil boldFont:nil andSmallFont:nil];
}

+ (NSAttributedString *)attributedStringForText:(NSString *)plainText withRegularFont:(UIFont *)regularFont boldFont:(UIFont *)boldFont andSmallFont:(UIFont *)smallFont {
    if (!plainText) {
        return nil;
    }
    
    if (!regularFont) {
        regularFont = [self kRegularFont];
    }
    
    if (!boldFont) {
        boldFont = [self kBoldFont];
    }
    
    if (!smallFont) {
        smallFont = [self kSmallFont];
    }
    
    NSError *error;
    NSString *regexMatchingStartTags = @"<[A-Z][A-Z0-9]*>";
    
    NSMutableArray *tagsArray = [@[] mutableCopy];
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexMatchingStartTags options:NSRegularExpressionCaseInsensitive error:&error];
    NSTextCheckingResult *match = nil;
    
    while ((match = [regex firstMatchInString:plainText options:0 range:NSMakeRange(0, plainText.length)])) {
        HTMLTag *tag = [[HTMLTag alloc] initFromString:[plainText substringWithRange:match.range] regularFont:regularFont boldFont:boldFont smallFont:smallFont];
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

+ (UIFont *)kRegularFont {
    static UIFont *regularFontConstant = nil;
    if (!regularFontConstant) {
        regularFontConstant = [UIFont systemFontOfSize:10.42];
    }
    return regularFontConstant;
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
        smallFontConstant = [UIFont systemFontOfSize:5.42];
    }
    return smallFontConstant;
}

@end
