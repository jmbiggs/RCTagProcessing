//
//  NSString+TagSupport.h
//  RCTagProcessing
//
//  Created by Radu Ciobanu on 19/10/2014.
//  Copyright (c) 2014 Radu Ciobanu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (TagSupport)

- (NSString *)rc_stringByRemovingTags;
- (BOOL)rc_isValidTag;
- (BOOL)rc_isOpeningTag;
- (BOOL)rc_isClosingTag;

@end
