//
//  TweetCell+Configure.m
//  FanSite
//
//  Created by Philip Nichols on 8/19/14.
//  Copyright (c) 2014 Phil Nichols. All rights reserved.
//

#import "TweetCell+Configure.h"

@implementation TweetCell (Configure)

+ (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *_dateFormatter;
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"MMM dd, yyyy, hh:mm a"];
    }
    return _dateFormatter;
}

- (void)configureForTweet:(Tweet *)tweet
{
    self.tweetLabel.text = tweet.tweet;
    self.tweetDateLabel.text = [[TweetCell dateFormatter] stringFromDate:tweet.date];
}

@end
