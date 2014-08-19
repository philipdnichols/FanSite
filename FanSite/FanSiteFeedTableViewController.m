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
#import "FeedItemCell.h"
#import "FeedItemCell+Configure.h"

@interface FanSiteFeedTableViewController ()

@property (strong, nonatomic) ArrayDataSource *feedArrayDataSource;

@property (copy, nonatomic) TableViewCellConfigureBlock feedCellConfigureBlock;

@end

@implementation FanSiteFeedTableViewController

#pragma mark - Properties

- (void)setFeedArrayDataSource:(ArrayDataSource *)feedArrayDataSource
{
    _feedArrayDataSource = feedArrayDataSource;
    
    self.tableView.dataSource = _feedArrayDataSource;
    [self.tableView reloadData];
}

- (TableViewCellConfigureBlock)feedCellConfigureBlock
{
    if (!_feedCellConfigureBlock) {
        _feedCellConfigureBlock = ^(FeedItemCell *feedItemCell, FeedItem *feedItem) {
            [feedItemCell configureForFeedItem:feedItem];
        };
    }
    return _feedCellConfigureBlock;
}

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupTableView];
    
    [self refreshFeed];
}

- (void)setupTableView
{
    [self.tableView registerNib:[FeedItemCell nib] forCellReuseIdentifier:[FeedItemCell identifier]];
}

#pragma mark - IBActions

- (IBAction)refreshFeed
{
    [self.refreshControl beginRefreshing];
    
    [[FeedManager sharedManager] fetchFeedWithSuccess:^(NSArray *feedItems) {
        [self.refreshControl endRefreshing];
        
        self.feedArrayDataSource = [[ArrayDataSource alloc] initWithItems:feedItems
                                                           cellIdentifier:[FeedItemCell identifier]
                                                       configureCellBlock:self.feedCellConfigureBlock];
    } failure:^(NSError *error) {
        [self.refreshControl endRefreshing];
        
        [TSMessage showNotificationInViewController:self
                                              title:@"Error"
                                           subtitle:[error localizedDescription]
                                               type:TSMessageNotificationTypeError];
        
        NSLog(@"Error fetching feed: %@", [error localizedDescription]);
    }];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:FeedDetailSegueIdentifier sender:[tableView cellForRowAtIndexPath:indexPath]];
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
                
                [self prepareFeedDetailViewController:viewController withFeedItem:feedItem];
            }
        }
    }
}

- (void)prepareFeedDetailViewController:(FanSiteFeedDetailViewController *)viewController withFeedItem:(FeedItem *)feedItem
{
    viewController.feedItemURL = feedItem.link;
    viewController.title = feedItem.title;
}

@end
