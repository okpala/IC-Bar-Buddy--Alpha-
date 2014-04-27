//
//  Bar.h
//  IC Bar Buddy
//
//  Created by Admin on 4/9/14.
//  Copyright (c) 2014 Charles Okpala. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface Bar : NSObject

@property (nonatomic, strong) NSString *barName;
@property (nonatomic, strong) NSString *barAddress;
@property (nonatomic, strong) NSString *barHours;
@property (nonatomic, strong) NSString *barPhone;
@property (nonatomic, strong) NSString *barID;
@property (nonatomic, strong) NSString *NumberCheckedIn;
@property (nonatomic, strong) NSArray *barObject;
@end
