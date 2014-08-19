//
//  TwitterClient.m
//  FanSite
//
//  Created by Philip Nichols on 8/19/14.
//  Copyright (c) 2014 Phil Nichols. All rights reserved.
//

#import "TwitterClient.h"

static NSString * const TwitterURLString = @"https://api.twitter.com/1.1/statuses/user_timeline.json";
static NSString * const TwitterScreenName = @"iosdevpractice";

static NSString * const TwitterDomain = @"Twitter";

typedef NS_ENUM(NSInteger, TwitterError) {
    TwitterErrorAccessDenied,
    TwitterErrorNoTwitterAccounts
};

@interface TwitterClient ()

@property (strong, nonatomic) ACAccountStore *accountStore;
@property (strong, nonatomic) ACAccountType *twitterAccountType;

@property (strong, nonatomic) NSError *accessError;
@property (strong, nonatomic) NSError *noAccountsError;

@end

@implementation TwitterClient

#pragma mark - Properties

- (ACAccountStore *)accountStore
{
    if (!_accountStore) {
        _accountStore = [[ACAccountStore alloc] init];
        self.twitterAccountType = [_accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    }
    return _accountStore;
}

- (NSError *)accessError
{
    if (!_accessError) {
        _accessError = [NSError errorWithDomain:TwitterDomain
                                           code:TwitterErrorAccessDenied
                                       userInfo:@{
                                                  NSLocalizedDescriptionKey : @"Access to Twitter has been denied. This can be changed in Settings -> Privacy -> Twitter"
                                                  }];
    }
    return _accessError;
}

- (NSError *)noAccountsError
{
    if (!_noAccountsError) {
        _noAccountsError = [NSError errorWithDomain:TwitterDomain
                                               code:TwitterErrorNoTwitterAccounts
                                           userInfo:@{
                                                      NSLocalizedDescriptionKey : @"No Twitter Accounts are configured on this device."
                                                      }];
    }
    return _noAccountsError;
}

#pragma mark - Initialization

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.responseSerializer = [AFJSONResponseSerializer serializer];
    }
    return self;
}

#pragma mark - Public

- (void)fetchTweetsWithSuccess:(void(^)(NSArray *tweets))success failure:(void(^)(NSError *error))failure
{
    [self requestForTweetsWithSuccess:^(NSURLRequest *request) {
        NSURLSessionDataTask *task = [self dataTaskWithRequest:request
                                             completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
                                                 if (!error) {
                                                     success(responseObject);
                                                 } else {
                                                     failure(error);
                                                 }
                                             }];
        [task resume];
    } failure:^(NSError *error) {
        failure(error);
    }];
}

#pragma mark - Private

- (void)requestForTweetsWithSuccess:(void(^)(NSURLRequest *request))success failure:(void(^)(NSError *error))failure
{
    [self.accountStore requestAccessToAccountsWithType:self.twitterAccountType
                                               options:kNilOptions
                                            completion:^(BOOL granted, NSError *error) {
                                                if (granted) {
                                                    NSArray *twitterAccounts = [self.accountStore accountsWithAccountType:self.twitterAccountType];
                                                    if ([twitterAccounts count] == 0) {
                                                        failure(self.noAccountsError);
                                                    } else {
                                                        NSDictionary *parameters = @{
                                                                                     @"screen_name" : TwitterScreenName
                                                                                     };
                                                        
                                                        SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                                                                requestMethod:SLRequestMethodGET
                                                                                                          URL:[NSURL URLWithString:TwitterURLString]
                                                                                                   parameters:parameters];
                                                        [request setAccount:[twitterAccounts lastObject]];
                                                        
                                                        success([request preparedURLRequest]);
                                                    }
                                                } else {
                                                    if (error) {
                                                        failure(error);
                                                    } else {
                                                        failure(self.accessError);
                                                    }
                                                }
                                            }];
}

@end
