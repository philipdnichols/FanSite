//
//  FanSiteFeedTableViewController.m
//  FanSite
//
//  Created by Philip Nichols on 8/18/14.
//  Copyright (c) 2014 Phil Nichols. All rights reserved.
//

#import "FanSiteFeedTableViewController.h"
#import "ArrayDataSource.h"

@interface FanSiteFeedTableViewController ()

@property (strong, nonatomic) ArrayDataSource *feedArrayDataSource;

@end

@implementation FanSiteFeedTableViewController

#pragma mark - Properties

- (void)setFeedArrayDataSource:(ArrayDataSource *)feedArrayDataSource
{
    _feedArrayDataSource = feedArrayDataSource;
    
    self.tableView.dataSource = _feedArrayDataSource;
    [self.tableView reloadData];
}

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self refreshFeed];
}

#pragma mark - IBActions

- (IBAction)refreshFeed
{
    [self.refreshControl beginRefreshing];
    
    [self.refreshControl endRefreshing];
}

@end
