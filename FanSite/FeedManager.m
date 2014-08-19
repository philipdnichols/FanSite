//
//  FanSiteFeedManager.m
//  FanSite
//
//  Created by Philip Nichols on 8/18/14.
//  Copyright (c) 2014 Phil Nichols. All rights reserved.
//

#import "FeedManager.h"
#import "FeedClient.h"
#import "FeedItem.h"

@interface FeedManager ()

@property (strong, nonatomic) FeedClient *client;

@end

@implementation FeedManager

#pragma mark - Properties

- (FeedClient *)client
{
    if (!_client) {
        _client = [[FeedClient alloc] init];
    }
    return _client;
}

#pragma mark - Singleton

+ (instancetype)sharedManager {
    static id _sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    return _sharedManager;
}

#pragma mark - Public

- (void)fetchFeedWithSuccess:(void(^)(NSArray *feedItems))success failure:(void(^)(NSError *error))failure
{
    [self.client fetchFeedWithSuccess:^(NSArray *feed) {
        NSError *error = nil;
        NSArray *feedItems = [MTLJSONAdapter modelsOfClass:[FeedItem class]
                                             fromJSONArray:feed
                                                     error:&error];
        
        if (!error) {
            success(feedItems);
        } else {
            failure(error);
        }
    } failure:^(NSError *error) {
        failure(error);
    }];
}

@end
