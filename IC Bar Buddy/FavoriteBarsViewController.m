//
//  FavoriteBarsViewController.m
//  IC Bar Buddy
//
//  Created by Charles Okpala on 3/26/14.
//  Copyright (c) 2014 Charles Okpala. All rights reserved.
//

#import "FavoriteBarsViewController.h"
#import "BarInfoViewController.h"
#import "Bar.h"
#import "CurrentUser.h"
#import <Parse/Parse.h>

@interface FavoriteBarsViewController ()
@property (strong, nonatomic) CurrentUser *curUser;
@property (strong, nonatomic) UILabel *label;
@end

@implementation FavoriteBarsViewController


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


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.curUser.favoriteBars.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"favoriteBarCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    UILabel *barNameLabel = (UILabel*) [cell viewWithTag:101];
    barNameLabel.text = [self.curUser.favoriteBars objectAtIndex:indexPath.row][1];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Bars"];
    [query getObjectInBackgroundWithId:[self.curUser.favoriteBars objectAtIndex:indexPath.row][0] block:^(PFObject *object, NSError *error) {
        UILabel *numCheckedInLabel = (UILabel*) [cell viewWithTag:102];
        numCheckedInLabel.text = [NSString stringWithFormat:@"%@", [object objectForKey:@"Number_Checked_in"]];
        
    }];
    
    // Configure the cell
    return cell;
}


- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.label=  [[UILabel alloc] initWithFrame: CGRectMake(0, 0, 235, 20)];
    [self.label setCenter:self.view.center];
    [self.label setFont:[UIFont fontWithName:@"AvenirNextCondensed-Medium" size:20]];
    if (self.curUser.favoriteBars.count == 0){
        self.label.text = @"You have no favorite bars saved.";
    }
    else{
        self.label.text = @"";
    }
    [self.view addSubview:self.label];
    
   
        [NSTimer scheduledTimerWithTimeInterval: 10.0 target: self
                                   selector: @selector(callAfterTenSeconds:) userInfo: nil repeats: YES];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    
}


-(void) callAfterTenSeconds:(NSTimer*)t
{
    if ([self isViewLoaded] && self.view.window) {
    if ([self.curUser.favoriteBars count] == 0){
        self.label.text = @"You have no favorite bars saved.";
    }
    else{
        self.label.text = @"";
    }
    
    [self.tableView reloadData];
    }
    
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([self.curUser.favoriteBars count] == 0){
        self.label.text = @"You have no favorite bars saved.";
    }
    else{
        self.label.text = @"";
    }

    [self.tableView reloadData];
    
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showFavoriteBarInfo"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        BarInfoViewController *destViewController = segue.destinationViewController;
        
        Bar *bar = [[Bar alloc] init];
        bar.barName = [self.curUser.favoriteBars objectAtIndex:indexPath.row][1];
        bar.barHours = [self.curUser.favoriteBars objectAtIndex:indexPath.row][3];
        bar.barPhone = [self.curUser.favoriteBars objectAtIndex:indexPath.row][4];
        bar.barAddress = [self.curUser.favoriteBars objectAtIndex:indexPath.row][2];
        bar.barID = [self.curUser.favoriteBars objectAtIndex:indexPath.row][0];
        bar.barImage = [self.curUser.favoriteBars objectAtIndex:indexPath.row][5];
        
        PFQuery *query3 = [PFQuery queryWithClassName:@"Bars"];
        [query3 getObjectInBackgroundWithId:[self.curUser.favoriteBars objectAtIndex:indexPath.row][0] block:^(PFObject *object, NSError *error) {
            bar.NumberCheckedIn = [object objectForKey:@"Number_Checked_in"];
            //NSLog(@"%@", bar.NumberCheckedIn);
        }];
        
        destViewController.bar = bar;
        
    }
}


@end
