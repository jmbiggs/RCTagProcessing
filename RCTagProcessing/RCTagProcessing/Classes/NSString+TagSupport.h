//
//  NSString+TagSupport.h
//  RCTagProcessing
//
//  Created by Radu Ciobanu on 19/10/2014.
//  Copyright (c) 2014 Radu Ciobanu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (TagSupport)

- (NSString *)stringByRemovingTags;
- (BOOL)isValidTag;
- (BOOL)isOpeningTag;
- (BOOL)isClosingTag;

@end
