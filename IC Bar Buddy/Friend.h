//
//  Friend.h
//  IC Bar Buddy
//
//  Created by Charles Okpala on 4/14/14.
//  Copyright (c) 2014 Charles Okpala. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Friend : NSObject
+(Friend *) sharedInstance;

@property (strong, nonatomic) NSString *profilePictureView;
@property (strong, nonatomic)  NSString *user;
@end
