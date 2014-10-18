//
//  HTMLTag.h
//  RCTagProcessing
//
//  Created by Radu Ciobanu on 18/10/2014.
//  Copyright (c) 2014 Radu Ciobanu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *  Currently supported tags:
 *  <b>, <u>, <i>, <sup>, <sub>, <strike>
 */

@interface HTMLTag : NSObject

@property (nonatomic, assign) NSUInteger startLocation;
@property (nonatomic, assign) NSUInteger endLocation;
@property (nonatomic, strong, readonly) NSString *value;
@property (nonatomic, strong, readonly) NSString *startTag;
@property (nonatomic, strong, readonly) NSString *endTag;
@property (nonatomic, assign, readonly) NSRange range;
@property (nonatomic, strong, readonly) NSMutableArray *attributeNames;
@property (nonatomic, strong, readonly) NSMutableArray *attributeValues;
@property (nonatomic, assign) CGFloat superscriptOffsetFactor;
@property (nonatomic, assign) CGFloat subscriptOffsetFactor;
@property (nonatomic, assign) CGFloat obliquenessFactor;

- (instancetype)initFromString:(NSString *)stringContainingTag regularFont:(UIFont *)regularFont boldFont:(UIFont *)boldFont smallFont:(UIFont *)smallFont;

@end

