//
//  RCTagProcessor.m
//  RCTagProcessing
//
//  Created by Radu Ciobanu on 11/10/2014.
//  Copyright (c) 2014 Radu Ciobanu. All rights reserved.
//

#import "RCTagProcessor.h"
#import "HTMLTag.h"
#import "NSString+TagSupport.h"

@implementation RCTagProcessor

+ (instancetype)defaultInstance {
    static RCTagProcessor *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[RCTagProcessor alloc] init];
        [_sharedInstance setRegularFont:[UIFont systemFontOfSize:10.42]];
        [_sharedInstance setBoldFont:[UIFont boldSystemFontOfSize:10.42]];
        [_sharedInstance setSmallFont:[UIFont systemFontOfSize:5.42]];
    });
    
    return _sharedInstance;
}

- (NSAttributedString *)attributedStringForText:(NSString *)plainText {
    return [self attributedStringForText:plainText withRegularFont:nil boldFont:nil andSmallFont:nil];
}

- (NSAttributedString *)attributedStringForText:(NSString *)plainText withRegularFont:(UIFont *)regularFont boldFont:(UIFont *)boldFont andSmallFont:(UIFont *)smallFont {
    if (!plainText) {
        return nil;
    }
    
    if (!regularFont) {
        regularFont = [self regularFont];
    }
    
    if (!boldFont) {
        boldFont = [self boldFont];
    }
    
    if (!smallFont) {
        smallFont = [self smallFont];
    }

    NSArray *tagsArray = [self getTagsFromString:plainText];
    plainText = [plainText rc_stringByRemovingTags];
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:plainText];
    
    for (HTMLTag *tag in tagsArray) {
        tag.regularFont = regularFont;
        tag.boldFont = boldFont;
        tag.smallFont = smallFont;
        for (int i = 0; i < tag.attributeNames.count;i++) {
            [attributedText addAttribute:[tag.attributeNames objectAtIndex:i] value:[tag.attributeValues objectAtIndex:i] range:tag.range];
        }
    }
    
    return attributedText;
}

- (NSArray *)getTagsFromString:(NSString *)stringWithTags {
    if (stringWithTags.length == 0) {
        //not an error, but avoids throwing an exception from the regex matching
        return @[];
    }
    
    NSError *error;
    NSString *regexMatchingStartOrEndTags = @"<\\/?[A-Z][A-Z0-9]*>";
    
    NSMutableArray *tagsArray = [@[] mutableCopy];
    NSMutableArray *tagsQueue = [@[] mutableCopy];
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexMatchingStartOrEndTags options:NSRegularExpressionCaseInsensitive error:&error];
    NSTextCheckingResult *match = nil;
    
    while ((match = [regex firstMatchInString:stringWithTags options:0 range:NSMakeRange(0, stringWithTags.length)])) {
        NSString *tagString = [stringWithTags substringWithRange:match.range];
        
        if ([tagString rc_isClosingTag]) {
            if (tagsQueue.count == 0) {
                NSLog(@"Closing tag %@ found without any opening tag", tagString);
                return nil;
            }
            HTMLTag *currentTag = tagsQueue.lastObject;
            if (![tagString isEqualToString:currentTag.endTag]) {
                NSLog(@"Closing tag %@ doesn't match opening tag %@", tagString, currentTag.startTag);
                return nil;
            } else {
                currentTag.endLocation = match.range.location;
                [tagsQueue removeLastObject]; //pop from queue

            }
        } else if ([tagString rc_isOpeningTag]) {
            HTMLTag *tag = [[HTMLTag alloc] initFromString:tagString];
            tag.startLocation = match.range.location;
            [tagsArray addObject:tag];
            [tagsQueue addObject:tag]; //push to queue
        } else {
            //Is this even possible?
            [NSException raise:@"Invalid tag" format:@"%@ is neither an opening nor a closing tag", tagString];
        }

        stringWithTags = [stringWithTags stringByReplacingCharactersInRange:match.range withString:@""];
    }
    
    if (tagsQueue.count > 0) {
        NSLog(@"Reached end of string with %ld tags still open. Recovering by closing all pending tags", (long)tagsQueue.count);
        for (HTMLTag *tag in tagsQueue) {
            tag.endLocation = stringWithTags.length;
        }
    }

    return tagsArray;
}

@end
