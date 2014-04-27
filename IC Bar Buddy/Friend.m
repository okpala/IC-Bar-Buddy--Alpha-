//
//  Friend.m
//  IC Bar Buddy
//
//  Created by Charles Okpala on 4/14/14.
//  Copyright (c) 2014 Charles Okpala. All rights reserved.
//

#import "Friend.h"

@implementation Friend
static Friend* theSharedInstance;

+(Friend *) sharedInstance {
	if (!theSharedInstance)
		theSharedInstance = [[Friend alloc] init];
	return theSharedInstance;
}

@end
