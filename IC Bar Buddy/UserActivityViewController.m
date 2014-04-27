//
//  UserActivityViewController.m
//  IC Bar Buddy
//
//  Created by Charles Okpala on 3/26/14.
//  Copyright (c) 2014 Charles Okpala. All rights reserved.
//

#import "UserActivityViewController.h"
#import "CurrentUser.h"
#import <FacebookSDK/FacebookSDK.h>
@interface UserActivityViewController ()
@property (strong, nonatomic) CurrentUser *curUser;
@property (strong, nonatomic) IBOutlet FBProfilePictureView *profilePictureView;
@end

@implementation UserActivityViewController

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



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.curUser.userBarActivity count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *cellIdentifier = @"SettingsCell";
    //NSLog(@"%@", );
    
    //need to have the cells filled in the opposite order so that the most recent check-ins are displayed at the top of the tableview instead of the bottom
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    UILabel *activityLabel1 = (UILabel*) [cell viewWithTag:101];
    activityLabel1.text = [NSString stringWithFormat:@"%@ ",[self.curUser.userBarActivity objectAtIndex:indexPath.row][0]];
    
    UILabel *activityLabel2 = (UILabel*) [cell viewWithTag:102];
    activityLabel2.text = [self.curUser.userBarActivity objectAtIndex:indexPath.row][1];
    
    
    
    return cell;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.dataSource = self;
    self.userLabel.text = self.curUser.user;
    self.profilePictureView.profileID = self.curUser.profilePictureView;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    if ([self.curUser.userBarActivity count] == 0){
        //[self.tableView setHidden:YES];
        
        UILabel *label =  [[UILabel alloc] initWithFrame: CGRectMake(0, 200, 250, 20)];
        label.text = @"You have no previous activity";
        [label setCenter:self.tableView.center];
        [self.view addSubview:label];
        
    }
    
    [self LoadWindow];
  
}
- (void)LoadWindow{
    if ([self.curUser.currentBar isEqualToString: @"NA"]){
        self.CurrentBarLablel.text = @"Checked-in nowhere";
        NSLog(@"%@", self.curUser.currentBar);
    }
    else{
        self.CurrentBarLablel.text= [NSString stringWithFormat:@"Checked-in @ %@", self.curUser.currentBar];
        NSLog(@"%@", self.curUser.currentBar);
    }

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //NSLog(@"viewDidAppear called");
    [self LoadWindow];
    [self.tableView reloadData];
    
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
