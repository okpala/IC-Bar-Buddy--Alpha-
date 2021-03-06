//
//  BarsListViewController.m
//  IC Bar Buddy
//
//  Created by Charles Okpala on 3/26/14.
//  Copyright (c) 2014 Charles Okpala. All rights reserved.
//

#import "BarsListViewController.h"
#import "BarInfoViewController.h"
#import "Bar.h"
#import <Parse/Parse.h>
#import "CurrentUser.h"

@interface BarsListViewController ()
@property (strong, nonatomic) CurrentUser *curUser;
@end

@implementation BarsListViewController

- (CurrentUser *) curUser {
	if (!_curUser){
		_curUser = [[CurrentUser alloc] init];
        self.curUser = [CurrentUser sharedInstance];
        
    }
	return _curUser;
}


/*
- (id)initWithCoder:(NSCoder *)aCoder

{
	self = [super initWithCoder:aCoder];
	if (self) {
        // Custom the table
        
        // The className to query on
        self.parseClassName = @"Bars";
        
        // The key of the PFObject to display in the label of the default cell style
        self.textKey = @"Name";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // The number of objects to show per page
        self.objectsPerPage = 50;
    }
    return self;
}
*/
#pragma mark - View lifecycle
-(void) callAfterTenSeconds:(NSTimer*)t
{
    if ([self isViewLoaded] && self.view.window) {
    //NSLog(@"HEY");
    PFQuery *query2 = [PFQuery queryWithClassName:@"Bars"];
    [query2 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            
            NSSortDescriptor * sort = [[NSSortDescriptor alloc] initWithKey:@"Number_Checked_in" ascending:true] ;
            self.curUser.barObject = [[[objects sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]] reverseObjectEnumerator]  allObjects];
            
        }
    }];

    [self.tableView reloadData];
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.dataSource = self;
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    //NSLog(@"%@", self.curUser.barObject);
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.tableView.contentInset = UIEdgeInsetsMake(0., 0., CGRectGetHeight(self.tabBarController.tabBar.frame), 0);
    
        [NSTimer scheduledTimerWithTimeInterval: 1.0 target: self
                                   selector: @selector(callAfterTenSeconds:) userInfo: nil repeats: YES];
        
        

     
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //[self.tableView reloadData];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    

    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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
/*
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
    
    
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    if ([self.objects count] == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    //want to find a way to order by number_checked_in and then by bar name
    [query orderByDescending:@"Number_Checked_in"];
    
    return query;
}



// Override to customize the look of a cell representing an object. The default is to display
// a UITableViewCellStyleDefault style cell with the label being the first key in the object.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    static NSString *CellIdentifier = @"barCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell
    UILabel *barNameLabel = (UILabel*) [cell viewWithTag:101];
    barNameLabel.text = [object objectForKey:@"Name"];
    
    UILabel *numCheckedInLabel = (UILabel*) [cell viewWithTag:102];
    numCheckedInLabel.text = [NSString stringWithFormat:@"%@", [object objectForKey:@"Number_Checked_in"]];
    
    return cell;
}
*/

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"barCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    UILabel *barNameLabel = (UILabel*) [cell viewWithTag:101];
    
    barNameLabel.text = [self.curUser.barObject objectAtIndex:indexPath.row][@"Name"];
    
    UILabel *numCheckedInLabel = (UILabel*) [cell viewWithTag:102];
    numCheckedInLabel.text = [ NSString stringWithFormat:@"%@",[self.curUser.barObject objectAtIndex:indexPath.row][@"Number_Checked_in"]];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.curUser.barObject.count;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //if ([segue.identifier isEqualToString:@"showBarInfo"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        BarInfoViewController *destViewController = segue.destinationViewController;
       
        Bar *bar = [[Bar alloc] init];
        bar.barID =  [[self.curUser.barObject objectAtIndex:indexPath.row] objectId];
        //NSLog(@"%@", bar.barID);
        bar.barName = [self.curUser.barObject objectAtIndex:indexPath.row][@"Name"];//[object objectForKey:@"Name"];
        //NSLog(@"%@", bar.barName);
        bar.barHours = [self.curUser.barObject objectAtIndex:indexPath.row][@"Hours"];//[object objectForKey:@"Hours"];
        bar.barPhone = [self.curUser.barObject objectAtIndex:indexPath.row][@"Phone"];//[object objectForKey:@"Phone"];
        bar.barAddress = [self.curUser.barObject objectAtIndex:indexPath.row][@"Address"];//[object objectForKey:@"Address"];
        bar.barImage = [self.curUser.barObject objectAtIndex:indexPath.row][@"imageFile"];//[object objectForKey:@"imageFile"];
         //NSLog(@"%@", bar.barImage);
        bar.NumberCheckedIn = [self.curUser.barObject objectAtIndex:indexPath.row][@"Number_Checked_in"];//[object objectForKey:@"Number_Checked_in"];
        //bar.barObject = self.objects;
        //NSLog(@"barID - %@", bar.barID);
        destViewController.bar = bar;
        
        
        
    //}
}

@end