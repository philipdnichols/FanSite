//
//  FeedItemCell+Configure.m
//  FanSite
//
//  Created by Philip Nichols on 8/19/14.
//  Copyright (c) 2014 Phil Nichols. All rights reserved.
//

#import "FeedItemCell+Configure.h"

@implementation FeedItemCell (Configure)

+ (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *_dateFormatter;
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"MMM dd, yyyy, hh:mm a"];
    }
    return _dateFormatter;
}

- (void)configureForFeedItem:(FeedItem *)feedItem
{
    self.feedItemTitleLabel.text = feedItem.title;
    self.feedItemDateLabel.text = [[FeedItemCell dateFormatter] stringFromDate:feedItem.date];
}

@end
