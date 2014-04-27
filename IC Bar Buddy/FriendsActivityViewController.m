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




- (void)viewDidLoad
{
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    if (self.curUser.userFriends.count == 0){
        //[self.tableView setHidden:YES];
        
        UILabel *label =  [[UILabel alloc] initWithFrame: CGRectMake(20, 0, 300, 20)];
        label.text = @"None of your Facebook Friends has this app Installed.";
        //label.lineBreakMode = NSLineBreakByWordWrapping;
        label.numberOfLines = 2;
        [label sizeToFit];
        //[label setCenter:self.tableView.center];
        [self.tableView addSubview:label];
        
    }
    
    
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
/*
    NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
    [dateformate setDateFormat:@"EEEE, dd MMMM yyyy"];
    NSString *date_String=[dateformate stringFromDate:[NSDate date]];
    NSLog(@"formattedDateString: %@", date_String);
 */
    for(NSDictionary *item in self.curUser.usersInfo){
        //NSLog(@"%@", item[@"FacebookID"]);
        if ([friend[@"uid"] isEqualToString: item[@"FacebookID"]]){
            if ([item[@"CurrentBar"] isEqualToString: @"NA"]){
                UILabel *textLabel = (UILabel*) [cell viewWithTag:102];
                textLabel.text = @"- Checked-in nowhere";
                
                UILabel *barNameLabel = (UILabel*) [cell viewWithTag:101];
                barNameLabel.text = @"";
            }
            else{
                //cell.detailTextLabel.text = [NSString stringWithFormat:@"Checked-in @ %@", item[@"CurrentBar"]];
                UILabel *textLabel = (UILabel*) [cell viewWithTag:102];
                textLabel.text = @"- Checked-in @";
                
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
