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

@end

@implementation FavoriteBarsViewController


- (CurrentUser *) curUser {
	if (!_curUser){
		_curUser = [[CurrentUser alloc] init];
        self.curUser = [CurrentUser sharedInstance];
        
    }
	return _curUser;
}



- (id)initWithCoder:(NSCoder *)aCoder

{
	self = [super initWithCoder:aCoder];
	if (self) {
        // Custom the table
        
        // The className to query on
        self.parseClassName = @"Users";
        
        // The key of the PFObject to display in the label of the default cell style
        self.textKey = @"Favorites";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // The number of objects to show per page
        self.objectsPerPage = 50;
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    if (self.curUser.favoriteBars.count == 0){
        //[self.tableView setHidden:YES];
        
        UILabel *label =  [[UILabel alloc] initWithFrame: CGRectMake(0, 200, 250, 20)];
        label.text = @"You have no favorite bars saved";
        [label setCenter:self.tableView.center];
        [self.view addSubview:label];
        
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //NSLog(@"viewDidAppear called");
    [self loadObjects];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Parse

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    
    // This method is called every time objects are loaded from Parse via the PFQuery
    
}

- (void)objectsWillLoad {
    [super objectsWillLoad];
    
    // This method is called before a PFQuery is fired to get more objects
}


// Override to customize what kind of query to perform on the class. The default is to query for
// all objects ordered by createdAt descending.
- (PFQuery *)queryForTable {
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    [query whereKey:@"objectId" equalTo:self.curUser.userDatabaseID];
    
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    if ([self.objects count] == 0) {
      query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    //[query orderByAscending:[self.curUser.favoriteBars objectAtIndex:indexPath.row][1]];
    return query;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.curUser.favoriteBars.count;
}



// Override to customize the look of a cell representing an object. The default is to display
// a UITableViewCellStyleDefault style cell with the label being the first key in the object.
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
        
        PFQuery *query3 = [PFQuery queryWithClassName:@"Bars"];
        [query3 getObjectInBackgroundWithId:[self.curUser.favoriteBars objectAtIndex:indexPath.row][0] block:^(PFObject *object, NSError *error) {
            bar.NumberCheckedIn = [object objectForKey:@"Number_Checked_in"];
            //NSLog(@"%@", bar.NumberCheckedIn);
        }];
        
        destViewController.bar = bar;
        
    }
}

@end
