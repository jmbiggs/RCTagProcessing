//
//  UIButton+TextAttributeTags.h
//  RCTagProcessing
//
//  Created by Radu Ciobanu on 11/10/2014.
//  Copyright (c) 2014 Radu Ciobanu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (TextAttributeTags)

- (void)rc_setTaggedTitle:(NSString *)titleWithTags forState:(UIControlState)state fontForBold:(UIFont *)boldFont smallFont:(UIFont *)smallFont;
- (void)rc_setTaggedTitleForAllStates:(NSString *)titleWithTags fontForBold:(UIFont *)boldFont smallFont:(UIFont *)smallFont;


//Convenience:
- (void)rc_setTaggedTitle:(NSString *)titleWithTags forState:(UIControlState)state;
- (void)rc_setTaggedTitleForAllStates:(NSString *)titleWithTags;

@end
