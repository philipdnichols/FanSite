//
//  FanSiteFeedDetailViewController.m
//  FanSite
//
//  Created by Philip Nichols on 8/18/14.
//  Copyright (c) 2014 Phil Nichols. All rights reserved.
//

#import "FanSiteFeedDetailViewController.h"

@interface FanSiteFeedDetailViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *feedItemWebView;

@end

@implementation FanSiteFeedDetailViewController

- (void)setFeedItemURL:(NSURL *)feedItemURL
{
    _feedItemURL = feedItemURL;
    
    if (self.view.window) {
        [self updateUI];
    }
}

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self updateUI];
}

- (void)updateUI
{
    [self.feedItemWebView loadRequest:[NSURLRequest requestWithURL:self.feedItemURL]];
}

@end
