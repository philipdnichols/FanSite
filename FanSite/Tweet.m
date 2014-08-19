//
//  Tweet.m
//  FanSite
//
//  Created by Philip Nichols on 8/19/14.
//  Copyright (c) 2014 Phil Nichols. All rights reserved.
//

#import "Tweet.h"

@implementation Tweet

#pragma mark - Properties

- (NSURL *)tweetURL
{
    if (!_tweetURL) {
        // TODO: Pull this URL String constant out
        _tweetURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.twitter.com/%@/status/%@", self.username, self.identifier]];
    }
    return _tweetURL;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"identifier" : @"id",
             @"tweet" : @"text",
             @"date" : @"created_at",
             @"username" : @"user.screen_name"
             };
}

+ (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *_dateFormater = nil;
    if (!_dateFormater) {
        _dateFormater = [[NSDateFormatter alloc] init];
        _dateFormater.dateFormat = @"EEE MMM dd HH:mm:ss ZZZ yyyy";
    }
    return _dateFormater;
}

+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key
{
    if ([key isEqualToString:@"date"]) {
        return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *str) {
            return [[self dateFormatter] dateFromString:str];
        } reverseBlock:^(NSDate *date) {
            return [[self dateFormatter] stringFromDate:date];
        }];
    }
    
    return nil;
}

@end
