//
//  LoginViewController.h
//  IC Bar Buddy
//
//  Created by Charles Okpala on 4/2/14.
//  Copyright (c) 2014 Charles Okpala. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface LoginViewController :  UIViewController <FBLoginViewDelegate> 

@property (weak, nonatomic) IBOutlet UIButton *enterAppButton;


@end
