//
//  UILabel+TextAttributeTags.m
//  RCTagProcessing
//
//  Created by Radu Ciobanu on 11/10/2014.
//  Copyright (c) 2014 Radu Ciobanu. All rights reserved.
//

#import "UILabel+TextAttributeTags.h"
#import "RCTagProcessor.h"
#import "UIFont+BoldFont.h"

@implementation UILabel (TextAttributeTags)

- (void)rc_setTaggedText:(NSString *)textWithTags {
    NSMutableAttributedString *mutableAttributedString = [[RCTagProcessor attributedStringForText:textWithTags] mutableCopy];
    UIFont *selfBoldFont = [self.font rc_boldFont];
    
    [mutableAttributedString enumerateAttributesInRange:NSMakeRange(0, mutableAttributedString.length) options:0 usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
        UIFont *font = [attrs valueForKey:NSFontAttributeName];

        if ([font isEqual:[RCTagProcessor kBoldFont]] && selfBoldFont) {
            [mutableAttributedString addAttribute:NSFontAttributeName value:selfBoldFont range:range];
        }
    }];
    
    
    self.attributedText = mutableAttributedString;
}

@end
