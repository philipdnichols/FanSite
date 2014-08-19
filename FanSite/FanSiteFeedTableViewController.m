//
//  FanSiteFeedTableViewController.m
//  FanSite
//
//  Created by Philip Nichols on 8/18/14.
//  Copyright (c) 2014 Phil Nichols. All rights reserved.
//

#import "FanSiteFeedTableViewController.h"
#import "ArrayDataSource.h"
#import "FeedManager.h"
#import "FeedItem.h"
#import "FanSiteFeedDetailViewController.h"

@interface FanSiteFeedTableViewController ()

@property (strong, nonatomic) ArrayDataSource *feedArrayDataSource;

@property (strong, nonatomic) NSDateFormatter *feedCellDateFormatter;

@end

@implementation FanSiteFeedTableViewController

#pragma mark - Properties

- (void)setFeedArrayDataSource:(ArrayDataSource *)feedArrayDataSource
{
    _feedArrayDataSource = feedArrayDataSource;
    
    self.tableView.dataSource = _feedArrayDataSource;
    [self.tableView reloadData];
}

- (NSDateFormatter *)feedCellDateFormatter
{
    if (!_feedCellDateFormatter) {
        _feedCellDateFormatter = [[NSDateFormatter alloc] init];
        _feedCellDateFormatter.dateFormat = @"MMM dd, yyyy hh:mm a";
    }
    return _feedCellDateFormatter;
}

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self refreshFeed];
}

#pragma mark - IBActions

static NSString * const FeedCellIdentifier = @"FeedCell";

- (IBAction)refreshFeed
{
    [self.refreshControl beginRefreshing];
    
    [[FeedManager sharedManager] fetchFeedWithSuccess:^(NSArray *feedItems) {
        [self.refreshControl endRefreshing];
        
        self.feedArrayDataSource = [[ArrayDataSource alloc] initWithItems:feedItems
                                                           cellIdentifier:FeedCellIdentifier
                                                       configureCellBlock:^(UITableViewCell *cell, FeedItem *feedItem) {
                                                           // TODO: Move this to a property and use a custom cell with a category
                                                           cell.textLabel.text = feedItem.title;
                                                           cell.detailTextLabel.text = [self.feedCellDateFormatter stringFromDate:feedItem.date];
                                                       }];
    } failure:^(NSError *error) {
        [self.refreshControl endRefreshing];
        
        NSLog(@"Error fetching feed: %@", [error localizedDescription]);
    }];
}

#pragma mark - Navigation

static NSString * const FeedDetailSegueIdentifier = @"Feed Detail";

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [self prepareViewController:segue.destinationViewController
                       forSegue:segue.identifier
                     fromSender:sender];
}

- (void)prepareViewController:(id)viewController forSegue:(NSString *)segueIdentifier fromSender:(id)sender
{
    NSIndexPath *indexPath = nil;
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        indexPath = [self.tableView indexPathForCell:sender];
    }
    
    if ([viewController isKindOfClass:[FanSiteFeedDetailViewController class]]) {
        if (![segueIdentifier length] || [segueIdentifier isEqualToString:FeedDetailSegueIdentifier]) {
            if (indexPath) {
                FeedItem *feedItem = [self.feedArrayDataSource itemAtIndexPath:indexPath];
                
                FanSiteFeedDetailViewController *fanSiteFeedDetailViewController = (FanSiteFeedDetailViewController *)viewController;
                fanSiteFeedDetailViewController.feedItemURL = feedItem.link;
                fanSiteFeedDetailViewController.title = feedItem.title;
            }
        }
    }
}

@end
