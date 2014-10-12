//
//  RCTagProcessor.m
//  RCTagProcessing
//
//  Created by Radu Ciobanu on 11/10/2014.
//  Copyright (c) 2014 Radu Ciobanu. All rights reserved.
//

#import "RCTagProcessor.h"

@implementation RCTagProcessor

+ (NSAttributedString *)attributedStringForText:(NSString *)plainText {
    if (!plainText) {
        return nil;
    }
    
    NSMutableString *processedText = [NSMutableString stringWithString:plainText];
    NSMutableArray *attributeRanges = [NSMutableArray array];
    while ([processedText rangeOfString:@"<b>"].location != NSNotFound)
    {
        NSRange startingAt = [processedText rangeOfString:@"<b>"];
        [processedText replaceCharactersInRange:startingAt withString:@""];
        NSRange endingAt = [processedText rangeOfString:@"</b>"];
        [processedText replaceCharactersInRange:endingAt withString:@""];
        if (endingAt.location != NSNotFound)
        {
            [attributeRanges addObject:[NSValue valueWithRange:NSMakeRange(startingAt.location, endingAt.location - startingAt.location)]];
        }
    }
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:processedText];
    for (NSValue *value in attributeRanges)
    {
        [attributedText addAttribute:NSFontAttributeName value:[self kBoldFont] range:[value rangeValue]];
    }
    return attributedText;
}

+ (UIFont *)kBoldFont {
    static UIFont *boldFontConstant = nil;
    if (!boldFontConstant) {
        boldFontConstant = [UIFont boldSystemFontOfSize:42];
    }
    return boldFontConstant;
}

@end
