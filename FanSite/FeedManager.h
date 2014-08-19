//
//  FanSiteFeedManager.h
//  FanSite
//
//  Created by Philip Nichols on 8/18/14.
//  Copyright (c) 2014 Phil Nichols. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FeedManager : NSObject

+ (instancetype)sharedManager;

- (void)fetchFeedWithSuccess:(void(^)(NSArray *feedItems))success failure:(void(^)(NSError *error))failure;

@end
