//
//  RCTagProcessor.h
//  RCTagProcessing
//
//  Created by Radu Ciobanu on 11/10/2014.
//  Copyright (c) 2014 Radu Ciobanu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface RCTagProcessor : NSObject

+ (instancetype)defaultInstance;

- (NSAttributedString *)attributedStringForText:(NSString *)plainText withRegularFont:(UIFont *)regularFont boldFont:(UIFont *)boldFont andSmallFont:(UIFont *)smallFont ;

//Convenience
- (NSAttributedString *)attributedStringForText:(NSString *)plainText;

//Fallback values. Consider converting to properties
- (UIFont *)regularFont;
- (UIFont *)boldFont;
- (UIFont *)smallFont;

//Tag processing. Public for the sake of testability
- (NSArray *)getTagsFromString:(NSString *)stringWithTags;

@end
