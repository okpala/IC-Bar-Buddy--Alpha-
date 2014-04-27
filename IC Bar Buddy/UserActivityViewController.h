//
//  UserActivityViewController.h
//  IC Bar Buddy
//
//  Created by Charles Okpala on 3/26/14.
//  Copyright (c) 2014 Charles Okpala. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserActivityViewController : UIViewController <UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UILabel *CurrentBarLablel;

@end
