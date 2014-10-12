//
//  UILabel+TextAttributeTags.m
//  RCTagProcessing
//
//  Created by Radu Ciobanu on 11/10/2014.
//  Copyright (c) 2014 Radu Ciobanu. All rights reserved.
//

#import "UILabel+TextAttributeTags.h"
#import "RCTagProcessor.h"

@implementation UILabel (TextAttributeTags)

- (void)rc_processFormatTagsInText:(NSString *)text {
    self.attributedText = [RCTagProcessor attributedStringForText:text];
}

@end
