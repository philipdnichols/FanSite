//
//  FanSiteTweetsTableViewController.m
//  FanSite
//
//  Created by Philip Nichols on 8/18/14.
//  Copyright (c) 2014 Phil Nichols. All rights reserved.
//

#import "FanSiteTweetsTableViewController.h"
#import "ArrayDataSource.h"
#import "TweetCell.h"
#import "TwitterManager.h"
#import "Tweet.h"
#import "TweetCell+Configure.h"
#import "FanSiteTweetDetailViewController.h"

@interface FanSiteTweetsTableViewController ()

@property (strong, nonatomic) ArrayDataSource *tweetsArrayDataSource;

@property (copy, nonatomic) TableViewCellConfigureBlock tweetCellConfigureBlock;

@end

@implementation FanSiteTweetsTableViewController

#pragma mark - Properties

- (void)setTweetsArrayDataSource:(ArrayDataSource *)tweetsArrayDataSource
{
    _tweetsArrayDataSource = tweetsArrayDataSource;
    
    self.tableView.dataSource = _tweetsArrayDataSource;
    [self.tableView reloadData];
}

- (TableViewCellConfigureBlock)tweetCellConfigureBlock
{
    if (!_tweetCellConfigureBlock) {
        _tweetCellConfigureBlock = ^(TweetCell *tweetCell, Tweet *tweet) {
            [tweetCell configureForTweet:tweet];
        };
    }
    return _tweetCellConfigureBlock;
}

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupTableView];
    
    [self refreshTweets];
}

- (void)setupTableView
{
    [self.tableView registerNib:[TweetCell nib] forCellReuseIdentifier:[TweetCell identifier]];
}

#pragma mark - IBActions

- (IBAction)refreshTweets
{
    [self.refreshControl beginRefreshing];
    
    [[TwitterManager sharedManager] fetchTweetsWithSuccess:^(NSArray *tweets) {
        [self.refreshControl endRefreshing];
        
        self.tweetsArrayDataSource = [[ArrayDataSource alloc] initWithItems:tweets
                                                             cellIdentifier:[TweetCell identifier]
                                                         configureCellBlock:self.tweetCellConfigureBlock];
    } failure:^(NSError *error) {
        [self.refreshControl endRefreshing];
        
        [TSMessage showNotificationInViewController:self
                                              title:@"Error"
                                           subtitle:[error localizedDescription]
                                               type:TSMessageNotificationTypeError];
        
        NSLog(@"Error fetching tweets: %@", [error localizedDescription]);
    }];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter://"]]) {
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        Tweet *tweet = [self.tweetsArrayDataSource itemAtIndexPath:indexPath];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"twitter://status?id=%@", tweet.identifier]]];
    } else {
        [self performSegueWithIdentifier:TweetDetailSegueIdentifier sender:[tableView cellForRowAtIndexPath:indexPath]];
    }
}

#pragma mark - Navigation

static NSString * const TweetDetailSegueIdentifier = @"Tweet Detail";

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
    
    if ([viewController isKindOfClass:[FanSiteTweetDetailViewController class]]) {
        if (![segueIdentifier length] || [segueIdentifier isEqualToString:TweetDetailSegueIdentifier]) {
            if (indexPath) {
                Tweet *tweet = [self.tweetsArrayDataSource itemAtIndexPath:indexPath];
                
                [self prepareTweetDetailViewController:viewController withTweet:tweet];
            }
        }
    }
}

- (void)prepareTweetDetailViewController:(FanSiteTweetDetailViewController *)viewController withTweet:(Tweet *)tweet
{
    viewController.tweetURL = tweet.tweetURL;
}

@end
