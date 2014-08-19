//
//  TwitterManager.m
//  FanSite
//
//  Created by Philip Nichols on 8/19/14.
//  Copyright (c) 2014 Phil Nichols. All rights reserved.
//

#import "TwitterManager.h"
#import "TwitterClient.h"
#import "Tweet.h"

@interface TwitterManager ()

@property (strong, nonatomic) TwitterClient *client;

@end

@implementation TwitterManager

#pragma mark - Properties

- (TwitterClient *)client
{
    if (!_client) {
        _client = [[TwitterClient alloc] init];
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

- (void)fetchTweetsWithSuccess:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure
{
    [self.client fetchTweetsWithSuccess:^(NSArray *tweets) {
        NSError *error = nil;
        NSArray *tweetModels = [MTLJSONAdapter modelsOfClass:[Tweet class]
                                               fromJSONArray:tweets
                                                       error:&error];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if (!error) {
                success(tweetModels);
            } else {
                failure(error);
            }
        }];
    } failure:^(NSError *error) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            failure(error);
        }];
    }];
}

@end
