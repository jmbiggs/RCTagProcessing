//
//  UIButton+TextAttributeTags.m
//  RCTagProcessing
//
//  Created by Radu Ciobanu on 11/10/2014.
//  Copyright (c) 2014 Radu Ciobanu. All rights reserved.
//

#import "UIButton+TextAttributeTags.h"
#import "RCTagProcessor.h"
#import "UIFont+BoldFont.h"

@implementation UIButton (TextAttributeTags)

- (void)rc_setTaggedTitle:(NSString *)titleWithTags forState:(UIControlState)state {
    [self rc_setTaggedTitle:titleWithTags forState:state fontForBold:nil smallFont:nil];
}

- (void)rc_setTaggedTitle:(NSString *)titleWithTags forState:(UIControlState)state fontForBold:(UIFont *)boldFont smallFont:(UIFont *)smallFont {
    UIFont *selfBoldFont = boldFont;
    if (!selfBoldFont) {
        selfBoldFont = [self.titleLabel.font rc_boldFont];
    }
    
    UIFont *selfSmallFont = smallFont;
    if (!selfSmallFont) {
        selfSmallFont = [UIFont fontWithName:self.titleLabel.font.fontName size:self.titleLabel.font.pointSize * 0.75];
    }
    
    NSAttributedString *attributedString = [RCTagProcessor attributedStringForText:titleWithTags withRegularFont:self.titleLabel.font boldFont:selfBoldFont andSmallFont:selfSmallFont];
    
    [self setAttributedTitle:attributedString forState:state];
}

- (void)rc_setTaggedTitleForAllStates:(NSString *)titleWithTags {
    [self rc_setTaggedTitleForAllStates:titleWithTags fontForBold:nil smallFont:nil];
}

- (void)rc_setTaggedTitleForAllStates:(NSString *)titleWithTags fontForBold:(UIFont *)boldFont smallFont:(UIFont *)smallFont {
    //Parse once, grab title and set to other states
    [self rc_setTaggedTitle:titleWithTags forState:UIControlStateNormal fontForBold:boldFont smallFont:smallFont];
    NSAttributedString *attributedTitle = [self attributedTitleForState:UIControlStateNormal];
    
    [self setAttributedTitle:attributedTitle forState:UIControlStateHighlighted];
    [self setAttributedTitle:attributedTitle forState:UIControlStateDisabled];
    [self setAttributedTitle:attributedTitle forState:UIControlStateSelected];
    [self setAttributedTitle:attributedTitle forState:UIControlStateHighlighted|UIControlStateDisabled];
    [self setAttributedTitle:attributedTitle forState:UIControlStateHighlighted|UIControlStateSelected];
    [self setAttributedTitle:attributedTitle forState:UIControlStateDisabled|UIControlStateSelected];
    [self setAttributedTitle:attributedTitle forState:UIControlStateHighlighted|UIControlStateDisabled|UIControlStateSelected];
}

@end
