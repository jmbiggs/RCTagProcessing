//
//  UIFont+BoldFont.m
//  RCTagProcessing
//
//  Created by Radu Ciobanu on 12/10/2014.
//  Copyright (c) 2014 Radu Ciobanu. All rights reserved.
//

#import "UIFont+BoldFont.h"

@implementation UIFont (BoldFont)

- (UIFont *)rc_boldFont {
    NSArray *fontNames = [UIFont fontNamesForFamilyName:self.familyName];
    for (NSString *fontName in fontNames) {
        NSString *upperCaseFontName = [fontName uppercaseString];
        if ([upperCaseFontName rangeOfString:@"BOLD"].location != NSNotFound &&
            [upperCaseFontName rangeOfString:@"ITAL"].location == NSNotFound) {
            return [UIFont fontWithName:fontName size:self.pointSize];
        }
    }
    return nil;
}

@end
