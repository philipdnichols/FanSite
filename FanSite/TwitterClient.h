//
//  TwitterClient.h
//  FanSite
//
//  Created by Philip Nichols on 8/19/14.
//  Copyright (c) 2014 Phil Nichols. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface TwitterClient : AFHTTPSessionManager

- (void)fetchTweetsWithSuccess:(void(^)(NSArray *tweets))success failure:(void(^)(NSError *error))failure;

@end
