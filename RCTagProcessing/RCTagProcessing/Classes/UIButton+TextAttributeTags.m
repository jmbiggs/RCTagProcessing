//
//  UIButton+TextAttributeTags.m
//  RCTagProcessing
//
//  Created by Radu Ciobanu on 11/10/2014.
//  Copyright (c) 2014 Radu Ciobanu. All rights reserved.
//

#import "UIButton+TextAttributeTags.h"
#import "RCTagProcessor.h"

@implementation UIButton (TextAttributeTags)

- (void)rc_setTaggedTitle:(NSString *)titleWithTags forState:(UIControlState)state {
    [self setAttributedTitle:[RCTagProcessor attributedStringForText:titleWithTags] forState:state];
}

- (void)rc_setTaggedTitleForAllStates:(NSString *)titleWithTags {
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
