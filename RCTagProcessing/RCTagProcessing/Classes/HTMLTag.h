//
//  HTMLTag.h
//  RCTagProcessing
//
//  Created by Radu Ciobanu on 18/10/2014.
//  Copyright (c) 2014 Radu Ciobanu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HTMLTag : NSObject

@property (nonatomic, assign) NSUInteger startLocation;
@property (nonatomic, assign) NSUInteger endLocation;
@property (nonatomic, strong) NSString *value;
@property (nonatomic, strong) UIFont *regularFont;
@property (nonatomic, strong) UIFont *boldFont;
@property (nonatomic, strong, readonly) NSString *startTag;
@property (nonatomic, strong, readonly) NSString *endTag;
@property (nonatomic, assign, readonly) NSRange range;
@property (nonatomic, strong, readonly) NSMutableArray *attributeNames;
@property (nonatomic, strong, readonly) NSMutableArray *attributeValues;

- (instancetype)initFromString:(NSString *)stringContainingTag;

@end

