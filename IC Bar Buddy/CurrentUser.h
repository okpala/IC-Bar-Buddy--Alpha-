//
//  CurrentUser.h
//  CardGame1
//
//  Created by Charles Okpala on 2/26/14.
//  Copyright (c) 2014 Charles Okpala. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>
#import <Parse/Parse.h>
@interface CurrentUser : NSObject
+(CurrentUser *) sharedInstance;

@property (strong, nonatomic) NSString *profilePictureView;
@property (strong, nonatomic)  NSString *user;
@property (strong, nonatomic)  NSString *userDatabaseID;
@property (strong, nonatomic)  NSArray *userFriends;
@property (strong, nonatomic)  NSArray *selectedFriend;
@property (strong, nonatomic)  NSString *selectedFriendBar;
@property (strong, nonatomic) NSArray *usersInfo;
@property (strong, nonatomic) NSArray *userBarActivity;
@property (strong, nonatomic)  NSNumber *IsUserInABar;
@property (strong, nonatomic)  NSString *currentBar;
@property (strong, nonatomic) NSArray *favoriteBars;


@end
