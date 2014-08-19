//
//  FanSiteFeedAPI.m
//  FanSite
//
//  Created by Philip Nichols on 8/18/14.
//  Copyright (c) 2014 Phil Nichols. All rights reserved.
//

#import "FeedClient.h"
#import "FeedNSXMLParserDelegate.h"

static NSString * const FeedURLString = @"http://www.iosdevpractice.com/feed.xml";

@implementation FeedClient

#pragma mark - Initialization

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.responseSerializer = [AFXMLParserResponseSerializer serializer];
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/rss+xml"];
    }
    return self;
}

#pragma mark - Public

- (void)fetchFeedWithSuccess:(void(^)(NSArray *feed))success failure:(void(^)(NSError *error))failure
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:FeedURLString]];
    NSURLSessionDataTask *task = [self dataTaskWithRequest:request
                                         completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
                                             if (!error) {
                                                 NSXMLParser *xmlParser = (NSXMLParser *)responseObject;
                                                 FeedNSXMLParserDelegate *xmlParserDelegate = [[FeedNSXMLParserDelegate alloc] init];
                                                 xmlParser.delegate = xmlParserDelegate;
                                                 
                                                 if ([xmlParser parse]) {
                                                     success(xmlParserDelegate.feed);
                                                 } else {
                                                     failure([xmlParser parserError]);
                                                 }
                                             } else {
                                                 failure(error);
                                             }
                                         }];
    [task resume];
}

@end
