//
//  FanSiteFeedNSXMLParserDelegate.h
//  FanSite
//
//  Created by Philip Nichols on 8/18/14.
//  Copyright (c) 2014 Phil Nichols. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FeedNSXMLParserDelegate : NSObject <NSXMLParserDelegate>

@property (strong, nonatomic, readonly) NSArray *feed;

@end
