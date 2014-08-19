//
//  FanSiteTweetDetailViewController.m
//  FanSite
//
//  Created by Philip Nichols on 8/19/14.
//  Copyright (c) 2014 Phil Nichols. All rights reserved.
//

#import "FanSiteTweetDetailViewController.h"

@interface FanSiteTweetDetailViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *tweetWebView;

@end

@implementation FanSiteTweetDetailViewController

#pragma mark - Properties

- (void)setTweetURL:(NSURL *)tweetURL
{
    _tweetURL = tweetURL;
    
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
    [self.tweetWebView loadRequest:[NSURLRequest requestWithURL:self.tweetURL]];
}

@end
