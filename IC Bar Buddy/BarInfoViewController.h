//
//  BarInfoViewController.h
//  IC Bar Buddy
//
//  Created by Admin on 4/9/14.
//  Copyright (c) 2014 Charles Okpala. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Bar.h"

@interface BarInfoViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *BarImage;
@property (weak, nonatomic) IBOutlet UILabel *peopleCheckedIn;

@property (weak, nonatomic) IBOutlet UILabel *barNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *barHoursLabel;
@property (weak, nonatomic) IBOutlet UILabel *barAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *barPhoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *NumberOfPeopleCheckedInLabel;
@property (weak, nonatomic) IBOutlet UIButton *checkInButton;
@property (weak, nonatomic) IBOutlet UILabel *NumberOfFriendsCheckedInLabel;
@property (weak, nonatomic) IBOutlet UIButton *addToFavorites;
@property (weak, nonatomic) IBOutlet UIView *friendsView;


@property (nonatomic, strong) Bar *bar;


@end
