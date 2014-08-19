//
//  TwitterManager.h
//  FanSite
//
//  Created by Philip Nichols on 8/19/14.
//  Copyright (c) 2014 Phil Nichols. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TwitterManager : NSObject

+ (instancetype)sharedManager;

- (void)fetchTweetsWithSuccess:(void(^)(NSArray *tweets))success failure:(void(^)(NSError *error))failure;

@end
