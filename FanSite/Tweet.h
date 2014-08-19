//
//  Tweet.h
//  FanSite
//
//  Created by Philip Nichols on 8/19/14.
//  Copyright (c) 2014 Phil Nichols. All rights reserved.
//

#import "MTLModel.h"

@interface Tweet : MTLModel <MTLJSONSerializing>

@property (strong, nonatomic) NSString *identifier;
@property (strong, nonatomic) NSString *tweet;
@property (strong, nonatomic) NSDate *date;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSURL *tweetURL;

@end
