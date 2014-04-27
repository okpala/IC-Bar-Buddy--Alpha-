//
//  CurrentUser.m
//  CardGame1
//
//  Created by Charles Okpala on 2/26/14.
//  Copyright (c) 2014 Charles Okpala. All rights reserved.
//

#import "CurrentUser.h"

@implementation CurrentUser

static CurrentUser* theSharedInstance;

+(CurrentUser *) sharedInstance {
	if (!theSharedInstance)
		theSharedInstance = [[CurrentUser alloc] init];
	return theSharedInstance;
}


@end
