//
//  FriendInfoViewController.m
//  IC Bar Buddy
//
//  Created by Charles Okpala on 4/14/14.
//  Copyright (c) 2014 Charles Okpala. All rights reserved.
//

#import "FriendInfoViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "Friend.h"
#import "CurrentUser.h"

@interface FriendInfoViewController ()
@property (strong, nonatomic) Friend *selectedFriend;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (strong, nonatomic) CurrentUser *curUser;
@property (strong, nonatomic) UILabel *label;
@end

@implementation FriendInfoViewController

- (Friend *) selectedFriend {
	if (!_selectedFriend){
		_selectedFriend = [[Friend alloc] init];
        self.selectedFriend = [Friend sharedInstance];
        
    }
	return _selectedFriend;
}

- (CurrentUser *) curUser {
	if (!_curUser){
		_curUser = [[CurrentUser alloc] init];
        self.curUser = [CurrentUser sharedInstance];
        
    }
	return _curUser;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)backButtonPress:(id)sender {
     [self dismissViewControllerAnimated:YES completion:nil];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.curUser.selectedFriend count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"BarActivityCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    //need to have the cells filled in the opposite order so that the most recent check-ins are displayed at the top of the tableview instead of the bottom
    
    UILabel *activityLabel1 = (UILabel*) [cell viewWithTag:101];
    activityLabel1.text = [NSString stringWithFormat:@"%@ ",[self.curUser.selectedFriend objectAtIndex:indexPath.row][0]];
    
    UILabel *activityLabel2 = (UILabel*) [cell viewWithTag:102];
    activityLabel2.text = [self.curUser.selectedFriend objectAtIndex:indexPath.row][1] ;
    
    return cell;
}

-(void) callAfterASecond:(NSTimer*)t
{
    [self displayLabel];
    [self.tableView reloadData];
    
    if ([self.curUser.selectedFriendBar isEqualToString: @"NA"] || self.curUser.selectedFriendBar == NULL){
        self.currentBar.text = @"Currently not checked-in";
    }
    else{
        self.currentBar.text= [NSString stringWithFormat:@"Currently @ %@", self.curUser.selectedFriendBar];
    }
    //NSLog(@"red");
}

//BRITTANY DESIGN THIS LABEL
- (void)displayLabel{
    if ([self.curUser.selectedFriend count] == 0){
        //[self.tableView setHidden:YES];
        self.label.text = @"There is no pervious activity saved";
        
    }
    else{
        self.label.text = @"";
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [NSTimer scheduledTimerWithTimeInterval: 1.0 target: self
                                   selector: @selector(callAfterASecond:) userInfo: nil repeats: YES];
    
    self.friendLabel.text = self.selectedFriend.user;

    self.tableView.dataSource = self;
    self.friendLabel.text = self.selectedFriend.user;
    [self.profileImage setImage: [UIImage imageWithData:
                                  [NSData dataWithContentsOfURL:
                                   [NSURL URLWithString:
                                    self.selectedFriend.profilePictureView]]]];
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.label =  [[UILabel alloc] initWithFrame: CGRectMake(0, 200, 250, 20)];
    [self.label setCenter:self.tableView.center];
    [self.view addSubview:self.label];
    self.label.numberOfLines = 2;
    [self.label sizeToFit];
    
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
