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
