//
//  FanSiteFeedAPI.h
//  FanSite
//
//  Created by Philip Nichols on 8/18/14.
//  Copyright (c) 2014 Phil Nichols. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface FeedClient : AFHTTPSessionManager

- (void)fetchFeedWithSuccess:(void(^)(NSArray *feed))success failure:(void(^)(NSError *error))failure;

@end
