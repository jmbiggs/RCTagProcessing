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

+ (UIFont *)kRegularFont;
+ (UIFont *)kBoldFont;
+ (UIFont *)kSmallFont;

+ (NSAttributedString *)attributedStringForText:(NSString *)plainText withRegularFont:(UIFont *)regularFont boldFont:(UIFont *)boldFont andSmallFont:(UIFont *)smallFont ;

//Convenience
+ (NSAttributedString *)attributedStringForText:(NSString *)plainText;

@end
