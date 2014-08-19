//
//  TweetCell.m
//  FanSite
//
//  Created by Philip Nichols on 8/19/14.
//  Copyright (c) 2014 Phil Nichols. All rights reserved.
//

#import "TweetCell.h"

@implementation TweetCell

+ (UINib *)nib
{
    return [UINib nibWithNibName:@"TweetCell" bundle:nil];
}

+ (NSString *)identifier
{
    return @"Tweet Cell";
}

@end
