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
    [self rc_setTaggedTitle:titleWithTags forState:state fontForBold:nil];
}

- (void)rc_setTaggedTitle:(NSString *)titleWithTags forState:(UIControlState)state fontForBold:(UIFont *)boldFont {
    UIFont *selfBoldFont = boldFont;
    if (!selfBoldFont) {
        selfBoldFont = [self.titleLabel.font rc_boldFont];
    }
    
    NSAttributedString *attributedString = [RCTagProcessor attributedStringForText:titleWithTags withRegularFont:self.titleLabel.font andBoldFont:selfBoldFont];
    
    [self setAttributedTitle:attributedString forState:state];
}

- (void)rc_setTaggedTitleForAllStates:(NSString *)titleWithTags {
    [self rc_setTaggedTitleForAllStates:titleWithTags fontForBold:nil];
}

- (void)rc_setTaggedTitleForAllStates:(NSString *)titleWithTags fontForBold:(UIFont *)boldFont {
    NSAttributedString *attributedTitle = [RCTagProcessor attributedStringForText:titleWithTags];
    [self setAttributedTitle:attributedTitle forState:UIControlStateNormal];
    [self setAttributedTitle:attributedTitle forState:UIControlStateHighlighted];
    [self setAttributedTitle:attributedTitle forState:UIControlStateDisabled];
    [self setAttributedTitle:attributedTitle forState:UIControlStateSelected];
    [self setAttributedTitle:attributedTitle forState:UIControlStateHighlighted|UIControlStateDisabled];
    [self setAttributedTitle:attributedTitle forState:UIControlStateHighlighted|UIControlStateSelected];
    [self setAttributedTitle:attributedTitle forState:UIControlStateDisabled|UIControlStateSelected];
    [self setAttributedTitle:attributedTitle forState:UIControlStateHighlighted|UIControlStateDisabled|UIControlStateSelected];
}

@end
