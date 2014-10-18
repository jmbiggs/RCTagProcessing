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
    [self rc_setTaggedText:textWithTags fontForBold:nil smallFont:nil];
}

- (void)rc_setTaggedText:(NSString *)textWithTags fontForBold:(UIFont *)boldFont smallFont:(UIFont *)smallFont {
    UIFont *selfBoldFont = boldFont;
    if (!selfBoldFont) {
        selfBoldFont = [self.font rc_boldFont];
    }
    
    UIFont *selfSmallFont = smallFont;
    if (!selfSmallFont) {
        selfSmallFont = [UIFont fontWithName:self.font.fontName size:self.font.pointSize * 0.75];
    }
    
    NSAttributedString *attributedString = [[RCTagProcessor defaultInstance] attributedStringForText:textWithTags withRegularFont:self.font boldFont:selfBoldFont andSmallFont:selfSmallFont];
    
    self.attributedText = attributedString;
}

@end
