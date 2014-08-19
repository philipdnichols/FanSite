//
//  FeedItemCell.m
//  FanSite
//
//  Created by Philip Nichols on 8/19/14.
//  Copyright (c) 2014 Phil Nichols. All rights reserved.
//

#import "FeedItemCell.h"

@implementation FeedItemCell

+ (UINib *)nib
{
    return [UINib nibWithNibName:@"FeedItemCell" bundle:nil];
}

+ (NSString *)identifier
{
    return @"FeedItem Cell";
}

@end
