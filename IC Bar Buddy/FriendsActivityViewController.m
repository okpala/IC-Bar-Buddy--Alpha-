//
//  FriendsActivityViewController.m
//  IC Bar Buddy
//
//  Created by Charles Okpala on 3/26/14.
//  Copyright (c) 2014 Charles Okpala. All rights reserved.
//

#import "FriendsActivityViewController.h"
#import "CurrentUser.h"
#import <FacebookSDK/FacebookSDK.h>
#import "Friend.h"

@interface FriendsActivityViewController ()

@property (strong, nonatomic) CurrentUser *curUser;
@property (strong, nonatomic) Friend *selectedFriend;
@property (strong, nonatomic) UILabel *label;

@end

@implementation FriendsActivityViewController

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
-(void) callAfterTenSeconds:(NSTimer*)t
{
    if ([self isViewLoaded] && self.view.window) {
    NSString *query = [NSString stringWithFormat:@"SELECT name,uid, pic_small, pic_square FROM user WHERE is_app_user = 1 AND uid IN (SELECT uid2 FROM friend WHERE uid1 = %@) order by concat(first_name,last_name) asc", self.curUser.profilePictureView];
    // Set up the query parameter
    NSDictionary *queryParam = @{ @"q": query };
    // Make the API request that uses FQL
    [FBRequestConnection startWithGraphPath:@"/fql"
                                 parameters:queryParam
                                 HTTPMethod:@"GET"
                          completionHandler:^(FBRequestConnection *connection,
                                              id result,
                                              NSError *error) {
                              if (error) {
                                  NSLog(@"Error: %@", [error localizedDescription]);
                              } else {
                                  //NSLog(@"Result: %@", result);
                                  // Get the friend data to display
                                  self.curUser.userFriends = (NSArray *) result[@"data"];
                                  ;
                                  
                              }
                          }];
    PFQuery *query2 = [PFQuery queryWithClassName:@"Users"];
    [query2 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            self.curUser.usersInfo = objects;
            
        } else {
            
        }
    }];
   
    if (self.curUser.userFriends.count == 0){
        self.label.text = @"   None of your Facebook Friends have this app Installed.";
    }
    else{
        self.label.text = @"";
    }

    [self.tableView reloadData];
    }
}


- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.tableView.contentInset = UIEdgeInsetsMake(0., 0., CGRectGetHeight(self.tabBarController.tabBar.frame), 0);
    
    // Do any additional setup after loading the view.
    self.tableView.dataSource = self;
    
    [NSTimer scheduledTimerWithTimeInterval: 1.0 target: self
selector: @selector(callAfterTenSeconds:) userInfo: nil repeats: YES];

    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.label =  [[UILabel alloc] initWithFrame: CGRectMake(0, 150, 304 , 20)];
    //self.label.numberOfLines = 2;
    //[self.label sizeToFit];
    //[self.label setCenter:self.view.center];
     [self.label setFont:[UIFont fontWithName:@"AvenirNextCondensed-Medium" size:15]];
    if (self.curUser.userFriends.count == 0){
        self.label.text = @"   None of your Facebook Friends have this app Installed.";
    }
    else{
       self.label.text = @"";
    }
    [self.tableView addSubview:self.label];
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //return self.friends.count;
    return self.curUser.userFriends.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *cellIdentifier = @"SettingsCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
   
    NSDictionary<FBGraphUser>* friend = [self.curUser.userFriends objectAtIndex:indexPath.row];
    
    UILabel *friendNameLabel = (UILabel*) [cell viewWithTag:103];
    friendNameLabel.text = friend.name;
    
    UIImage *image = [UIImage imageWithData:
                      [NSData dataWithContentsOfURL:
                       [NSURL URLWithString:
                       friend[@"pic_square"]]]];
    cell.imageView.image = image;

    for(NSDictionary *item in self.curUser.usersInfo){
        //NSLog(@"%@", item[@"FacebookID"]);
        if ([friend[@"uid"] isEqualToString: item[@"FacebookID"]]){
            if ([item[@"CurrentBar"] isEqualToString: @"NA"]){
                UILabel *textLabel = (UILabel*) [cell viewWithTag:102];
                textLabel.text = @"- Currently not checked-in";
                
                UILabel *barNameLabel = (UILabel*) [cell viewWithTag:101];
                barNameLabel.text = @"";
            }
            else{
                //cell.detailTextLabel.text = [NSString stringWithFormat:@"Checked-in @ %@", item[@"CurrentBar"]];
                UILabel *textLabel = (UILabel*) [cell viewWithTag:102];
                textLabel.text = @"- Currently @";
                
                UILabel *barNameLabel = (UILabel*) [cell viewWithTag:101];
                barNameLabel.text = [NSString stringWithFormat:@"%@", item[@"CurrentBar"]];
            }
            break;
            
        }
    }
    
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"showFriendInfo"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDictionary<FBGraphUser>* friend = [self.curUser.userFriends objectAtIndex:indexPath.row];
        self.curUser.selectedFriendNumber = [NSNumber numberWithInt:indexPath.row ];
        self.selectedFriend.profilePictureView = friend[@"pic_square"] ;
        self.selectedFriend.user = friend.name;
        PFQuery *query2 = [PFQuery queryWithClassName:@"Users"];
        [query2  whereKey:@"FacebookID" equalTo:friend[@"uid"]];
        
        [query2 findObjectsInBackgroundWithBlock:^(NSArray  *user, NSError *error) {
            self.curUser.selectedFriendBar = [user objectAtIndex:0][@"CurrentBar"];
            self.curUser.selectedFriend = [[[user objectAtIndex:0][@"BarActivity"] reverseObjectEnumerator] allObjects] ;
            
            
        }];

        
 
    }
    
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
