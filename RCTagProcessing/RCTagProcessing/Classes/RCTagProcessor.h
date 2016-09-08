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

@property (nonatomic) UIFont * regularFont;
@property (nonatomic) UIFont * boldFont;
@property (nonatomic) UIFont * smallFont;

+ (instancetype)defaultInstance;

- (NSAttributedString *)attributedStringForText:(NSString *)plainText withRegularFont:(UIFont *)regularFont boldFont:(UIFont *)boldFont andSmallFont:(UIFont *)smallFont ;

//Convenience. Will use defaults. Be prepared to post-process the text later
- (NSAttributedString *)attributedStringForText:(NSString *)plainText;

//Tag processing. Public for the sake of testability
- (NSArray *)getTagsFromString:(NSString *)stringWithTags;

@end
