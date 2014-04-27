//
//  BarInfoViewController.m
//  IC Bar Buddy
//
//  Created by Admin on 4/9/14.
//  Copyright (c) 2014 Charles Okpala. All rights reserved.
//

#import "BarInfoViewController.h"
#import "CurrentUser.h"

@interface BarInfoViewController ()
@property (strong, nonatomic) CurrentUser *curUser;
@property (strong, nonatomic) NSString *curBar;

@end

@implementation BarInfoViewController

@synthesize barNameLabel;
@synthesize barAddressLabel;
@synthesize barHoursLabel;
@synthesize barPhoneLabel;
@synthesize bar;

- (CurrentUser *) curUser {
	if (!_curUser){
		_curUser = [[CurrentUser alloc] init];
        self.curUser = [CurrentUser sharedInstance];
        
    }
	return _curUser;
}

- (IBAction)CheckIn:(id)sender {
    
    if([[self.checkInButton currentTitle]isEqualToString:@"Check-in" ]){
        PFQuery *query = [PFQuery queryWithClassName:@"Bars"];
        [query getObjectInBackgroundWithId:bar.barID block:^(PFObject *curBar, NSError *error) {
            // Do something with the returned PFObject in the gameScore variable.
            NSLog(@"%@", curBar);
            int amount = [[curBar objectForKey:@"Number_Checked_in"] intValue] + 1;
            [curBar setObject:[NSNumber numberWithInt:amount] forKey:@"Number_Checked_in"];
            [curBar saveInBackground];
            self.NumberOfPeopleCheckedInLabel.text = [NSString stringWithFormat:@"%@" , curBar[@"Number_Checked_in"]];
        }];
        [self.checkInButton setTitle:@"Check-out" forState:UIControlStateNormal];
        //redish color
        [self.checkInButton setTitleColor:[UIColor colorWithRed:(237.0/255) green:(109.0/255) blue:(85.0/255) alpha:1.0 ] forState:UIControlStateNormal];
        
        PFQuery *query2 = [PFQuery queryWithClassName:@"Users"];
        [query2 getObjectInBackgroundWithId:self.curUser.userDatabaseID block:^(PFObject *user, NSError *error) {
            // Do something with the returned PFObject in the gameScore variable.
            //NSLog(@"%@", user);
            
            //if the user is checking into a bar and their Current Bar status is "NA"
            if ([self.curUser.currentBar isEqualToString:@"NA"]){
                 NSLog(@"Not at a bar");
                
                [user setObject:bar.barName forKey:@"CurrentBar"];/*
                NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
                [dateformate setDateFormat:@"EEEE, dd MMMM yyyy hh:mm a"];
                NSString *date_String=[dateformate stringFromDate:[NSDate date]];
                 */
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateStyle:NSDateFormatterLongStyle];
                [formatter setTimeStyle:NSDateFormatterLongStyle];
                
                NSLog(@"%@", [formatter stringFromDate:[NSDate date]]);
                NSString *date_String = [formatter stringFromDate:[NSDate date]];
                [user setObject:date_String forKey:@"TimeCheckedIn"];
                [user addUniqueObject:@[bar.barName, date_String] forKey:@"BarActivity"];
                
                [user saveInBackground];
                self.curUser.userBarActivity =[[user[@"BarActivity"] reverseObjectEnumerator] allObjects];
                self.curUser.currentBar = user[@"CurrentBar"];
                
                
            
            //When a user checks into a new bar, need to decrease the Number_checked_in of the previous bar by 1. Whenever the Current Bar status is equal to anything other than "NA"
            }else {
                NSLog(@"In Bar");
                PFQuery *CheckOut = [PFQuery queryWithClassName:@"Bars"];
                [CheckOut whereKey:@"Name" equalTo:self.curUser.currentBar];
                [CheckOut findObjectsInBackgroundWithBlock:^(NSArray *curBar, NSError *error) {
                    // Do something with the returned PFObject in the gameScore variable.
                    //NSLog(@"%@", [[curBar objectAtIndex:0] objectId]);
                    [CheckOut getObjectInBackgroundWithId:[[curBar objectAtIndex:0] objectId] block:^(PFObject *curBar, NSError *error) {
                        // Do something with the returned PFObject in the gameScore variable.
                        //NSLog(@"%@", curBar);
                        int amount = [[curBar objectForKey:@"Number_Checked_in"] intValue] - 1;
                        [curBar setObject:[NSNumber numberWithInt:amount] forKey:@"Number_Checked_in"];
                        [curBar saveInBackground];
                      
                        
                    }];
                }];
                /**/
                //NSLog(@"%@", self.curUser.currentBar);
                [user setObject:bar.barName forKey:@"CurrentBar"];
                //self.curUser.currentBar = user[@"CurrentBar"];
                //self.curUser.userBarActivity = user[@"BarActivity"];
                /*
                NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
                [dateformate setDateFormat:@"EEEE, dd MMMM yyyy hh:mm a"];
                NSString *date_String=[dateformate stringFromDate:[NSDate date]];
                [user setObject:date_String forKey:@"TimeCheckedIn"];
                 */
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateStyle:NSDateFormatterLongStyle];
                [formatter setTimeStyle:NSDateFormatterLongStyle];
                
                NSLog(@"%@", [formatter stringFromDate:[NSDate date]]);
                NSString *date_String = [formatter stringFromDate:[NSDate date]];
                [user addUniqueObject:@[bar.barName, date_String] forKey:@"BarActivity"];
                [user saveInBackground];
                self.curUser.currentBar = user[@"CurrentBar"];
                self.curUser.userBarActivity =[[user[@"BarActivity"] reverseObjectEnumerator] allObjects];
                
            }
            
        }];
        
       
    }
    else{
        PFQuery *query = [PFQuery queryWithClassName:@"Bars"];
        [query getObjectInBackgroundWithId:bar.barID block:^(PFObject *curBar, NSError *error) {
            // Do something with the returned PFObject in the gameScore variable.
            //NSLog(@"%@", curBar);
            int amount = [[curBar objectForKey:@"Number_Checked_in"] intValue] - 1;
            [curBar setObject:[NSNumber numberWithInt:amount] forKey:@"Number_Checked_in"];
            [curBar saveInBackground];
            self.NumberOfPeopleCheckedInLabel.text = [NSString stringWithFormat:@"%@" , curBar[@"Number_Checked_in"]];
            
        }];
        [self.checkInButton setTitle:@"Check-in" forState:UIControlStateNormal];
        //greenish color
        [self.checkInButton setTitleColor:[UIColor colorWithRed:(94.0/255) green:(255.0/255) blue:(169.0/255) alpha:1.0 ] forState:UIControlStateNormal];
        
        
        PFQuery *query2 = [PFQuery queryWithClassName:@"Users"];
        [query2 getObjectInBackgroundWithId:self.curUser.userDatabaseID block:^(PFObject *user, NSError *error) {
            // Do something with the returned PFObject in the gameScore variable.
            //NSLog(@"%@", user);
            [user setObject:@"NA" forKey:@"CurrentBar"];
            [user setObject:@"NA" forKey:@"TimeCheckedIn"];
            [user saveInBackground];
            self.curUser.userBarActivity =[[user[@"BarActivity"] reverseObjectEnumerator] allObjects] ;
            self.curUser.currentBar = user[@"CurrentBar"];
            
        }];
        
    }
    

}

- (IBAction)backButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)addToFavorites:(id)sender {
    
    if([[self.addToFavorites currentTitle]isEqualToString:@"Add to Favorites" ]){
        //find the curent user
        PFQuery *query3 = [PFQuery queryWithClassName:@"Users"];
        [query3 getObjectInBackgroundWithId:self.curUser.userDatabaseID block:^(PFObject *user2, NSError *error) {
            // Do something with the returned PFObject in the gameScore variable.
            //NSLog(@"%@", user2);
            //add the bar to the Favorites array in the Users table
            [user2 addUniqueObject:@[bar.barID, bar.barName, bar.barAddress, bar.barHours, bar.barPhone] forKey:@"Favorites"];
            [user2 saveInBackground];
            self.curUser.favoriteBars = user2[@"Favorites"];
        }];
        //change the button
        [self.addToFavorites setTitle:@"Remove from Favorites" forState:UIControlStateNormal];
        //redish color
        [self.addToFavorites setTitleColor:[UIColor colorWithRed:(237.0/255) green:(109.0/255) blue:(85.0/255) alpha:1.0 ] forState:UIControlStateNormal];
        
    }
    else{
        //find the curent user
        PFQuery *query4 = [PFQuery queryWithClassName:@"Users"];
        [query4 getObjectInBackgroundWithId:self.curUser.userDatabaseID block:^(PFObject *user3, NSError *error) {
            // Do something with the returned PFObject in the gameScore variable.
            //NSLog(@"%@", user3);
            //add the bar to the Favorites array in the Users table
            [user3 removeObject:@[bar.barID, bar.barName, bar.barAddress, bar.barHours, bar.barPhone] forKey:@"Favorites"];
            [user3 saveInBackground];
            self.curUser.favoriteBars = user3[@"Favorites"];
        }];
        //change the button
        [self.addToFavorites setTitle:@"Add to Favorites" forState:UIControlStateNormal];
        //greenish color
        [self.addToFavorites setTitleColor:[UIColor colorWithRed:(94.0/255) green:(255.0/255) blue:(169.0/255) alpha:1.0 ] forState:UIControlStateNormal];
    
    }
}




- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.barAddressLabel.text = [NSString stringWithFormat:@"%@", bar.barAddress];
    self.barNameLabel.text = bar.barName;
    self.barPhoneLabel.text = [NSString stringWithFormat:@"%@", bar.barPhone];
    self.barHoursLabel.text = [NSString stringWithFormat:@"%@", bar.barHours];
    PFQuery *numCheckedIn = [PFQuery queryWithClassName:@"Bars"];
    [numCheckedIn getObjectInBackgroundWithId:bar.barID block:^(PFObject *object, NSError *error) {
        self.NumberOfPeopleCheckedInLabel.text = [NSString stringWithFormat:@"%@", [object objectForKey:@"Number_Checked_in"]];
        NSLog(@"favorites page %@", bar.NumberCheckedIn);
    }];
    NSInteger amount = 0;
    NSInteger position = 0;
    for (PFObject *item in self.curUser.usersInfo){
       // NSLog(@"%@ -", item);
       
        //NSLog(@"%@", self.curBar);
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid == %@", item[@"FacebookID"]];
        NSArray *matchingObjs = [self.curUser.userFriends filteredArrayUsingPredicate:predicate];
        if(matchingObjs.count > 0 && [item[@"CurrentBar"] isEqualToString:bar.barName]){
            amount++;
            if (position < 220){
                UIImageView *imageHolder = [[UIImageView alloc] initWithFrame:CGRectMake(position, 0, 25, 25)];
                 //NSLog(@"%@ -", [matchingObjs objectAtIndex:0]);
                UIImage *image = [UIImage imageWithData:
                                  [NSData dataWithContentsOfURL:
                                   [NSURL URLWithString:
                                    item[@"FacebookPicture"]]]];
                imageHolder.image = image;
                [self.friendsView addSubview:imageHolder];
                position = position + 30;
                NSLog(@"was here");
            }
        }
    }
    self.NumberOfFriendsCheckedInLabel.text = [NSString stringWithFormat:@"%ld", (long)amount];
    
    //NSLog(@"%@ -", self.curUser.currentBar);
    if ([self.curUser.currentBar isEqualToString:bar.barName]){
        [self.checkInButton setTitle:@"Check-out" forState:UIControlStateNormal];
        //redish color
        [self.checkInButton setTitleColor:[UIColor colorWithRed:(237.0/255) green:(109.0/255) blue:(85.0/255) alpha:1.0 ] forState:UIControlStateNormal];
    }
    
    if([self.curUser.favoriteBars containsObject:@[bar.barID, bar.barName, bar.barAddress, bar.barHours, bar.barPhone]]){
        [self.addToFavorites setTitle:@"Remove from Favorites" forState:UIControlStateNormal];
        //redish color
        [self.addToFavorites setTitleColor:[UIColor colorWithRed:(237.0/255) green:(109.0/255) blue:(85.0/255) alpha:1.0 ] forState:UIControlStateNormal];
    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
