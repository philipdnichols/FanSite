//
//  FeedItem.m
//  FanSite
//
//  Created by Philip Nichols on 8/18/14.
//  Copyright (c) 2014 Phil Nichols. All rights reserved.
//

#import "FeedItem.h"

@implementation FeedItem

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"title" : @"title",
             @"date" : @"pubDate",
             @"link" : @"link"
             };
}

+ (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *_dateFormater = nil;
    if (!_dateFormater) {
        _dateFormater = [[NSDateFormatter alloc] init];
        _dateFormater.dateFormat = @"EEE, dd MMM yyyy HH:mm:ss ZZZ";
    }
    return _dateFormater;
}

+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key
{
    if ([key isEqualToString:@"date"]) {
        return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *str) {
            return [[self dateFormatter] dateFromString:str];
        } reverseBlock:^id(NSDate *date) {
            return [[self dateFormatter] stringFromDate:date];
        }];
    } else if ([key isEqualToString:@"link"]) {
        return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
    }
    
    return nil;
}

@end
