//
//  NSString+TagSupport.m
//  RCTagProcessing
//
//  Created by Radu Ciobanu on 19/10/2014.
//  Copyright (c) 2014 Radu Ciobanu. All rights reserved.
//

#import "NSString+TagSupport.h"

@implementation NSString (TagSupport)

- (BOOL)stringFullyMatchesRegexPattern:(NSString *)pattern {
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    NSTextCheckingResult *match = [regex firstMatchInString:self options:0 range:NSMakeRange(0, self.length)];
    
    return (match.range.location == 0) && (match.range.length == self.length);
}

- (NSString *)rc_stringByRemovingTags {
    NSError *error;
    NSString *regexMatchingStartOrEndTags = @"<\\/?[A-Z][A-Z0-9]*>";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexMatchingStartOrEndTags options:NSRegularExpressionCaseInsensitive error:&error];
    return [regex stringByReplacingMatchesInString:self options:0 range:NSMakeRange(0, self.length) withTemplate:@""];
}

- (BOOL)rc_isValidTag {
    NSString *regexMatchingStartOrEndTags = @"<\\/?[A-Z][A-Z0-9]*>";

    //TODO: add acceptance for self-closing tags
    return [self stringFullyMatchesRegexPattern:regexMatchingStartOrEndTags];
}

- (BOOL)rc_isOpeningTag {
    NSString *regexMatchingStartTags = @"<[A-Z][A-Z0-9]*>";

    return [self stringFullyMatchesRegexPattern:regexMatchingStartTags];
}

- (BOOL)rc_isClosingTag {
    NSString *regexMatchingEndTags = @"<\\/[A-Z][A-Z0-9]*>";

    return [self stringFullyMatchesRegexPattern:regexMatchingEndTags];
}


@end
