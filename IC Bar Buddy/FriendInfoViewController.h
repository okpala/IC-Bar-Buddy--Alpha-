//
//  FriendInfoViewController.h
//  IC Bar Buddy
//
//  Created by Charles Okpala on 4/14/14.
//  Copyright (c) 2014 Charles Okpala. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
@interface FriendInfoViewController : UIViewController <UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *friendLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentBar;
@end
