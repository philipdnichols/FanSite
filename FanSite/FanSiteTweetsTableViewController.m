//
//  FanSiteTweetsTableViewController.m
//  FanSite
//
//  Created by Philip Nichols on 8/18/14.
//  Copyright (c) 2014 Phil Nichols. All rights reserved.
//

#import "FanSiteTweetsTableViewController.h"
#import "ArrayDataSource.h"

@interface FanSiteTweetsTableViewController ()

@property (strong, nonatomic) ArrayDataSource *tweetsArrayDataSource;

@end

@implementation FanSiteTweetsTableViewController

#pragma mark - Properties

- (void)setTweetsArrayDataSource:(ArrayDataSource *)tweetsArrayDataSource
{
    _tweetsArrayDataSource = tweetsArrayDataSource;
    
    self.tableView.dataSource = _tweetsArrayDataSource;
    [self.tableView reloadData];
}

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self refreshTweets];
}

#pragma mark - IBActions

- (IBAction)refreshTweets
{
    [self.refreshControl beginRefreshing];
    
    [self.refreshControl endRefreshing];
}

@end
