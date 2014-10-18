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
    [self rc_setTaggedText:textWithTags fontForBold:nil];
}

- (void)rc_setTaggedText:(NSString *)textWithTags fontForBold:(UIFont *)boldFont {
    UIFont *selfBoldFont = boldFont;
    if (!selfBoldFont) {
        selfBoldFont = [self.font rc_boldFont];
    }
    
    NSAttributedString *attributedString = [RCTagProcessor attributedStringForText:textWithTags withRegularFont:self.font andBoldFont:selfBoldFont];
    
    self.attributedText = attributedString;
}

@end
