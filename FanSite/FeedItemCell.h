//
//  FeedItemCell.h
//  FanSite
//
//  Created by Philip Nichols on 8/19/14.
//  Copyright (c) 2014 Phil Nichols. All rights reserved.
//

#import "CustomUITableViewCell.h"

@interface FeedItemCell : CustomUITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *feedItemTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *feedItemDateLabel;

@end
